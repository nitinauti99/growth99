
import Foundation

internal class CancellableWrapper: Cancellable {

    var isCancelled = false

    func cancel() {
        self.isCancelled = true
    }
}
