

import Foundation
open class BlockThrottler<Value> {

    fileprivate let queue = DispatchQueue(kind: .serial, label: "BlockThrottler queue")
    fileprivate let source: DispatchSource.Add

    /// Blocks which may be called whenever a value changes
    fileprivate var blocks: [(Value) -> Void] = []

    /// Private representation of the current Value. Note that this needs to be
    /// protected by a SemaphoreLock as the Dispatch.Source executes the handler on
    /// an arbitrary thread
    fileprivate var _value: Value

    /// The current value
    open var value: Value {
        get {
            self.queue.sync { self._value }
        }
        set {
            self.queue.sync { self._value = newValue }
            self.source.add(data: 1)
        }
    }

    /**
     * Initializes a new throttler with the given initialValue
     *
     * - parameter initialValue: Initial value for this BlockThrottler
     */
    public init(initialValue value: Value) {
        self._value = value
        self.source = DispatchSource.makeUserDataAddSource(queue: self.queue)
        self.source.setEventHandler { [unowned self] in self.executeBlocks() }
        self.source.resume()
    }

    open func addBlock(_ block: @escaping (Value) -> Void) {
        self.queue.sync {
            self.blocks.append(block)
        }
    }

    /**
     * Executes all blocks with the current value
     */
    fileprivate func executeBlocks() {
        self.blocks.forEach { $0(_value) }
    }

    deinit {
        self.source.cancel()
    }
}
