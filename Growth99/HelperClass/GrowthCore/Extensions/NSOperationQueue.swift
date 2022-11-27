
import Foundation

public extension OperationQueue {
    /// Retrieves a context which can be used to schedule work on
    var context: DispatchQueue.Context {
        self.addOperation(_:)
    }
}
