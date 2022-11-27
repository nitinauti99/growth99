
import Foundation

public extension Dispatch {
    /// A block which can be executed by a `Dispatch.Queue`
    typealias Block = () -> Void
    /// A block which can be executed by a `Dispatch.Queue` and returns T
    typealias GenericBlock<T> = () -> T
}

public extension DispatchQueue {
    /**
     * On a serial queue this call behaves exactly as `sync.
     * On a concurrent queue this call waits synchronously until
     * no other blocks are executing before executing `block`
     *
     * - parameter block: Block to execute
     */
    func barrierSync<T>(execute block: Dispatch.GenericBlock<T>) -> T {
        self.sync(flags: .barrier, execute: block)
    }

    /**
     * On a serial queue this call behaves exactly as `sync.
     * On a concurrent queue this call waits asynchronously until
     * no other blocks are executing before executing `block`
     *
     * - parameter block: Block to execute
     */
    func barrierAsync(execute block: @escaping Dispatch.Block) {
        self.async(flags: .barrier, execute: block)
    }

    /**
     * Executes the block after a number of seconds
     *
     * - parameters
     *   - seconds: Seconds to wait until executing `block`
     *   - block: Block to execute
     */
    func after(seconds: Foundation.TimeInterval, execute block: @escaping Dispatch.Block) {
        let time = DispatchTime(seconds: seconds)
        self.asyncAfter(deadline: time, execute: block)
    }

    /**
     * Applies a function a specific number is times. Depending on the queue
     * this is called the applier block can be called concurrently.
     *
     * - parameters:
     *    - count: Number of times to call the applier
     *    - applier: Block which will be called with an index
     */
    static func apply(times count: Int, execute applier: (Int) -> Void) {
        DispatchQueue.concurrentPerform(iterations: count, execute: applier)
    }
}

public extension DispatchQueue {
    /// A `Context` describes how to execute a `Block`
    /// on a specific `Queue`
    typealias Context = (@escaping Dispatch.Block) -> Void
    /// A context which can execute a block immediately without
    /// going through a `Queue`
    static var immediateExecutionContext: Context { { block in block() } }

    /// default context where to execute a block in
    static var defaultExecutionContext: DispatchQueue.Context { { block in
        // when we're called from the main thread, we want to execute the block on a globalQueue
            if Thread.isMainThread {
                DispatchQueue.global().async(execute: block)
            } else {
                // we're not on the main thread, just continue on the same thread
                block()
            }
        }
    }

    /// default context where to execute callback functions in
    static var defaultCallbackContext: DispatchQueue.Context { { block in
            DispatchQueue.main.async(execute: block)
        }
    }

    /**
     * Returns a `Context` delayed by the given number of seconds
     *
     * - parameter seconds: Number of seconds to delay execution of a block
     * - returns `Context`
     */
    func contextAfter(seconds: Foundation.TimeInterval) -> Context { { block in
            self.after(seconds: seconds, execute: block)
        }
    }

    /// sync context
    var contextSync: Context { {
            self.sync(execute: $0)
        }
    }

    /// async context
    var contextAsync: Context { {
            self.async(execute: $0)
        }
    }
}

func wrap<From>(inContext context: @escaping DispatchQueue.Context, execute block: @escaping (From) -> Void) -> ((From) -> Void) { { from in
    context { block(from) }
    }
}

func wrap(inContext context: @escaping DispatchQueue.Context, execute block: @escaping () -> Void) -> (() -> Void) { {
    context { block() }
    }
}
