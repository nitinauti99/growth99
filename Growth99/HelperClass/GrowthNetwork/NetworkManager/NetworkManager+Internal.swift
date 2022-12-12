
import Foundation

extension NetworkManager {

    @discardableResult
    func internalRequest(request: Requestable,
                         completionQueue: DispatchQueue = DispatchQueue.main,
                         progressBlock: ((Progress) -> Void)? = nil,
                         completion: @escaping (Result<Response, GrowthNetworkError>) -> Void) -> Cancellable {
        switch request.stub.behavior {
        case .never:
            switch request.task {
            case .requestPlain, .requestData, .requestParameters, .requestCompositeData, .requestCompositeParameters, .requestJSONEncodable, .requestCustomJSONEncodable:
                return self.dataRequest(request: request, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
            case .uploadFile(let url):
                return self.uploadRequest(request: request, url: url, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
            case .uploadData(let data):
                return self.uploadRequest(request: request, data: data, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
            case .multipartUpload(let multipartFormDataList):
                let multipartUpload = MultipartUpload(multipartFormDataList: multipartFormDataList)
                let bodyData = multipartUpload.body

                return self.uploadRequest(request: request, data: bodyData, multipartFormHeader: multipartUpload.multipartFormHeader, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
            case .multipartCompositeUpload(let multipartFormDataList, _):
                let multipartUpload = MultipartUpload(multipartFormDataList: multipartFormDataList)
                let bodyData = multipartUpload.body

                return self.uploadRequest(request: request, data: bodyData, multipartFormHeader: multipartUpload.multipartFormHeader, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
            case .download(let downloadLocationURL):
                return self.downloadRequest(request: request, downloadLocation: downloadLocationURL, completionQueue: completionQueue, progressBlock: progressBlock, completion: completion)
            }
        default:
            return self.stubRequest(stub: request.stub, completionQueue: completionQueue, completion: completion)
        }
    }

    @discardableResult
    func dataRequest(request: Requestable,
                     completionQueue: DispatchQueue = DispatchQueue.main,
                     progressBlock: ((Progress) -> Void)? = nil,
                     completion: @escaping (Result<Response, GrowthNetworkError>) -> Void) -> Cancellable {
        let endpoint = self.endpointMapping(for: request)
        let result = self.requestMapping(for: endpoint)

        switch result {
        case .success(let urlRequest):
            Log.info(
                urlRequest.requestDescription(for: self.logSettings, with: self.session?.configuration.httpAdditionalHeaders),
                logger: self.logger,
                shouldLog: self.logSettings.shouldAllowLogging
            )

            guard let session = self.session else {
                return CancellableWrapper()
            }

            let dataTaskOperation = DataTaskOperation(session, urlRequest, completionQueue)
            dataTaskOperation.delegate = self

            dataTaskOperation.completionBlock = { [weak self] in
                guard let self = self else {
                    completionQueue.async { completion(.failure(GrowthNetworkError.encodingFailed)) }
                    return
                }

                switch self.createResponse(for: dataTaskOperation.request, operation: dataTaskOperation) {
                case .success(let networkResponse):
                    Log.info(networkResponse.responseDescription(for: self.logSettings), logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
                    completionQueue.async {
                        if networkResponse.statusCode == 403 {
                            (UIApplication.shared.delegate as! AppDelegate).setUpHomeVC()
                        }
                        completion(.success(networkResponse))

                    }
                case .failure(let error):
                    completionQueue.async { completion(.failure(error)) }
                    return
                }
            }

            dataTaskOperation.progressBlock = { progress in
                progressBlock?(progress)
            }

            self.networkQueueManager.addRequestOperation(requestOperation: dataTaskOperation, requestMode: request.requestMode)

            return dataTaskOperation
        case .failure(let error):
            Log.error("Error mapping request for endpoint: \(endpoint)", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
            completionQueue.async { completion(.failure(error)) }
            return CancellableWrapper()
        }
    }

    @discardableResult
    func uploadRequest(request: Requestable,
                       url: URL? = nil,
                       data: Data? = nil,
                       multipartFormHeader: HTTPHeader? = nil,
                       completionQueue: DispatchQueue = DispatchQueue.main,
                       progressBlock: ((Progress) -> Void)? = nil,
                       completion: @escaping (Result<Response, GrowthNetworkError>) -> Void) -> Cancellable {
        let endpoint = self.endpointMapping(for: request, multipartFormHeader: multipartFormHeader)
        let result = self.requestMapping(for: endpoint)

        switch result {
        case .success(let urlRequest):
            Log.info(
                urlRequest.requestDescription(for: self.logSettings, with: self.session?.configuration.httpAdditionalHeaders),
                logger: self.logger,
                shouldLog: self.logSettings.shouldAllowLogging
            )

            guard let session = self.session else { return CancellableWrapper() }

            let uploadTaskOperation = UploadTaskOperation(session, urlRequest, completionQueue, data: data, url: url)
            uploadTaskOperation.delegate = self

            uploadTaskOperation.completionBlock = { [weak self] in
                guard let self = self else {
                    completionQueue.async { completion(.failure(GrowthNetworkError.encodingFailed)) }
                    return
                }

                switch self.createResponse(for: urlRequest, operation: uploadTaskOperation) {
                case .success(let networkResponse):
                    Log.info(networkResponse.responseDescription(for: self.logSettings), logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
                    completionQueue.async { completion(.success(networkResponse)) }
                case .failure(let error):
                    completionQueue.async { completion(.failure(error)) }
                    return
                }
            }

            uploadTaskOperation.progressBlock = { progress in
                progressBlock?(progress)
            }

            self.networkQueueManager.addRequestOperation(requestOperation: uploadTaskOperation, requestMode: request.requestMode)

            return uploadTaskOperation
        case .failure(let error):
            Log.error("Error mapping request for endpoint: \(endpoint)", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
            completion(.failure(error))
            return CancellableWrapper()
        }
    }

    @discardableResult
    func downloadRequest(request: Requestable,
                         downloadLocation: URL,
                         completionQueue: DispatchQueue = DispatchQueue.main,
                         progressBlock: ((Progress) -> Void)? = nil,
                         completion: @escaping (Result<Response, GrowthNetworkError>) -> Void) -> Cancellable {
        let endpoint = self.endpointMapping(for: request)
        let result = self.requestMapping(for: endpoint)

        switch result {
        case .success(let urlRequest):
            Log.info(
                urlRequest.requestDescription(for: self.logSettings, with: self.session?.configuration.httpAdditionalHeaders),
                logger: self.logger,
                shouldLog: self.logSettings.shouldAllowLogging
            )

            guard let session = self.session else { return CancellableWrapper() }

            let downloadTaskOperation = DownloadTaskOperation(session, urlRequest, completionQueue, downloadLocationURL: downloadLocation)
            downloadTaskOperation.delegate = self
            downloadTaskOperation.completionBlock = { [weak self] in
                guard let self = self else {
                    completionQueue.async { completion(.failure(GrowthNetworkError.encodingFailed)) }
                    return
                }

                switch self.createResponse(for: urlRequest, operation: downloadTaskOperation) {
                case .success(let networkResponse):
                    Log.info(networkResponse.responseDescription(for: self.logSettings), logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
                    completionQueue.async { completion(.success(networkResponse)) }
                case .failure(let error):
                    completionQueue.async { completion(.failure(error)) }
                    return
                }
            }

            downloadTaskOperation.progressBlock = { progress in
                progressBlock?(progress)
            }

            self.networkQueueManager.addRequestOperation(requestOperation: downloadTaskOperation, requestMode: request.requestMode)

            return downloadTaskOperation
        case .failure(let error):
            Log.error("Error mapping request for endpoint: \(endpoint)", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
            completion(.failure(error))
            return CancellableWrapper()
        }
    }

    private func createResponse(for request: URLRequest, operation: DataTaskOperation) -> Result<Response, GrowthNetworkError> {
        self.remove(operation: operation)

        if operation.isCancelled {
            Log.info("Request: \(operation.request.debugDescription) is cancelled", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
            return .failure(.requestCancelled)
        }

        guard let operationResponse = operation.operationResponse else {
            Log.error("Request: \(operation.request.debugDescription) cannot have nil response type", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
            return .failure(.responseFailed)
        }

        if let networkError = operationResponse.error {
            if let GrowthNetworkError = networkError as? GrowthNetworkError {
                Log.error("Response Error: \(GrowthNetworkError)", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
                return .failure(GrowthNetworkError)
            } else {
                Log.error("Response Error: \(networkError)", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
                return .failure(.unknown(networkError))
            }
        }

        guard let response = operationResponse.response as? HTTPURLResponse, let data = operationResponse.data else {
            Log.error("Response cannot be invalid", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
            return .failure(.invalidResponse)
        }

        return .success(Response(statusCode: response.statusCode, data: data, request: request, response: response, metrics: operation.metrics))
    }
}

extension NetworkManager: DataTaskOperationProtocol {

    func didStart(operation: DataTaskOperation, for task: URLSessionTask) {
        self.update(operation: operation, task: task)
    }

}

extension NetworkManager {

    func endpointMapping(for request: Requestable, multipartFormHeader: HTTPHeader? = nil) -> Endpoint {
        let path = request.baseURL.appending(request.path)
        guard let multipartFormHeader = multipartFormHeader else {
            return Endpoint(path: path, method: request.method, task: request.task, cachePolicy: request.cachePolicy, httpHeaderFields: request.headerFields)
        }

        let updatedRequest = request.updateHeaderFields([multipartFormHeader])
        return Endpoint(path: path, method: updatedRequest.method, task: updatedRequest.task, httpHeaderFields: updatedRequest.headerFields)
    }

    func requestMapping(for endpoint: Endpoint) -> Result<URLRequest, GrowthNetworkError> {
        do {
            let urlRequest = try endpoint.urlRequest()
            return .success(urlRequest)
        } catch GrowthNetworkError.requestMapping(let url) {
            return .failure(GrowthNetworkError.requestMapping(url))
        } catch GrowthNetworkError.parameterEncoding(let error) {
            return .failure(GrowthNetworkError.parameterEncoding(error))
        } catch {
            return .failure(GrowthNetworkError.unknown(error))
        }
    }

    private func update(operation: Operation, task: URLSessionTask) {
        self.taskToOperationRWLock.write { [weak self] in
            guard let self = self else { return }
            self.taskToOperation[task] = operation
        }
    }

    private func remove(operation: Operation) {
        let sessionTask: URLSessionTask? = self.taskToOperationRWLock.read { [weak self] in
            guard let self = self else { return nil }
            guard let task = self.taskToOperation.keysForValue(value: operation).first else {
                Log.debug("Task associated to operation doesn't exist", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
                return nil
            }

            return task
        }

        self.taskToOperationRWLock.write { [weak self] in
            guard let self = self else { return }
            guard let sessionTask = sessionTask else { return }

            self.taskToOperation.removeValue(forKey: sessionTask)
        }
    }

}

extension NetworkManager: URLSessionDelegate {

    /**
    Requests credentials from the delegate in response to a session-level authentication request from the remote server.
    
     This method is called in two situations:
     - When a remote server asks for client certificates or Windows NT LAN Manager (NTLM) authentication, to allow your app to provide appropriate credentials
     - When a session first establishes a connection to a remote server that uses SSL or TLS, to allow your app to verify the server’s certificate chain

     - Parameters:
        - session: The session containing the task that requested authentication.
        - challenge: An object that contains the request for authentication.
        - completionHandler: A handler that your delegate method must call. This completion handler takes the following parameters::
            - disposition—One of several constants that describes how the challenge should be handled.
            - credential—The credential that should be used for authentication if disposition is NSURLSessionAuthChallengeUseCredential, otherwise NULL.
    */
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard self.optIntoCertificatePinning else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        guard let pinningPolicy = self.pinningPolicy else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            let trust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        let host = challenge.protectionSpace.host
        let result = pinningPolicy.pin(with: trust, host: host)

        guard result.isSuccess else {
            if let error = result.error {
                Log.error("Failed trust evaluation for the specified certificates and policies. Error \(error.localizedDescription)", logger: self.logger, shouldLog: self.logSettings.shouldAllowLogging)
            }
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        completionHandler(.useCredential, URLCredential(trust: trust))
    }

}

extension NetworkManager: URLSessionDataDelegate {

    /**
     Tells the delegate that the session finished collecting metrics for the task.
     
     - parameters:
        - session: The `URLsession` collecting the metrics.
        - task: The `URLSessionTask` whose metrics have been collected.
        - metrics: The collected `URLSessionTaskMetrics`.
    */
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        let operation: DataTaskOperation? = self.taskToOperationRWLock.read { [weak self] in
            guard let self = self else { return nil }

            return self.taskToOperation[task] as? DataTaskOperation
        }

        guard let taskOperation = operation, let transactionMetrics = metrics.transactionMetrics.first else { return }

        let newMetrics = Metrics(sessionTaskTransactionMetrics: transactionMetrics, taskInterval: metrics.taskInterval.duration)
        taskOperation.metrics = newMetrics
    }

}
