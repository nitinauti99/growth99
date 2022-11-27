
import Foundation

public protocol Lock {
    /**
     * Schedules a block on the lock which is allowed
     * to perform a read operation
     *
     * ```swift
     * let sharedResource: String = "Hello World"
     * let lock = Lock()
     *
     * // read `sharedResource` from within the lock and return the
     * // value in variable `string`
     * let string = lock.read { sharedResource }
     * ```
     *
     * - parameter block: Block which is allowed to do the read operation
     */
    func read<T>(_ block: Dispatch.GenericBlock<T>) -> T
}

public protocol SynchronousWriteLock: Lock {
    /**
     * Schedules a block on the lock which is allowed
     * to perform a synchronous write operation
     *
     * - parameter block: Block which is allowed to do the write operation
     */
    func write(_ block: Dispatch.Block)
}

public protocol AsynchronousWriteLock: Lock {
    /**
     * Schedules a block on the lock which is allowed
     * to perform a asynchronous write operation
     *
     * - parameter block: Block which is allowed to do the write operation
     */
    func write(_ block: @escaping Dispatch.Block)
}

public extension Lock {
    func readValue<T>(future: () -> T) -> T {
        self.read(future)
    }
}

/**
 * Implements the `Lock` protocol using a `DispatchSemaphore`
 *
 * Use this lock for fast single read/single write calls
 */
public struct SemaphoreLock: SynchronousWriteLock {
    let semaphore = DispatchSemaphore(value: 1)

    public func read<T>(_ block: Dispatch.GenericBlock<T>) -> T {
        self.semaphore.wait()
        let result = block()
        self.semaphore.signal()

        return result
    }

    public func write(_ block: Dispatch.Block) {
        self.semaphore.wait()
        block()
        self.semaphore.signal()
    }
}

/**
 * Implements the `Lock` protocol using a serial `DispatchQueue`
 *
 * Use this lock for fast single read/single write calls
 */
public struct SerialLock: SynchronousWriteLock {
    let queue: DispatchQueue

    /**
     * Initializes a new instance of `SerialLock`
     *
     * parameter label: Label to give to the `Queue` used for this lock
     * returns: Initialized `SerialLock` instance
     */
    public init(label: String) {
        self.queue = DispatchQueue(kind: .serial, label: label)
    }

    public func read<T>(_ block: Dispatch.GenericBlock<T>) -> T {
        self.queue.sync(execute: block)
    }

    public func write(_ block: Dispatch.Block) {
        self.queue.sync(execute: block)
    }

    public func writeSync(_ block: Dispatch.Block) {
        self.queue.sync(execute: block)
    }
}

/**
 * Implements the `Lock` protocol using a concurrent `DispatchQueue.
 *
 * Use this lock for concurrent read calls and single write calls. Note
 * that read calls may block if your scheduled write block is taking up
 * a large amount of time.
 */
public struct ReadersWriterLock: AsynchronousWriteLock {
    let queue: DispatchQueue

    /**
     * Initializes a new instance of `ReadersWriterLock`
     *
     * parameter label: Label to give to the `Queue` used for this lock
     * returns: Initialized `ReadersWriterLock` instance
     */
    public init(label: String) {
        self.queue = DispatchQueue(kind: .concurrent, label: label)
    }

    public func read<T>(_ block: Dispatch.GenericBlock<T>) -> T {
        self.queue.sync(execute: block)
    }

    public func write(_ block: @escaping Dispatch.Block) {
        self.queue.barrierAsync(execute: block)
    }
}
