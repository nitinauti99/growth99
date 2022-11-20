//
//  Future.swift
//  Fargo
//
//  Created by Robin van Dijke on 4/19/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

public protocol FutureValueProviding {
    associatedtype FutureValue

    @discardableResult
    func withValue(inContext context: @escaping DispatchQueue.Context, _ block: @escaping (FutureValue) -> Void) -> Self
}

/**
 A `Future` declares a future value of type `Wrapped`
 
 Example:
 
 ```swift
 // this function has a complexity of O(2^n) and should never
 // be executed on the main thread
 func fibonacci(x: Int) -> Int
 
 // make a promise from the fibonnaci function
 let fibonacciFuture: Int -> Future<Int> = { number in future { fibonacci(number) } }
 
 // calculate a print the result
 fibonacciFuture(20).withValue { print($0) }
 
 // in case you still want to execute it `immediately` (note that the completion block is still called asynchronously)
 future(usingContext: Dispatch.Queue.immedateExecutionContext) { fibonacci(20) }.withValue { print($0) }
 
 // or
 let value = future { fibonacci(20) }.getValue()
 ```
 */
public final class Future<Wrapped>: FutureValueProviding {

    public typealias FutureValue = Wrapped

    /// contains the final value
    var value: Wrapped?

    /// lock to protect access from different threads
    let lock = SemaphoreLock()

    /// all the resultBlocks that need to be executed once the value is known
    var completions: [(Wrapped) -> Void] = []

    // MARK: Initialization

    /**
     Initializes an empty future which should be completed later on.
     
     - returns: Empty future
     */
    internal init() { }

    /**
     Initializes a `Future` which is immediately completed using
     the given result.
     
     - parameter result: Result to complete the future with
     - returns: Completed `Future` instance
     */
    public init(value: Wrapped) {
        self.value = value
    }

    /**
     Initializes a `Future` which is executed in the given context. The
     value is computed using the `work` function.
     
     - parameter context: Context to execute the `work` function in
     - parameter work: To compute the value for this promise
     - returns: Initialized `Future` instance
     */
    internal init(usingContext context: DispatchQueue.Context, work: @escaping () -> Wrapped) {
        context {
            self.resolve(withValue: work())
        }
    }

    /**
     Initializes a `Future` which is executed in the given context. The
     result is computed using the `resolver` function. The resolver
     function can be completed asynchronous. An possible implementation:
     
     ```swift
     let future = future { resolve in
     Dispatch.globalQueue.async {
     let result = // some expensive function
     resolve(result)
     }
     }
     ```
     
     - parameter context: Context to execute the `resolver` function in
     - parameter resolver: To compute the result for this promise
     - returns: Initialized `Future` instance
     */
    internal init(usingContext context: DispatchQueue.Context, resolver: @escaping (@escaping (Wrapped) -> Void) -> Void) {
        context {
            resolver { value in
                self.resolve(withValue: value)
            }
        }
    }

    /**
     Creates a new future which will be completed with the given
     `value` after `delay` seconds
     
     - parameter value: Value to complete future with
     - parameter delay: Time in seconds after which to complete the future
     - returns: Future which will be completed with `value` after `delay` seconds
     */
    internal init(value: Wrapped, delay: Foundation.TimeInterval) {
        DispatchQueue.global().after(seconds: delay) {
            self.resolve(withValue: value)
        }
    }

    // MARK: Completion

    /// returns whether the future has been completed
    public var isCompleted: Bool {
        self.lock.readValue { self.value != nil }
    }

    /**
     Registers a block which is called once the value of the `Future` is known. When
     the value has already been completed the block is called immediately.
     
     - parameter block: The block called with the value of this future
     - returns: Self, to support chaining
     */
    @discardableResult
    public func withValue(_ block: @escaping (Wrapped) -> Void) -> Self {
        self.withValue(inContext: DispatchQueue.defaultCallbackContext, block)
    }

    /**
     Registers a block which is called once the value of the `Future` is known. When
     the value has already been completed the block is called immediately.
     
     - parameter context: The context in which the block should be executed
     - parameter block: The block called with the value of this future
     - returns: Self, to support chaining
     */
    @discardableResult
    public func withValue(inContext context: @escaping DispatchQueue.Context, _ block: @escaping (Wrapped) -> Void) -> Self {
        let completion = wrap(inContext: context, execute: block)
        var value: Wrapped?
        self.lock.write {
            // save value to call block outside of lock
            value = self.value

            if self.value == nil {
                // save block to execute once value is known
                self.completions.append(completion)
            }
        }

        if let value = value {
            // value is already known, call block immediately
            completion(value)
        }

        return self
    }

    /**
     Completes/resolves this future with the given value. Every future is only
     allowed to be completed once.
     
     - parameter value: Final value for this future
     */
    internal func resolve(withValue value: Wrapped) {
        var completions: [(Wrapped) -> Void] = []

        self.lock.write {
            precondition(self.value == nil, "Cannot complete a Promise which is already completed")

            self.value = value

            // move resultBlocks outside of lock
            completions = self.completions

            // remove all completionBlocks
            self.completions.removeAll()
        }

        // call completionBlocks with result
        completions.forEach { $0(value) }
    }

    /**
     Completes this `future` whenever the given future is completed
     
     - parameter future: Future which will complete this future
     */
    internal func resolve(withFuture future: Future) {
        future.withValue(inContext: DispatchQueue.immediateExecutionContext) { value in
            self.resolve(withValue: value)
        }
    }

    /**
     Blocks the current thread until this 'Future' has been completed
     
     - parameter timeout: Timeout within the future should be completed. Defaults to `Dispatch.time.forever`
     - returns: When the `Future` is completed within the timeout the result is returned, otherwise nil
     */
    public func getValue(withTimeout timeout: DispatchTime = .forever) -> Wrapped? {
        var value: Wrapped?
        let semaphore = DispatchSemaphore(value: 0)

        self.withValue(inContext: DispatchQueue.global().contextAsync) {
            value = $0
            semaphore.signal()
        }

        // wait until the value is known or until the timeout has passed
        _ = semaphore.wait(timeout: timeout)
        return value
    }

    /**
     Registers a function which is called always when the `Future` is completed
     
     - parameter block: Function which is executed once the future is completed
     - returns: Self, to support chaining
     */
    @discardableResult
    public func always(_ block: @escaping () -> Void) -> Self {
        self.withValue(inContext: DispatchQueue.defaultCallbackContext) { _ in block() }

        return self
    }

    /**
     Generates a new Future which results in the transformed value.
     
     - parameter transform: Function which can transform the current `Wrapped` value to a new one
     - returns: Future of the transformed value
     */
    public func map<T>(_ transform: @escaping (Wrapped) -> T) -> Future<T> {
        let future = Future<T>()

        self.withValue(inContext: DispatchQueue.immediateExecutionContext) { value in
            future.resolve(withValue: transform(value))
        }

        return future
    }

    /**
     Generates a new Future by transforming the future value into a new
     Future<T>.
     
     - parameter transform: Function which transform the future value `Wrapped` into a new Future<T>
     - returns: Future<T>
     */
    public func flatMap<T>(_ transform: @escaping (Wrapped) -> Future<T>) -> Future<T> {
        let future = Future<T>()

        self.withValue(inContext: DispatchQueue.immediateExecutionContext) { value in
            future.resolve(withFuture: transform(value))
        }

        return future
    }

}

/**
 Creates a new `Future` with its future value given by the `work` function
 
 - parameter context: Context to use to execute work on
 - parameter resulting: Function to compute the value for this future
 - returns: Initialized `Future`
 */
public func future<Wrapped>(usingContext context: @escaping DispatchQueue.Context = DispatchQueue.defaultExecutionContext, work: @escaping () -> Wrapped) -> Future<Wrapped> {
    Future(usingContext: context, work: work)
}

/**
 Creates a new `Future` using the given `resolver`
 
 - parameter context: Context to use to execute resolver block in
 - parameter resolver: Function to compute the value for this future
 - returns: Initialized `Future`
 */
public func future<Wrapped>(usingContext context: @escaping DispatchQueue.Context = DispatchQueue.defaultExecutionContext,
                            resolver: @escaping (@escaping (Wrapped) -> Void) -> Void) -> Future<Wrapped> {
    Future(usingContext: context, resolver: resolver)
}

/**
 Creates a new `Future` using the given `value` which will be completed automatically
 after the given `delay`.
 
 - parameter value: Value to complete this future with
 - parameter delay: Delay (in seconds) after which to complete the future
 - returns: Initialized `Future`
 */
public func future<Wrapped>(withValue value: Wrapped, completeAfterDelay delay: Foundation.TimeInterval? = nil) -> Future<Wrapped> {
    if let delay = delay {
        return Future(value: value, delay: delay)
    }

    return Future(value: value)
}
