//
//  TaskSequencer
//  TaskSequencer.swift
//
//  Created by Lloyd Newman on 3/20/20.
//  Copyright © 2020 Lloyd Newman. All rights reserved.
//

import Foundation
import QuartzCore

/// The unit of work used by `TaskSequencer`.
public protocol TaskExecutable {

    /// A unique identifier to differentiate between `TaskExecutable` objects.
    var identifier: UUID { get }

    /// An optional `String` that describes the string. Meant to be used for debugging and reporting purposes.
    var description: String? { get }

    /// A function that performs the work associated with the `TaskExecutable`
    /// - Parameter completion: A closure to be executed within the `execute` function definition that indicates to the `TaskSequencer` the completion and result of the task. Failure to call this will result in the `TaskSequence` never completing.
    func execute(_ completion: @escaping CompletionClosure)
}

public extension TaskExecutable {
    typealias Closure = (@escaping CompletionClosure) -> Void
    typealias CompletionClosure = (Result<Void, Error>?) -> Void
}

/// Represents a series of tasks to be executed in an efficient manner. The exact order of execution of tasks is determined by `TaskSequencer` automatically based on individual task dependencies indicated by the user.
/// - Tag: TaskSequencerTag
public final class TaskSequencer {

    /// TaskExecutable: A copy of the completed task. TimeInterval: duration of the task's execution. Float: TaskSequence percent complete
    public typealias TaskCompletionReportClosure = (TaskExecutable, TimeInterval, Float) -> Void
    public typealias CancelClosure = () -> Void
    /// Result: The result of the Task Sequence's execution. TaskExecutable: the last task to finish executing before the Task Sequence completed. If the sequence is a failure, this task will be the task that caused the failure. TimeInterval: The total execution time of the Task Sequence.
    public typealias CompletionClosure = (Result<Void, Error>, TaskExecutable, TimeInterval) -> Void

    /// A concrete type that conforms to `TaskExecutable` that may be used in lieu of a custom type for simple use cases.
    public struct Task: TaskExecutable {
        public let identifier: UUID = UUID()
        public let description: String?

        private var closure: TaskExecutable.Closure

        public init(description: String? = nil, closure: @escaping TaskExecutable.Closure) {
            self.description = description
            self.closure = closure
        }

        public func execute(_ completion: @escaping TaskExecutable.CompletionClosure) {
            self.closure(completion)
        }
    }

    private struct ScheduledTask {
        let task: TaskExecutable
        let dependencies: [TaskExecutable]
        let taskSequenceID: UUID
    }

    public enum SequencerError: Error {
        case taskSequenceAlreadyRunning
        case emptyTaskSequence
        case passedInvalidDependencies([TaskExecutable])
        case attemptedToRegisterDuplicateTask(TaskExecutable)
    }

    /// Represents whether or not the `TaskSequence` is currently running. Note that `isRunning` refers specifically to the status of the `TaskSequence` and not its individual tasks. As an example, if `TaskSequence` execution is cancelled or ends due to failure of an individual task, other tasks from that `TaskSequence` may still be running. In that case, `isRunning` will return `false`.
    /// - Tag: TaskSequencerIsRunningTag
    public private(set) var isRunning: Bool = false {
        didSet {
            self.didChangeRunningState?(isRunning)
        }
    }

    /// A closure which gets called when the value of [isRunning](x-source-tag://TaskSequencerIsRunningTag) gets updated. This can be used by consumers of [TaskSequencer](x-source-tag://TaskSequencerTag) to observe the `isRunning` attribute.
    public var didChangeRunningState: ((Bool) -> Void )?

    /// The queue that all tasks and all related closures will be executed on. Defaults to `main`.
    public var queue: DispatchQueue = DispatchQueue.main

    private let mutex = UnfairLock()

    private var taskCompletionReportClosure: TaskCompletionReportClosure?
    private var cancelClosure: CancelClosure?
    private var completion: CompletionClosure?
    private var scheduledTasks: [ScheduledTask] = []
    private var scheduledTasksLeftToStart: [ScheduledTask] = []
    private var scheduledTasksCompleted: [ScheduledTask] = []
    private var taskStartTimes: [UUID: CFTimeInterval] = [:]
    private var taskSequenceStartTime: CFTimeInterval = CACurrentMediaTime()
    private var taskSequenceID = UUID()

    public init() {}

    /// Registers a `TaskSequencer.Task` to be exectued with the `TaskSequence`.
    /// - Parameters:
    ///   - description: A `String` that could be used to quickly identify the task for debugging and reporting purposes.
    ///   - dependencies: An array of `TaskExecutable`s that represent all work that must be completed before the `Task` being initialized can be executed. Note: all `Task`s passed as dependencies must be present in the `TaskSequence` when registering the initialized `Task` or else an error will be returned.
    ///   - taskClosure: The work to be performed when the `Task` is executed. Note that `TaskSequencer` will maintain a strong reference to this object so care must be taken in this closure to not complete a retain cycle.
    @discardableResult
    public func registerTask(description: String? = nil, dependencies: [TaskExecutable] = [], taskClosure: @escaping TaskExecutable.Closure) throws -> TaskSequencer.Task {
        let task = Task(description: description, closure: taskClosure)
        try self.checkValidityOfRegisteredTask(task: task, dependencies: dependencies)

        let scheduledTask = ScheduledTask(task: task, dependencies: dependencies, taskSequenceID: self.taskSequenceID)
        self.scheduledTasks.append(scheduledTask)

        return task
    }

    /// Registers a task conforming to `TaskExecutable` to be exectued with the `TaskSequence`.
    /// - Parameters:
    ///   - task: The task to be performed. This object must conform to `TaskExecutable` and not have its `identifier` match any task already registered to the `TaskSequence`.
    ///   - dependencies: An array of `TaskExecutable`s that represent all work that must be completed before the `Task` being initialized can be executed. Note: all `Task`s passed as dependencies must be present in the `TaskSequence` when registering the initialized `Task` or else an error will be returned.
    public func registerTask(_ task: TaskExecutable, dependencies: [TaskExecutable] = []) throws {
        try self.checkValidityOfRegisteredTask(task: task, dependencies: dependencies)

        let scheduledTask = ScheduledTask(task: task, dependencies: dependencies, taskSequenceID: self.taskSequenceID)
        self.scheduledTasks.append(scheduledTask)
    }

    private func checkValidityOfRegisteredTask(task: TaskExecutable, dependencies: [TaskExecutable]) throws {
        // Check against this task already being registered
        if self.scheduledTasks.contains(where: { $0.task.identifier == task.identifier }) {
            throw SequencerError.attemptedToRegisterDuplicateTask(task)
        }

        // Ensure all dependencies belong to this instance of TaskSequence.
        let badDependencies: [TaskExecutable] = dependencies.filter { dependency in
            !self.scheduledTasks.contains(where: { $0.task.identifier == dependency.identifier })
        }

        guard badDependencies.isEmpty else {
            throw SequencerError.passedInvalidDependencies(badDependencies)
        }
    }

    /// Kicks off execution of the `TaskSequence`. Tasks will be executed as soon as all dependencies they are reliant on are completed.
    /// - Parameters:
    ///   - reportClosure: Will be executed upon completion of each `TaskExecutable` and passed various metrics such as the time taken to execute the `Task` and the amount of progress completed in the `TaskSequence`.
    ///   - cancelClosure: This is executed after a user-initiated cancel of a currently running `TaskSequence`.
    ///   - completion: Executed upon completion of the `TaskSequence`, whether it is a success or failure.
    public func executeTaskSequence(reportClosure: TaskCompletionReportClosure? = nil, cancelClosure: CancelClosure? = nil, completion: CompletionClosure? = nil) throws {
        try self.mutex.sync {
            guard !self.isRunning else {
                throw SequencerError.taskSequenceAlreadyRunning
            }

            guard !self.scheduledTasks.isEmpty else {
                throw SequencerError.emptyTaskSequence
            }

            // Update existing tasks with the current `taskSequenceID`.
            self.scheduledTasks = self.scheduledTasks.map { ScheduledTask(task: $0.task, dependencies: $0.dependencies, taskSequenceID: self.taskSequenceID) }

            self.taskCompletionReportClosure = reportClosure
            self.cancelClosure = cancelClosure
            self.completion = completion
            self.scheduledTasksLeftToStart = self.scheduledTasks
            self.isRunning = true
            self.taskSequenceStartTime = CACurrentMediaTime()

            self.executeTasks()
        }
    }

    /// Cancels the currently running `TaskSequence` without a result. Note that when called, the `TaskSequence` will execute the `cancelClosure` provided by the user and not the `completion`. Any tasks that complete after this is called will not have their completion closures called.
    public func cancel() {
        self.mutex.sync {
            guard self.isRunning else { return }

            self.isRunning = false

            if let cancelClosure = self.cancelClosure {
                self.queue.async {
                    cancelClosure()
                }
            }

            self.taskCompletionReportClosure = nil
            self.cancelClosure = nil
            self.completion = nil
            self.taskSequenceID = UUID()
            self.scheduledTasksLeftToStart = []
            self.scheduledTasksCompleted = []
        }
    }

    private func executeTasks() {
        for scheduledTaskLeftToStart in self.scheduledTasksLeftToStart where self.checkDependencyCompletion(forScheduledTask: scheduledTaskLeftToStart) {
            let taskCompletionClosure = { (result: Result<Void, Error>?) in
                self.taskCompleted(scheduledTaskLeftToStart, withResult: result)
            }

            self.taskStartTimes[scheduledTaskLeftToStart.task.identifier] = CACurrentMediaTime()

            // get out of the mutex in case the closure directly ends the task and calls into `taskFinished()`
            self.queue.async {
                scheduledTaskLeftToStart.task.execute(taskCompletionClosure)
            }

            self.scheduledTasksLeftToStart.removeAll(where: { $0.task.identifier == scheduledTaskLeftToStart.task.identifier })
        }
    }

    private func checkDependencyCompletion(forScheduledTask scheduledTask: ScheduledTask) -> Bool {
        scheduledTask.dependencies.allSatisfy({ dependency in
            self.scheduledTasksCompleted.contains(where: { $0.task.identifier == dependency.identifier })
        })
    }

    private func taskCompleted(_ completedTask: ScheduledTask, withResult result: Result<Void, Error>?) {
        self.mutex.sync {

            // If `taskSequenceID` from the completed task does not match that of the current TaskSequence, then it must be from a
            // execution of the TaskSequence that has already completed. This might happen with a long running task that is fired
            // just before a required task forced the TaskSequence to return a "failure."
            guard self.taskSequenceID == completedTask.taskSequenceID else {
                return
            }

            self.scheduledTasksCompleted.append(completedTask)

            let progress = Float(self.scheduledTasksCompleted.count) / Float(self.scheduledTasks.count)

            guard let taskStartTime: CFTimeInterval = self.taskStartTimes[completedTask.task.identifier] else {
                return
            }

            let taskDuration: CFTimeInterval = CACurrentMediaTime() - taskStartTime

            if let reportClosure: TaskCompletionReportClosure = self.taskCompletionReportClosure {
                self.queue.async {
                    reportClosure(completedTask.task, taskDuration, progress)
                }
            }

            func taskSequenceEnded(withResult result: Result<Void, Error>) {
                let taskSequenceDuration: CFTimeInterval = CACurrentMediaTime() - self.taskSequenceStartTime
                self.scheduledTasksLeftToStart = []
                self.scheduledTasksCompleted = []
                self.isRunning = false
                self.taskCompletionReportClosure = nil
                self.cancelClosure = nil
                self.taskSequenceID = UUID()
                if let completion = self.completion {
                    self.queue.async {
                        completion(result, completedTask.task, taskSequenceDuration)
                    }
                }
                self.completion = nil
            }

            // Check for failure
            if let result = result, result.isFailure {
                taskSequenceEnded(withResult: result)
                return
            }

            if self.scheduledTasksCompleted.count == self.scheduledTasks.count {
                taskSequenceEnded(withResult: .success(()))
            } else {
                self.queue.async {
                    self.executeTasks()
                }
            }
        }
    }
}
