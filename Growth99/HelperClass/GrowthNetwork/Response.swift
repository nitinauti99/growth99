
import Foundation

public final class Response: CustomDebugStringConvertible {

    /// The status code of the response.
    public let statusCode: Int

    /// The response data.
    public let data: Data

    /// The original URLRequest for the response.
    public let request: URLRequest?

    /// The HTTPURLResponse object.
    public let response: HTTPURLResponse?

    /// Metrics object encapsulating the performance metrics collected during the execution of this URLSession task
    public let metrics: Metrics?

    public init(statusCode: Int, data: Data, request: URLRequest? = nil, response: HTTPURLResponse? = nil, metrics: Metrics? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.request = request
        self.response = response
        self.metrics = metrics
    }

    /// A text description of the `Response`.
    public var description: String {
        "Status Code: \(statusCode), Data Length: \(data.count)"
    }

    /// Returns all the headerFields of the underlying HTTPURLResponse
    public var allHeaderFields: [AnyHashable: Any]? {
        self.response?.allHeaderFields
    }

    /// A text description of the `Response`. Suitable for debugging.
    public var debugDescription: String {
        let requestDescription = request.map { "\($0.httpMethod!) \($0)" } ?? "nil"
        let requestHeaders = request?.allHTTPHeaderFields ?? ["": ""]
        let requestBody = request?.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        let responseDescription = response.map { response in
            var headers: [AnyHashable: Any] = [:]

            #if DEBUG
            headers = response.allHeaderFields
            #endif

            return """
            [Status Code]: \(response.statusCode)
            [Headers]:
            \(headers)
            """
        } ?? "nil"
        let metricsDescription = metrics?.description ?? String.blank

        return """
        [Request]: \(requestDescription)
        [Request Headers]: \(requestHeaders)
        [Request Body]: \n\(requestBody)
        [Response]: \n\(responseDescription)
        \(metricsDescription)
        """
    }
}

extension Response {

    func responseDescription(for logSettings: LogSettings) -> String {
        var components: [String] = ["\r"]

        if logSettings.logOptions.contains(.logResponseUrl), let urlRequest = self.request, let method = urlRequest.httpMethod, let url = urlRequest.url {
            components.append("[Request:] \(method) \(url.absoluteString)")
        }

        self.response.map { components.append("[Status Code:] \($0.statusCode)") }

        if logSettings.logOptions.contains(.logResponseHeaders) {
            var headers: [String: Any] = [:]

            components.append("[Response Headers]")

            if let responseHeaderFields = self.response?.allHeaderFields as? [String: Any] {
                responseHeaderFields.forEach { key, value in
                    headers.updateValue(logSettings.redactedResponseHeaderKeys.contains(key) ? logSettings.redactedValue : value, forKey: key)
                }
            }

            headers.forEach { key, value in components.append("\t\(key): \(value)") }
        }

        if logSettings.logOptions.contains(.logResponseData), let jsonObject = JSON.dataToJSONObject(self.data) {
            components.append("[Response Data]")

            let redactedObject = JSON.redactJSONKeys(logSettings.redactedResponseBodyKeys, object: jsonObject, redactedValue: logSettings.redactedValue)
            if let prettyJSONString = JSON.prettyStringFromJSONObject(redactedObject) {
                components.append(prettyJSONString)
            }
        }

        if let metrics = self.metrics, logSettings.metricsDescription != MetricsDescription.none {
            switch logSettings.metricsDescription {
            case .compact:
                components.append(metrics.description)
            case .detailed:
                components.append(metrics.detailedMetricsDescription)
            default:
                break
            }
        }

        return components.joined(separator: "\n")
    }
}

public extension Response {

    /**
     Returns the `Response` if the `statusCode` falls within the specified range.
     
     - statusCodes: The range of acceptable status codes.
     - throws: `NetworkError.statusCode` when others are encountered.
     */
    func filter<R: RangeExpression>(statusCodes: R) throws -> Response where R.Bound == Int {
        guard statusCodes.contains(statusCode) else {
            throw GrowthNetworkError.statusCode(self)
        }
        return self
    }

    /**
    Returns the `Response` if the `statusCode` falls within the specified set.
    
    - parameters:
        - statusCodes: A `Set` of status codes.
     
    - throws: `NetworkError.statusCode` when others are encountered.
    */
    func filter(statusCodes: Set<Int>) throws -> Response {
        guard statusCodes.contains(self.statusCode) else {
            throw GrowthNetworkError.statusCode(self)
        }
        return self
    }

    /**
     Returns the `Response` if it has the specified `statusCode`.
     
     - statusCode: The acceptable status code.
     - throws: `NetworkError.statusCode` when others are encountered.
     */
    func filter(statusCode: Int) throws -> Response {
        try self.filter(statusCodes: statusCode...statusCode)
    }

    /**
     Returns the `Response` if the `statusCode` falls within the range 200 - 299.
     
     - throws: `NetworkError.statusCode` when others are encountered.
     */
    func filterSuccessfulStatusCodes() throws -> Response {
        try self.filter(statusCodes: 200...299)
    }

    /**
     Returns the `Response` if the `statusCode` falls within the range 200 - 399.
     
     - throws: `NetworkError.statusCode` when others are encountered.
     */
    func filterSuccessfulStatusAndRedirectCodes() throws -> Response {
        try self.filter(statusCodes: 200...399)
    }

    /**
     Maps data received from the signal into a JSON object.
    
     - failsOnEmptyData: A Boolean value determining whether the mapping should fail if the data is empty.
     */
    func mapJSON(failsOnEmptyData: Bool = true) throws -> Any {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            if data.count < 1 && !failsOnEmptyData {
                return NSNull()
            }
            throw GrowthNetworkError.jsonMapping(self)
        }
    }

    /**
     Maps data received from the signal into a Decodable object.

     - atKeyPath: Optional key path at which to parse object. By default set to `nil` indicating there is no keypath and will return the root object.
     - using: A `JSONDecoder` instance which is used to decode data to an object.
     */
    func map<T: Decodable>(_ type: T.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) throws -> T {
        let serializeToData: (Any) throws -> Data? = { jsonObject in
            guard JSONSerialization.isValidJSONObject(jsonObject) else { return nil }

            do {
                return try JSONSerialization.data(withJSONObject: jsonObject)
            } catch {
                throw GrowthNetworkError.jsonMapping(self)
            }
        }
        let jsonData: Data
        keyPathCheck: if let keyPath = keyPath {
            guard let jsonObject = (try mapJSON(failsOnEmptyData: failsOnEmptyData) as? NSDictionary)?.value(forKeyPath: keyPath), !(jsonObject is NSNull) else {
                if failsOnEmptyData {
                    throw GrowthNetworkError.jsonSerializationNoDataAtKeyPath(keyPath)
                } else {
                    jsonData = data
                    break keyPathCheck
                }
            }

            if let data = try serializeToData(jsonObject) {
                jsonData = data
            } else {
                let wrappedJsonObject = ["value": jsonObject]
                let wrappedJsonData: Data
                if let data = try serializeToData(wrappedJsonObject) {
                    wrappedJsonData = data
                } else {
                    throw GrowthNetworkError.jsonMapping(self)
                }
                do {
                    return try decoder.decode(DecodableWrapper<T>.self, from: wrappedJsonData).value
                } catch let error {
                    throw GrowthNetworkError.objectMapping(error, self)
                }
            }
        } else {
            jsonData = data
        }
        do {
            if jsonData.count < 1 && !failsOnEmptyData {
                if let emptyJSONObjectData = "{}".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(T.self, from: emptyJSONObjectData) {
                    return emptyDecodableValue
                } else if let emptyJSONArrayData = "[{}]".data(using: .utf8), let emptyDecodableValue = try? decoder.decode(T.self, from: emptyJSONArrayData) {
                    return emptyDecodableValue
                }
            }
            return try decoder.decode(T.self, from: jsonData)
        } catch let error {
            throw GrowthNetworkError.objectMapping(error, self)
        }
    }

}

private struct DecodableWrapper<T: Decodable>: Decodable {
    let value: T
}

extension Response: Equatable {

    public static func == (lhs: Response, rhs: Response) -> Bool {
        guard lhs.statusCode == rhs.statusCode else {
            return false
        }

        guard lhs.data == rhs.data else {
            return false
        }

        if let lhsRequest = lhs.request, let rhsRequest = rhs.request {
            guard lhsRequest == rhsRequest else {
                return false
            }
        }

        if let lhsResponse = lhs.response, let rhsResponse = rhs.response {
            guard lhsResponse == rhsResponse else {
                return false
            }
        }

        return true
    }

}
