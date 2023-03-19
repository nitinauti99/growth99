
import Foundation

open class GrowthNetworkManager: NSObject {

    internal var session: URLSession?
    internal var rootQueue: DispatchQueue?
    internal var identifierToOperations = [Int: Operation]()
    internal var taskToOperation = [URLSessionTask: Operation]()
    internal var authenticator: Authenticator?
    internal let networkQueueManager = GrowthNetworkQueueManager()
    internal let taskToOperationRWLock = ReadersWriterLock(label: "com.apple.GrowthHTTPNetwork.taskToOperation")
    public var optIntoCertificatePinning = false
    public var logger: Logger
    public var logSettings: LogSettings
    public var window: UIWindow?
    
    public init(configuration: URLSessionConfiguration = .default,
                rootQueue: DispatchQueue? = nil,
                logger: Logger = OSLogger.shared,
                logSettings: LogSettings = .default,
                authenticator: Authenticator? = nil) {

        self.logger = logger
        self.logSettings = logSettings
        self.authenticator = authenticator
        self.networkQueueManager.networkRequestOperationQueue.underlyingQueue = rootQueue
        self.networkQueueManager.safeNetworkRequestOperationQueue.underlyingQueue = rootQueue
        super.init()

        self.rootQueue = rootQueue
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    override convenience init() {
        self.init(configuration: .default)
    }

    deinit {
        self.session?.invalidateAndCancel()
    }

    @discardableResult
    public func request(requestable: Requestable,
                        completionQueue: DispatchQueue = DispatchQueue.main,
                        progressBlock: ((Progress) -> Void)? = nil,
                        completion: @escaping (Result<GrowthResponse, GrowthNetworkError>) -> Void) -> GrowthCancellable {

        var cancellable: GrowthCancellable = GrowthCancellableWrapper()

        if let authenticator = self.authenticator, authenticator.authTokenState == .tokenExpired, !self.networkQueueManager.areRequestsSuspended {

            self.networkQueueManager.suspendNetworkQueue()
            authenticator.performTokenRefresh { [weak self] didRefreshToken, newTokenHeaders in
                guard let self = self else { return }
                guard didRefreshToken, let dataTaskOperations = self.networkQueueManager.networkRequestOperationQueue.operations as? [GrowthDataTaskOperation] else {
                    Log.error("Token refresh was not successful", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
                    completionQueue.async { completion(.failure(.tokenRefreshFailed)) }
                    return
                }

                dataTaskOperations.forEach({ $0.updateRequestHeaders(newTokenHeaders) })
                self.networkQueueManager.resumeNetworkQueue()

                guard !cancellable.isCancelled else {
                    completionQueue.async { completion(.failure(.requestCancelled)) }
                    return
                }

                let updatedRequestable = requestable.updateHeaderFields(newTokenHeaders)
                cancellable = self.internalRequest(request: updatedRequestable, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
            }
        } else {
            if let authenticator = self.authenticator, authenticator.authTokenState == .tokenValid {
                self.networkQueueManager.resumeNetworkQueue()
            }

            cancellable = self.internalRequest(request: requestable, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
        }

        return cancellable
    }

    @discardableResult
    public func request<T: Decodable>(requestable: Requestable,
                                      completionQueue: DispatchQueue = DispatchQueue.main,
                                      progressBlock: ((Progress) -> Void)? = nil,
                                      completion: @escaping (Result<T, GrowthNetworkError>) -> Void) -> GrowthCancellable {
        self.request(requestable: requestable, completionQueue: completionQueue, progressBlock: progressBlock) { result in
            switch result {
            case .success(let response):
                do {
                    let mappedResponse = try response.map(T.self)
                    completion(.success(mappedResponse))
                } catch let error {
                    if let GrowthNetworkError = error as? GrowthNetworkError {
                        completion(.failure(GrowthNetworkError))
                    } else {
                        completion(.failure(GrowthNetworkError.objectMapping(error, response)))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    @discardableResult
    public func request(forPath path: String,
                        method: HTTPMethod = .GET,
                        headers: [HTTPHeader] = HTTPHeader.defaultHeaders,
                        task: RequestTask = .requestPlain,
                        mode: RequestMode = .noAuth,
                        stub: Stub = Stub(),
                        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                        completionQueue: DispatchQueue = DispatchQueue.main,
                        progressBlock: ((Progress) -> Void)? = nil,
                        completion: @escaping (Result<GrowthResponse, GrowthNetworkError>) -> Void) -> GrowthCancellable {
        let requestable = RequestableType(path: path, method: method, task: task, headerFields: headers, mode: mode, stub: stub)

        return self.request(requestable: requestable, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
    }


    @discardableResult
    public func request<T: Decodable>(forPath path: String,
                                      method: HTTPMethod = .GET,
                                      headers: [HTTPHeader] = HTTPHeader.defaultHeaders,
                                      task: RequestTask = .requestPlain,
                                      mode: RequestMode = .noAuth,
                                      stub: Stub = Stub(),
                                      cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                                      completionQueue: DispatchQueue = DispatchQueue.main,
                                      progressBlock: ((Progress) -> Void)? = nil,
                                      completion: @escaping (Result<T, GrowthNetworkError>) -> Void) -> GrowthCancellable {
        let requestable = RequestableType(path: path, method: method, task: task, headerFields: headers, mode: mode, stub: stub)

        return self.request(requestable: requestable, progressBlock: progressBlock, completion: completion)
    }

    public func cancelAllRequests() {
        self.networkQueueManager.cancelAllRequests()
    }
}
