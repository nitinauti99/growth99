//
//  Possible.swift
//  Fargo
//
//  Created by Robin van Dijke on 5/6/16.
//  Copyright © 2016 Apple. All rights reserved.
//

/**
 * Describes an interface which can represent a completed state with a wrapped value
 * or a cancelled state.
 */
public protocol Possibly {
    /// The type this Possibly wrappes around
    associatedtype Wrapped

    /**
     * Initializes a new Possibly with completed state for value `completed`
     *
     * - parameter completed: Value to wrap around
     * - returns: Initialized Possibly with value `completed`
     */
    init(completed: Wrapped)

    /**
     * Initializes a new Possibly with the cancelled state.
     *
     * - returns: Initialized Possibly with value `cancelled`
     */
    init()

    /// Returns whether this `Possibly` state is `completed`
    var isCompleted: Bool { get }

    /// Returns whether this `Possibly` state is `cancelled`
    var isCancelled: Bool { get }

    /**
     * In case of a completed value, this function will apply the transform function
     * and return a `Possible.completed` value of the transformed result. In case of
     * a cancelled value, this function will return `Possible.cancelled`
     *
     * - parameter transform: Transforms the `Wrapped` value into a new type, is applied when this = .completed
     * - returns: Possible of the transformed type or .cancelled in case this = .cancelled
     * - throws: When the transform function throws the error is rethrown
     */
    func map<T>(transform: (Wrapped) throws -> T) rethrows -> Possible<T>

    /**
     * In case of a completed value, this function will apply the transform function
     * and return the result. In case of a cancelled value, this function will return `Possible.cancelled`
     *
     * - parameter transform: Transformes the `Wrapped` value into a new Possible<T>, is applied when this = .completed
     * - returns: Result of the transform function or .cancelled in case this = .cancelled
     * - throws: When the transform function throws the error is rethrown
     */
    func flatMap<T>(transform: (Wrapped) throws -> Possible<T>) rethrows -> Possible<T>

    /**
     * Analyzes this `Possible` by calling the `completed` block when this = .completed and calling
     * the `cancelled` block when this = .cancelled.
     *
     * - parameter completed: Block called with the `Wrapped` value when this = .completed
     * - parameter cancelled: Block called when this = .cancelled
     * - returns: Self for chaining
     * - throws: When the executed completed/cancelled block throws, the error is rethrown
     */
    @discardableResult
    func analyze(onCompleted completed: (Wrapped) throws -> Void, onCancelled cancelled: () throws -> Void) rethrows -> Self

    /**
     * Calls the `completed` block only when this = .completed
     *
     * - parameter completed: Block called when this = .completed
     * - returns: Self for chaining
     * - throws: When the block throws the error is rethrown
     */
    @discardableResult
    func onCompleted(execute block: (Wrapped) throws -> Void) rethrows -> Self

    /**
     * Calls the `cancelled` block only when this = .cancelled
     *
     * - parameter cancelled: Block called when this = .cancelled
     * - returns: Self for chaining
     * - throws: When the block throws the error is rethrown
     */
    @discardableResult
    func onCancelled(execute block: () throws -> Void) rethrows -> Self
}

public enum Possible<Wrapped>: Possibly {

    case completed(Wrapped)
    case cancelled

    public init(completed: Wrapped) {
        self = .completed(completed)
    }

    public init() {
        self = .cancelled
    }

    public var isCompleted: Bool {
        switch self {
        case .completed:
            return true
        default:
            return false
        }
    }

    public var isCancelled: Bool {
        switch self {
        case .cancelled:
            return true
        default:
            return false
        }
    }

    public func map<T>(transform: (Wrapped) throws -> T) rethrows -> Possible<T> {
        switch self {
        case .completed(let wrapped):
            return .completed(try transform(wrapped))
        case .cancelled:
            return .cancelled
        }
    }

    public func flatMap<T>(transform: (Wrapped) throws -> Possible<T>) rethrows -> Possible<T> {
        switch self {
        case .completed(let wrapped):
            return try transform(wrapped)
        case .cancelled:
            return .cancelled
        }
    }

    public func analyze(onCompleted completed: (Wrapped) throws -> Void, onCancelled cancelled: () throws -> Void) rethrows -> Possible {
        switch self {
        case .completed(let wrapped):
            try completed(wrapped)
        case .cancelled:
            try cancelled()
        }

        return self
    }

    public func onCompleted(execute block: (Wrapped) throws -> Void) rethrows -> Possible {
        guard case .completed(let wrapped) = self else { return self }

        try block(wrapped)

        return self
    }

    public func onCancelled(execute block: () throws -> Void) rethrows -> Possible {
        guard case .cancelled = self else { return self }

        try block()

        return self
    }

}
