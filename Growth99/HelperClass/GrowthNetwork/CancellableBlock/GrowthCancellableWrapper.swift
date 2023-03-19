
import Foundation

internal class GrowthCancellableWrapper: GrowthCancellable {
    
    var isCancelled = false
    func cancel() {
        self.isCancelled = true
    }
}
