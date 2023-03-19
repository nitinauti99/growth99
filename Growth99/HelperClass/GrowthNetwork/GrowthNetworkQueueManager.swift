
import Foundation

internal class GrowthNetworkQueueManager {

    var underlyingQueue: DispatchQueue?
    let networkRequestOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "GrowthHTTPNetworkRequestQueue"
        operationQueue.maxConcurrentOperationCount = 5
        return operationQueue
    }()

    let safeNetworkRequestOperationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "GrowthHTTPNetworkSafeRequestQueue"
        operationQueue.maxConcurrentOperationCount = 5
        return operationQueue
    }()

    private let requestsSuspendedRWLock = ReadersWriterLock(label: "com.apple.GrowthHTTPNetwork.requestsSuspended")
    private var _areRequestsSuspended = false

    internal var areRequestsSuspended: Bool {
        self.requestsSuspendedRWLock.readValue {
            self._areRequestsSuspended
        }
    }

    internal func addRequestOperation(requestOperation: GrowthDataTaskOperation, requestMode: RequestMode) {
        switch requestMode {
        case .authRequest:
            self.safeNetworkRequestOperationQueue.addOperation(requestOperation)
        case .requiresAuth:
            self.networkRequestOperationQueue.addOperation(requestOperation)
        case .noAuth:
            self.safeNetworkRequestOperationQueue.addOperation(requestOperation)
        }
    }

    internal func suspendNetworkQueue() {
        self.requestsSuspendedRWLock.write { [weak self] in
            guard let self = self else { return }
            guard !self._areRequestsSuspended else { return }

            self._areRequestsSuspended = true
            self.networkRequestOperationQueue.isSuspended = true
        }
    }

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
