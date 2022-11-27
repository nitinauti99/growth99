
import Foundation

public extension Sequence where Iterator.Element: FutureValueProviding {

    /**
     Flattens this sequence of futures into a single future which completes in an array of the wrapped values
     
     - returns: Future which future value is an array of the flattened values
     */
    func flatten() -> Future<[Iterator.Element.FutureValue]> {
        // some helper variables
        let lock = SemaphoreLock()
        var results: [Iterator.Element.FutureValue] = []
        let group = DispatchGroup()

        // create resulting future
        let future = Future<[Iterator.Element.FutureValue]>()

        // loop through all promises
        self.forEach { future in
            // enter group to mark a promise entry
            group.enter()

            // wait for result for this promise
            future.withValue(inContext: DispatchQueue.immediateExecutionContext) { result in
                // append result within lock because results come back concurrently as specified by the defaultExecutionContext
                lock.write { results.append(result) }

                // leave the group to mark we're done with this promise
                group.leave()
            }
        }

        // install group notifier
        // do this within enter/leave blocks in case the sequenceType doesn't contain entries
        // otherwise the notify block is never triggered
        group.enter()

        // complete future once everything is done
        group.notify {
            future.resolve(withValue: results)
        }

        group.leave()

        return future
    }

    /**
     Reduces this sequence of futures into a future containing a single value
     
     - parameter initial: Initial value to use for the reduce
     - parameter combine: Function which combines the initial value and the individual values
     - returns: Future for the combined value
     */
    func reduce<T>(_ initial: T, combine: @escaping (T, Iterator.Element.FutureValue) -> T) -> Future<T> {
        let future = Future<T>()

        self.flatten().withValue(inContext: DispatchQueue.immediateExecutionContext) { values in
            let value = values.reduce(initial, combine)
            future.resolve(withValue: value)
        }

        return future
    }
}
