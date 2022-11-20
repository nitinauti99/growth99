//
//  Future+Possible.swift
//  Fargo
//
//  Created by Robin van Dijke on 7/6/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

internal extension Future where Wrapped: Possibly {

    /**
     Completes this future with a Possibly.completed value
     
     - parameter value: Value to complete this future with
     */
    func complete(withValue value: Wrapped.Wrapped) {
        self.resolve(withValue: Wrapped(completed: value))
    }

    /**
     Completes this future with a future that completes always
     
     - parameter future: Future whose value to use a `completed` value
     */
    func complete(withFuture future: Future<Wrapped.Wrapped>) {
        future.withValue { value in
            self.resolve(withValue: Wrapped(completed: value))
        }
    }

    /**
     Marks this future as `Possible.cancelled`
     */
    func cancel() {
        self.resolve(withValue: Wrapped())
    }

}

public extension Future where Wrapped: Possibly {

    /**
     Schedules a block which will be executed when the `Possible` result of this `Future` is `completed`.
     
     - parameter context: Context to execute the block on
     - parameter block: Block to execute which takes the resulting value as parameter
     - returns: Self, to support chaining
     */

    @discardableResult
    func onComplete(inContext context: @escaping DispatchQueue.Context = DispatchQueue.defaultCallbackContext, execute block: @escaping (Wrapped.Wrapped) -> Void) -> Self {
        self.withValue(inContext: context) { $0.onCompleted(execute: block) }
    }

    /**
     Schedules a block which will be executed when the `Possible` result of this `Future` is `cancelled`.
     
     - parameter context: Context to execute the block on
     - parameter block: Block to execute
     - returns: Self, to support chaining
     */
    @discardableResult
    func onCancelled(inContext context: @escaping DispatchQueue.Context = DispatchQueue.defaultCallbackContext, execute block: @escaping () -> Void) -> Self {
        self.withValue(inContext: context) { $0.onCancelled(execute: block) }
    }

    /**
     Analyzes the future value by calling the isCompleted block when the future has been completed successfully
     or by calling the isCancelled block when the future has been cancelled
     
     - parameter context: The context to schedule the blocks in
     - parameter completed: Block executed in context when the Possibly value is Completed
     - parameter cancelled: Block executed in context when the Possibly value is Cancelled
     - returns: Self, to support chaining
     */
    @discardableResult
    func analyze(inContext context: @escaping DispatchQueue.Context = DispatchQueue.defaultCallbackContext, isCompleted completed: @escaping (Wrapped.Wrapped) -> Void, isCancelled cancelled: @escaping () -> Void) -> Self {
        self.withValue(inContext: context) { value in
            value.analyze(
                onCompleted: completed,
                onCancelled: cancelled)
        }
    }

    /**
     When this Future is completed with a `Wrapped.Wrapped` value the `transform` function is called. The resulting Future will be
     used to complete the Future returned from this function.
     
     - parameter transform: Function which transforms a completed result into a new Future of Possible<T>
     - returns: Future which will be completed using the result of the Future from the transform function
     */
    func then<T>(_ transform: @escaping (Wrapped.Wrapped) -> Future<Possible<T>>) -> Future<Possible<T>> {
        let future = Future<Possible<T>>()

        self.withValue(inContext: DispatchQueue.immediateExecutionContext) { value in
            value.analyze(
                onCompleted: { future.resolve(withFuture: transform($0)) },
                onCancelled: future.cancel
            )
        }

        return future
    }

    /**
     Schedules another future when this future has been completed. When this future has been
     cancelled the resulting future will be cancelled as well immediately.
     
     - parameter transform: Function which transformes a completed value into a new Future<T>
     - returns: Future around Possible<T>
     */
    func then<T>(_ transform: @escaping (Wrapped.Wrapped) -> Future<T>) -> Future<Possible<T>> {
        let future = Future<Possible<T>>()
        self.withValue(inContext: DispatchQueue.immediateExecutionContext) { value in
            value.analyze(
                onCompleted: { future.complete(withFuture: transform($0)) },
                onCancelled: future.cancel
            )
        }

        return future
    }

    /**
     When this future is cancelled, the resulting future will be completed
     using the given value.
     
     - parameter value: Value to recover the returned future with
     - returns: Future which will always complete.
     */
    @discardableResult
    func recover(withValue value: Wrapped.Wrapped) -> Future<Wrapped> {
        let future = Future<Wrapped>()
        self.analyze(
            inContext: DispatchQueue.immediateExecutionContext,
            isCompleted: future.complete,
            isCancelled: { future.complete(withValue: value) }
        )

        return future
    }

    /**
     When this future is cancelled, the given recoverFuture will be used to
     complete the returned future. 
     
     - parameter recoverFuture: Future whose future value is used to complete the returned future
     - returns: Future which will also be completed
     */
    @discardableResult
    func recover(withFuture recoverFuture: Future<Wrapped>) -> Future<Wrapped> {
        let future = Future<Wrapped>()
        self.analyze(
            inContext: DispatchQueue.immediateExecutionContext,
            isCompleted: future.complete,
            isCancelled: { future.resolve(withFuture: recoverFuture) }
        )

        return future
    }

}

/**
 Convenience operator for applying the recover function on a future. 
 
 Example:
 
 ```
 let result: Future<Possible<String>> = generatePossibleFuture() ?? "Hello World"
 ```
 
 In case generatePossibleFuture() is cancelled the "Hello World" value is taken to
 complete the future
 */
public func ??<Wrapped>(lhs: Future<Possible<Wrapped>>, rhs: Wrapped) -> Future<Possible<Wrapped>> {
    lhs.recover(withValue: rhs)
}

/**
 * Convenience operator for applying the recover function on a future.
 *
 * Example:
 *
 * ```
 * let result: Future<Possible<String>> = generatePossibleFuture() ?? generateAnotherPossibleFuture() ?? "Hello World"
 * ```
 *
 * In case generatePossibleFuture() is cancelled the generateAnotherPossibleFuture() future is considered. 
 * In case that one is also cancelled the "Hello World" value is taken to complete the returned future.
 */
public func ??<Wrapped>(lhs: Future<Possible<Wrapped>>, rhs: Future<Possible<Wrapped>>) -> Future<Possible<Wrapped>> {
    lhs.recover(withFuture: rhs)
}
