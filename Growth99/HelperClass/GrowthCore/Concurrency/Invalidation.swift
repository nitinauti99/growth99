import Foundation

public protocol Invalidatable {

    /// Returns whether this instance is still valid
    var isValid: Bool { get }

    /**
     * Marks this `Invalidatable` instance as invalid. This operation is not
     * reversible. It causes execution of all blocks which are
     * registered using `onInvalidation(block:)`
     */
    func invalidate()

    /**
     * Executes the given block whenever this invalidationToken gets invalidated.
     * When the token is already invalid the block will be executed immediately.
     *
     * - parameter block: Block which will be executed upon invalidation
     */
    func onInvalidation(execute block: @escaping () -> Void)
}

extension Invalidatable {
    /// Returns whether this instance is invalid
    var isInvalid: Bool {
        self.isValid == false
    }
}

/**
 * Describes an interface for an object which is able to invalidate work. `Invalidating` instances
 * provide functionality to `wrap` work which allows it to be controlled by this `Invalidating` instance.
 *
 * Example:
 *
 * ```swift
 * func work(number: Int) -> Int {
 *    var result = number
 *    (0 ..< 10000).forEach { i in
 *        result += i
 *    }
 *    return result
 * }
 *
 * let invalidationToken = InvalidationToken()
 * let invalidatableWork = invalidationToken.makeManaged(work(20))
 * // invalidatableWork is now of type Void -> Possible<Int>
 * // and the invalidationToken can be used to cancel work
 *
 * func longerWork(invalidating: Invalidatable) -> Possible<Int> {
 *    var result = number
 *    
 *    if invalidating.isInvalid { return .cancelled }
 *    // do something expensive here
 *
 *    if invalidating.isInvalid { return .cancelled }
 *    // another expensive thing
 *
 *    return invalidating.isValid ? .completed(result) : .cancelled
 * }
 *
 * let invalidatableLongerWork = invalidationToken.makeManaged(longerWork)
 * // invalidatableLongerWork is now of type Void -> Possible<Int>
 * // and the invalidationToken can be used to cancel work
 * ```
 */
public protocol Invalidating: Invalidatable {
    /**
     * `Wraps` the given block inside this `Invalidating` instance so it can be invalidated. Note that the
     * given block should check the state of the `Invalidatable` instance periodically and return .cancelled
     * when it's invalid.
     *
     * - parameter block: Block which takes an invalidatable instance and returns a `Possible<Value>`
     * - returns: block which can be invalidated by this `Invalidating` instance
     */
    func makeManaged<Value>(_ block: @escaping (Invalidatable) -> Possible<Value>) -> (() -> Possible<Value>)

    /**
     * `Wraps` the given block inside this `Invalidating` instance so it can be invalidated. Note that
     * the block is not getting an instance of `Invalidatable`. This means that before the block is executed
     * the state of this `Invalidating` instance should be checked. If it's invalid cancelled should be returned.
     * The same should be done after the block has been executed.
     *
     * - parameter block: Block which can be executed and returns `Value`
     * - returns: block which can be invalidated by this `Invalidating` instance
     */
    func makeManaged<Value>(_ block: @escaping () -> Value) -> (() -> Possible<Value>)
}

/**
 * Implements `Invalidating` so an `InvalidationToken` can be used
 * to invalidate instances which conform to `Invalidatable`. Class is
 * thread-safe, it can be used from multiple threads.
 *
 * - seealso: `Invalidating`
 */
open class InvalidationToken: Invalidating {

    fileprivate let lock = SemaphoreLock()
    fileprivate var valid: Bool = true
    fileprivate var onInvalidationBlocks: [() -> Void] = []

    /**
     * Initializes a new InvalidationToken
     *
     * - returns: Fresh InvalidationToken instance
     */
    public init() {}

    // MARK: - Invalidatable
    open var isValid: Bool {
        self.lock.readValue { self.valid }
    }

    open func invalidate() {
        var onInvalidationBlocks: [() -> Void] = []

        self.lock.write {
            self.valid = false

            onInvalidationBlocks = self.onInvalidationBlocks
            self.onInvalidationBlocks.removeAll()
        }

        onInvalidationBlocks.forEach { $0() }
    }

    open func onInvalidation(execute block: @escaping () -> Void) {
        var shouldExecuteBlock: Bool = false

        self.lock.write {
            if self.valid {
                self.onInvalidationBlocks.append(block)
            } else {
                shouldExecuteBlock = true
            }
        }

        if shouldExecuteBlock {
            block()
        }
    }

    // MARK: - Invalidating
    open func makeManaged<Value>(_ block: @escaping (Invalidatable) -> Possible<Value>) -> (() -> Possible<Value>) { {
        self.isValid ? block(self) : .cancelled
        }
    }

    open func makeManaged<Value>(_ block: @escaping () -> Value) -> (() -> Possible<Value>) { {
        guard self.isValid else { return .cancelled }

        // execute block of work
        let result = block()
        return self.isValid ? .completed(result) : .cancelled
        }
    }
}

/**
 * Creates a new Future which is invalidatable and results in a `Possible<Value>`
 *
 * - parameters:
 *   - context: Context to execute promise in
 *   - invalidating: `Invalidating` instance to invalidate work with
 *   - work: Block which can be invalidated and returns in a `Possible<Value>`
 * - returns: Future
 */
public func future<Value>(usingContext context: @escaping DispatchQueue.Context = DispatchQueue.defaultExecutionContext,
                          invalidating: Invalidating,
                          work: @escaping (Invalidatable) -> Possible<Value>) -> Future<Possible<Value>> {
    future(usingContext: context, work: invalidating.makeManaged(work))
}

/**
 * Creates a new Future which is invalidatable and results in a `Possible<Value>`. Note that the
 * work in here doesn't take an Invalidatable and is therefore not invalidatable itself.
 *
 * - parameters:
 *   - context: Context to execute promise in
 *   - invalidating: `Invalidating` instance to invalidate work with
 *   - work: Block which returns a `Value`
 * - returns: Future
 */
public func future<Value>(usingContext context: @escaping DispatchQueue.Context = DispatchQueue.defaultExecutionContext,
                          invalidating: Invalidating,
                          work: @escaping () -> Value) -> Future<Possible<Value>> {
    future(usingContext: context, work: invalidating.makeManaged(work))
}
