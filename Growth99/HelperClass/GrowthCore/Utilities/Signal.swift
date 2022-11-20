//
//  Signal.swift
//  FargoCore
//
//  Created by SopanSharma on 8/29/18.
//

import Foundation

/// A `Signal` instance can be used to work as a replacement for delegates
/// and thus reduce a lot of boilerplate code that comes with it.
/// Just create a signal and add observers to it.
/// Based on reactive programming Signal.
///
/// For Example: -
///      let tapSignal = Signal<Int>()
///      tapSignal.fire(3)
///
///      // Subscriber to this event could be added as
///          tapSignal.subscribe(with: self, callback: { (someInteger) in
///               // Do your stuff here
///          })
public final class Signal<T> {
    private var subscribers = [Subscription<T>]()

    public var hasObservers: Bool {
        !self.observers.isEmpty
    }

    public var observers: [AnyObject] {
        self.subscribers.filter { $0.observer != nil }.map { $0.observer! }
    }

    /// Initializes an empty Signal which should be completed later on.
    /// - returns: Empty future
    public init() { }

    /// Subscribes an observer to the `Signal`.
    ///
    /// - parameter observer: The observer that subscribes to the `Signal`.
    /// - parameter callback: The closure to invoke whenever the `Signal` fires.
    /// - returns: A `Subscription` that can be used to cancel or filter the subscription.
    @discardableResult
    public func subscribe(with observer: AnyObject, callback: @escaping (T) -> Void) -> Subscription<T> {
        self.removeCancelledSubscribers()

        let subscriber = Subscription<T>(observer: observer, callback: callback)
        self.subscribers.append(subscriber)

        return subscriber
    }

    /// Subscribes an observer to the `Signal`. The subscription is automatically canceled after the `Signal` has
    /// fired once.
    ///
    /// - parameter observer: The observer that subscribes to the `Signal`. Should the observer be deallocated, the
    ///   subscription is automatically cancelled.
    /// - parameter callback: The closure to invoke when the signal fires for the first time.
    @discardableResult
    public func subscribeOnce(with observer: AnyObject, callback: @escaping (T) -> Void) -> Subscription<T> {
        let subscriber = self.subscribe(with: observer, callback: callback)
        subscriber.once = true

        return subscriber
    }

    /// Fires the `Signal`.
    ///
    /// - parameter data: The data to fire the `Signal` with.
    public func fire(_ data: T) {
        self.removeCancelledSubscribers()

        self.subscribers.forEach { subscriber in
            if subscriber.filter == nil || subscriber.filter!(data) == true {
                subscriber.dispatch(data: data)
            }
        }
    }

    /// Cancels all subscriptions for an observer.
    ///
    /// - parameter observer: The observer whose subscriptions to cancel
    public func cancelSubscription(for observer: AnyObject) {
        self.subscribers = subscribers.filter {
            if let subscriber: AnyObject = $0.observer {
                return subscriber !== observer
            }

            return false
        }
    }

    /// Cancels all subscriptions for the `Signal`.
    public func cancelAllSubscriptions() {
        self.subscribers.removeAll()
    }

    // MARK: - Private Helpers
    private func removeCancelledSubscribers() {
        self.subscribers = subscribers.filter {
            $0.observer != nil
        }
    }

}

infix operator => : AssignmentPrecedence

public func =><T> (signal: Signal<T>, data: T) {
    signal.fire(data)
}

public final class Subscription<T> {

    weak var observer: AnyObject?

    fileprivate var filter: ((T) -> Bool)?
    fileprivate var callback: (T) -> Void
    fileprivate var queue: DispatchQueue?
    fileprivate var once = false

    fileprivate init(observer: AnyObject, callback: @escaping (T) -> Void) {
        self.observer = observer
        self.callback = callback
    }

    /// Assigns a filter to the `Subscription`. This lets you define conditions under which a observer should actually
    /// receive the firing of a `Singal`. The closure that is passed an argument can decide whether the firing of a
    /// `Signal` should actually be dispatched to its observer depending on the data fired.
    ///
    /// - parameter predicate: A closure that can decide whether the `Signal` fire should be dispatched to its observer.
    /// - returns: Returns self so you can chain calls.
    @discardableResult
    public func filter(_ predicate: @escaping (T) -> Bool) -> Subscription {
        self.filter = predicate
        return self
    }

    /// Assigns a dispatch queue to the `Subscription`. The queue is used for scheduling the observer calls. If not
    /// nil, the callback is fired asynchronously on the specified queue. Otherwise, the block is run synchronously
    /// on the posting thread, which is its default behaviour.
    ///
    /// - parameter queue: A queue for performing the observer's calls.
    /// - returns: Returns self so you can chain calls.
    @discardableResult
    public func onQueue(_ queue: DispatchQueue) -> Subscription {
        self.queue = queue
        return self
    }

    @discardableResult
    fileprivate func dispatch(data: T) -> Bool {
        guard self.observer != nil else { return false }

        if self.once {
            self.cancel()
        }

        if let queue = self.queue {
            queue.async {
                self.callback(data)
            }
        } else {
            self.callback(data)
        }

        return observer != nil
    }

    /// Cancels the observer. This will cancelSubscription the listening object from the `Signal`.
    public func cancel() {
        self.observer = nil
    }

}
