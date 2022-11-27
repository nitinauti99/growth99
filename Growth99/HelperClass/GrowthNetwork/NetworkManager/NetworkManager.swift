
import Foundation

/// Type responsible for managing network requests for the specified URLSession
open class NetworkManager: NSObject {

    /// URLSession associated with the manager.
    internal var session: URLSession?

    /// Queue on which all the network requests would be running. Defaults to nil.
    internal var rootQueue: DispatchQueue?

    /// Internal type to have a mapping between operations.
    internal var identifierToOperations = [Int: Operation]()

    /// Internal type to have a mapping between operations and the corresponding sessionTask.
    internal var taskToOperation = [URLSessionTask: Operation]()

    /// Mechanism responsible for handling reauth flow in an event of token expiry. User to add, defaults to nil.
    internal var authenticator: Authenticator?

    /// QueueManager responsible for handling network operationQueue.
    internal let networkQueueManager = NetworkQueueManager()

    /// Queue responsible for read-write operation for taskToOperation property.
    internal let taskToOperationRWLock = ReadersWriterLock(label: "com.apple.GrowthHTTPNetwork.taskToOperation")

    /// Certificate `Bundle` directory provided to grab all the certificates.
    public private(set) var pinningPolicy: PinningPolicy?

    /// A Boolean to set whether certificate pinning is required by the client.
    public var optIntoCertificatePinning = false

    public var logger: Logger

    /// Network log settings to provide varied degree of logging options.
    public var logSettings: LogSettings

    /**
     Initializer to create NetworkManager object for specified configuration, queue and bundle
        
     - parameters:
         - configuration: urlSessionConfiguration object, defaults to .default.
         - rootQueue: queue on which requests would be called, defualts to nil.
         - authenticator: protocol to handle refresh token functionality.
         - certificateBundle: bundle which would be used by library to look for certs for pinning, defaults to nil which means cert pinning would be off by default.
    */
    public init(configuration: URLSessionConfiguration = .default,
                rootQueue: DispatchQueue? = nil,
                logger: Logger = OSLogger.shared,
                logSettings: LogSettings = .default,
                authenticator: Authenticator? = nil,
                pinningPolicy: PinningPolicy? = nil) {

        self.logger = logger
        self.logSettings = logSettings
        self.authenticator = authenticator
        self.pinningPolicy = pinningPolicy
        self.networkQueueManager.networkRequestOperationQueue.underlyingQueue = rootQueue
        self.networkQueueManager.safeNetworkRequestOperationQueue.underlyingQueue = rootQueue
        super.init()

        self.rootQueue = rootQueue
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    /**
     Convenience init to initialize NetworkManager with default configuration
    
    */
    override convenience init() {
        self.init(configuration: .default)
    }

    /**
     Denitializer for NetworkManager to invalidate/flush objects which could lead to a leak
     */
    deinit {
        self.session?.invalidateAndCancel()
    }

    /**
     Make a fetch request for a requestable type which responds back with a ```Result``` type containing ```Response``` and ```Error```
    
     - parameters:
         - requestable: any [Requestable](x-source-tag://RequestableTag) type to contain path, method, task, baseUrl.
         - completionQueue: queue on which the completionBlock will be called.
         - progressBlock: block to send the progress back for every request.
         - completion: completion block which would contain a Result type.
    */
    @discardableResult
    public func request(requestable: Requestable,
                        completionQueue: DispatchQueue = DispatchQueue.main,
                        progressBlock: ((Progress) -> Void)? = nil,
                        completion: @escaping (Result<Response, GrowthNetworkError>) -> Void) -> Cancellable {

        var cancellable: Cancellable = CancellableWrapper()

        if let authenticator = self.authenticator, authenticator.authTokenState == .tokenExpired, !self.networkQueueManager.areRequestsSuspended {

            self.networkQueueManager.suspendNetworkQueue()
            authenticator.performTokenRefresh { [weak self] didRefreshToken, newTokenHeaders in
                guard let self = self else { return }
                guard didRefreshToken, let dataTaskOperations = self.networkQueueManager.networkRequestOperationQueue.operations as? [DataTaskOperation] else {
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

    /**
     Make a fetch request for a requestable type which responds back with a ```Result``` type containing a decodable type ```<T>``` and ```Error```
     
     - parameters:
         - requestable: any [Requestable](x-source-tag://RequestableTag) type to contain path, method, task, baseUrl.
         - completionQueue: queue on which the completionBlock will be called.
         - progressBlock: block to send the progress back for every request.
         - completion: completion block sending back a Result type containing the decodable type requested.
    */
    @discardableResult
    public func request<T: Decodable>(requestable: Requestable,
                                      completionQueue: DispatchQueue = DispatchQueue.main,
                                      progressBlock: ((Progress) -> Void)? = nil,
                                      completion: @escaping (Result<T, GrowthNetworkError>) -> Void) -> Cancellable {
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

    /**
     Make a fetch request by directly providing all the separate param which responds back with a ```Result``` type containing a decodable type ```Response``` and ```Error```
    
     - parameters:
         - path: complete path of the request containing baseURL.
         - method: [HTTPMethod](x-source-tag://HTTPMethodTag) type, defaults to GET.
         - headers: [HTTPHeader](x-source-tag://HTTPHeaderTag) which would be part of the request.
         - task: identify the [Task](x-source-tag://TaskTag) to be performed, defaults to requestPlain.
         - mode: [Mode](x-source-tag://RequestModeTag) choose between auth, noAuth requestMode, defaults to noAuth.
         - completionQueue: queue on which the completionBlock will be called.
         - progressBlock: block to send the progress back for every request.
         - completion: completion block which would contain a Result type.
    */
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
                        completion: @escaping (Result<Response, GrowthNetworkError>) -> Void) -> Cancellable {
        let requestable = RequestableType(path: path, method: method, task: task, headerFields: headers, mode: mode, stub: stub)

        return self.request(requestable: requestable, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
    }

    /**
     Make a fetch request by directly providing all the separate param which responds back with a ```Result``` type containing a decodable type ```<T>``` and ```Error```
        
     - parameters:
         - path: complete path of the request containing baseURL.
         - method: [HTTPMethod](x-source-tag://HTTPMethodTag) type, defaults to GET.
         - headers: [HTTPHeader](x-source-tag://HTTPHeaderTag) which would be part of the request.
         - task: identify the [Task](x-source-tag://TaskTag) to be performed, defaults to requestPlain.
         - mode: [Mode](x-source-tag://RequestModeTag) choose between auth, noAuth requestMode, defaults to noAuth.
         - completionQueue: queue on which the completionBlock will be called.
         - progressBlock: block to send the progress back for every request.
         - completion: completion block sending back a Result type containing the decodable type requested.
    */
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
                                      completion: @escaping (Result<T, GrowthNetworkError>) -> Void) -> Cancellable {
        let requestable = RequestableType(path: path, method: method, task: task, headerFields: headers, mode: mode, stub: stub)

        return self.request(requestable: requestable, progressBlock: progressBlock, completion: completion)
    }

    /**
     Cancels all queued and executing requests.
     
     All the different [modes](x-source-tag://RequestModeTag) of Request would be cancelled.
    */
    public func cancelAllRequests() {
        self.networkQueueManager.cancelAllRequests()
    }
}
