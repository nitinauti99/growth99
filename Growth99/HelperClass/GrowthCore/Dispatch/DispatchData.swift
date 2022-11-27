
import Dispatch
import Foundation

public extension DispatchData {
    init() {
        self = .empty
    }

    /**
     * Returns a new instance of `Data` which represents the current data concatenated
     * with the given `Data`.
     *
     * - parameter data: The data to concatenate this instance with
     * - returns: New instance of `Data`
     */
    func concatenated(withData data: DispatchData) -> DispatchData {
        var data = self
        data.append(data)

        return data
    }

    mutating func concat(withData data: DispatchData) {
        self.append(data)
    }

    /**
     * Returns a new instance of data which consists of a portion
     * of the original data object.
     *
     * - parameter range: Defines the subrange for the new `Data` instance
     * - returns: Instance of `Data` containing portion of the original data
     */
    func extract(range: Range<Int>) -> DispatchData {
        let from = self.startIndex.advanced(by: range.lowerBound)
        let to = from.advanced(by: range.count)

        return self.subdata(in: from ..< to)
    }

    /**
     * Applies a function on a the raw data in a thread-safe way
     *
     * - parameter applier: Block which is called with a specific range and pointer to raw data
     */
    func apply(applier: (Range<Int>, UnsafeBufferPointer<UInt8>) -> Bool) {
        var offset = 0
        self.enumerateBytes { buffer, size, stop in
            stop = applier(offset ..< offset + size, buffer)

            offset += size
        }
    }

    /// Returns the size this `Data` instance
    var size: Int {
        self.count
    }
}
