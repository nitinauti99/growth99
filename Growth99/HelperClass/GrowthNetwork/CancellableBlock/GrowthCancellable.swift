
import Foundation

public protocol GrowthCancellable {
    var isCancelled: Bool { get }
    func cancel()
}
