
import Dispatch

private let defaultContext: DispatchQueue.Context = { DispatchQueue.main.async(execute: $0) }

public extension DispatchGroup {
    /**
     * Schedule a block on work on the group. After the block is done
     * and no other blocks are running on the group the notify-blocks
     * will be called.
     *
     * - parameters:
     *    - queue: Queue to execute block on
     *    - block: Block to execute
     */
    func async(on queue: DispatchQueue, execute block: @escaping Dispatch.Block) {
        queue.async(group: self, execute: block)
    }

    /**
     * Schedule a new block which is executes once the group
     * is empty and all scheduled work has been performed
     *
     * - parameters:
     *     - context: Context to run block in
     *     - block: Block to execute
     */
    func notify(block: @escaping Dispatch.Block) {
        self.notify(usingContext: defaultContext, block: block)
    }

    func notify(usingContext context: @escaping DispatchQueue.Context, block: @escaping Dispatch.Block) {
        self.notify(queue: DispatchQueue.global(), execute: wrap(inContext: context, execute: block))
    }
}
