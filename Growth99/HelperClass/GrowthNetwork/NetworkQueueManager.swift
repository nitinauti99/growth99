
import Foundation

/// Type to handle network tasks queuing
internal class NetworkQueueManager {

    /// Should be set only for networkRequestOperationQueue and before any operation is added
    /// otherwise it will result in an exception
    var underlyingQueue: DispatchQueue?
    let networkRequestOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "GrowthHTTPNetworkRequestQueue"
        operationQueue.maxConcurrentOperationCount = 5
        return operationQueue
    }()

    /// OperationQueue to handle tasks for network requests which doesn't require any
    /// sort of auth mechanism.
    let safeNetworkRequestOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "GrowthHTTPNetworkSafeRequestQueue"
        operationQueue.maxConcurrentOperationCount = 5
        return operationQueue
    }()

    private let requestsSuspendedRWLock = ReadersWriterLock(label: "com.apple.GrowthHTTPNetwork.requestsSuspended")
    private var _areRequestsSuspended = false

    /// Variable to set and get requests suspension
    internal var areRequestsSuspended: Bool {
        self.requestsSuspendedRWLock.readValue {
            self._areRequestsSuspended
        }
    }

    /**
     Function to add operation to the queue
     
     - parameters:
        - requestOperation: operation to be added
        - requestMode: [Mode](x-source-tag://RequestModeTag)choose between auth, noAuth requestMode, defaults to noAuth
     
     */
    internal func addRequestOperation(requestOperation: DataTaskOperation, requestMode: RequestMode) {
        switch requestMode {
        case .authRequest:
            self.safeNetworkRequestOperationQueue.addOperation(requestOperation)
        case .requiresAuth:
            self.networkRequestOperationQueue.addOperation(requestOperation)
        case .noAuth:
            self.safeNetworkRequestOperationQueue.addOperation(requestOperation)
        }
    }

    /**
     Function to suspend the requests
     
     - parameters:
        - comepletion: block to be returned once the suspend action is completed
     
     */
    // Can complete with true if this was the first call of suspendRequests in which case `true` would signify to refresh the token, false would not refresh
    internal func suspendNetworkQueue() {
        // Manually use the RW write instead of setting areRequestsSuspended because multiple requests may call this write, and we only want the completion block to run on the first write (until areRequestsSuspended is set back to false again)
        self.requestsSuspendedRWLock.write { [weak self] in
            guard let self = self else { return }
            guard !self._areRequestsSuspended else { return }

            self._areRequestsSuspended = true
            self.networkRequestOperationQueue.isSuspended = true
        }
    }

    /**
     Function to resume suspended requests.
     
     */
    internal func resumeNetworkQueue() {
        self.requestsSuspendedRWLock.write { [weak self] in
            guard let self = self else { return }
            guard self._areRequestsSuspended else { return }

            self._areRequestsSuspended = false
            self.networkRequestOperationQueue.isSuspended = false
        }
    }

    internal func cancelAllRequests() {
        self.networkRequestOperationQueue.cancelAllOperations()
        self.safeNetworkRequestOperationQueue.cancelAllOperations()
    }
}
