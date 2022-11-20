//
//  Sequence
//  Sequence
//
//  Created by Lloyd Newman on 4/21/16.
//  Copyright © 2016 Lloyd Newman. All rights reserved.
//

import Foundation

public typealias SequenceStepClosure = (SequenceManager, @escaping SequenceStepCompletionClosure) -> Void
public typealias SequenceOptionalStepClosure = (SequenceManager, @escaping SequenceOptionalStepCompletionClosure) -> Void

public typealias SequenceStepCompletionClosure = (Result<Void, Error>) -> Void
public typealias SequenceOptionalStepCompletionClosure = () -> Void

// This goes from 0 to 1, inclusive
public typealias SequenceProgressClosure = (Float) -> Void
public typealias SequenceCancelClosure = () -> Void
public typealias SequenceCompletionClosure = (Result<Void, Error>) -> Void

private protocol ExecutableItem {
    var steps: [(closure: SequenceStepClosure, optional: Bool)] { get }
}

private struct StepInfo: ExecutableItem {
    let closure: SequenceStepClosure
    let optional: Bool

    var steps: [(closure: SequenceStepClosure, optional: Bool)] {
        [(closure: closure, optional: optional)]
    }
}

private struct GroupInfo: ExecutableItem {
    let steps: [(closure: SequenceStepClosure, optional: Bool)]
}

@available(swift, deprecated: 0.8.1, message: "Start using TaskSequencer instead")
public final class SequenceManager {
    fileprivate var items: [ExecutableItem] = []
    fileprivate var itemsLeftToExecute: [ExecutableItem] = []
    fileprivate var totalSteps: Int = 0

    fileprivate var pendingStepsRemaining: Int = 0

    fileprivate var pendingGroupSteps: [(closure: SequenceStepClosure, optional: Bool)] = []
    fileprivate var creatingGroup: Bool = false

    fileprivate var progressClosure: SequenceProgressClosure?
    fileprivate var cancelClosure: SequenceCancelClosure?
    fileprivate var completion: SequenceCompletionClosure?

    /// - Tag: SequenceManagerIsRunningTag
    public fileprivate(set) var isRunning: Bool = false {
        didSet {
            self.didChangeRunningState?(isRunning)
        }
    }

    /// A closure which gets called when the value of [isRunning](x-source-tag://SequenceManagerIsRunningTag) gets updated. This can be used by consumers of [SequenceManagerTag](x-source-tag://SequenceManagerTag) to observe the `isRunning` attribute.
    public var didChangeRunningState: ((Bool) -> Void )?

    fileprivate var runID = 0

    fileprivate let mutex: ScopedMutex

    public init() {
        self.mutex = UnfairLock()
    }

    public func addStep(_ step: @escaping SequenceStepClosure) {
        self.addStep(step, optional: false)
    }

    public func addOptionalStep(_ step: @escaping SequenceOptionalStepClosure) {
        let closure: SequenceStepClosure = { sequence, completion in
            step(sequence) {
                completion(.success(()))
            }
        }

        self.addStep(closure, optional: true)
    }

    fileprivate func addStep(_ step: @escaping SequenceStepClosure, optional: Bool) {
        assert(!self.isRunning, "Attempted to add steps to a sequence that was already in progress.")

        let stepInfo = StepInfo(closure: step, optional: optional)

        if self.creatingGroup {
            self.pendingGroupSteps.append((step, optional))
        } else {
            self.items.append(stepInfo)
        }
    }

    public func addGroup(fromClosure closure: () -> Void) {
        self.creatingGroup = true
        closure()
        let groupInfo = GroupInfo(steps: self.pendingGroupSteps)
        self.items.append(groupInfo)
        self.creatingGroup = false
        self.pendingGroupSteps = []
    }

    public func execute(withProgressClosure progressClosure: SequenceProgressClosure? = nil, withCancelClosure cancelClosure: SequenceCancelClosure? = nil, completion: SequenceCompletionClosure? = nil) {
        guard !self.isRunning else {
            assert(false, "Attempted to execute a sequence that was already in progress.")
            print("Execute called while sequence is already in progress. Ignoring.")
            return
        }

        guard !self.items.isEmpty else {
            assert(false, "Are you aware you're attempting to execute an empty sequence?")
            print("Execute called on an empty sequence. Ignoring.")
            return
        }

        self.totalSteps = self.items.reduce(0, { $0 + $1.steps.count })

        self.progressClosure = progressClosure
        self.cancelClosure = cancelClosure
        self.completion = completion
        self.itemsLeftToExecute = self.items.reversed()
        self.isRunning = true

        self.executeNextItem()
    }

    // clearSequence allows the user to clear strong reference cycles that might occur if the class using Sequence references itself within a step closure.
    public func clearSequence() {
        guard !self.isRunning else {
            assert(false, "Attempted to clear a sequence that was still in progress.")
            print("clearSequence called while sequence was still in progress. Ignoring.")
            return
        }

        self.items = []

    }

    public func cancel() {
        self.mutex.sync {
            guard self.isRunning else { return }

            self.isRunning = false
            self.progressClosure = nil
            if let cancelClosure = self.cancelClosure {
                DispatchQueue.main.async {
                    cancelClosure()
                }
            }
            self.cancelClosure = nil
            self.completion = nil
            self.progressClosure = nil
            self.runID += 1
        }
    }

    fileprivate func executeNextItem() {
        self.mutex.sync {
            assert(!self.items.isEmpty, "Attempting to execute next item on an empty sequence")

            let item = self.itemsLeftToExecute.popLast()!

            self.pendingStepsRemaining = item.steps.count

            for step in item.steps {
                let closure = step.closure
                let optional = step.optional

                let stepCompletionClosure = { (result: Result<Void, Error>) in
                    self.stepFinished(result, optional: optional, runID: self.runID)
                }

                // get out of the mutex in case the closure directly ends the step and calls into `stepFinished()`
                DispatchQueue.main.async {
                    closure(self, stepCompletionClosure)
                }
            }
        }
    }

    fileprivate func stepFinished(_ result: Result<Void, Error>, optional: Bool, runID: Int) {
        self.mutex.sync {
            guard runID == self.runID else {
                print("We're getting a call from a previous run. Ignoring...")
                return
            }

            self.pendingStepsRemaining -= 1

            // Fire progress closure
            let leftToExecute = self.itemsLeftToExecute.reduce(0, { $0 + $1.steps.count })
            let progress = Float(self.totalSteps - (leftToExecute + self.pendingStepsRemaining)) / Float(self.totalSteps)

            if self.progressClosure != nil {
                DispatchQueue.main.async {
                    self.progressClosure?(progress)
                }
            }

            func sequenceEndedWith(_ result: Result<Void, Error>) {
                self.isRunning = false
                self.progressClosure = nil
                self.cancelClosure = nil
                if let completion = self.completion {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                self.completion = nil
                self.runID += 1
            }

            // Check for failure
            if optional == false && result.isFailure {
                sequenceEndedWith(result)
                return
            }

            if self.pendingStepsRemaining == 0 {
                if self.itemsLeftToExecute.isEmpty {
                    sequenceEndedWith(.success(()))
                } else {
                    // get out of the mutex
                    DispatchQueue.main.async {
                        self.executeNextItem()
                    }
                }
            }
        }
    }
}
