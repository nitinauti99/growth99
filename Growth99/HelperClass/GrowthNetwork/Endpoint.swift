
import Foundation

/**
 Used to convert a requestable protocol to a concrete type
*/
/// - Tag: EndpointTag
internal class Endpoint {

    let path: String
    let method: HTTPMethod
    let task: RequestTask
    let cachePolicy: URLRequest.CachePolicy
    private(set) var httpHeaderFields: [HTTPHeader]?

    /**
     Initializer to create an instance of Endpoint based on the expected parameters
     
     - parameters:
        - path: complete path of the request containing baseURL.
        - method: [HTTPMethod](x-source-tag://HTTPMethodTag) type, defaults to GET.
        - task: identify the [Task](x-source-tag://TaskTag) to be performed, defaults to requestPlain.
        - httpHeaderFields: [HTTPHeader](x-source-tag://HTTPHeaderTag) which would be part of the requestable.
     
     */
    init(path: String,
         method: HTTPMethod = .GET,
         task: RequestTask = .requestPlain,
         cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
         httpHeaderFields: [HTTPHeader]? = nil) {
        self.path = path
        self.method = method
        self.task = task
        self.cachePolicy = cachePolicy
        self.httpHeaderFields = httpHeaderFields
    }

    /**
     Function to update the existing headers with the new one.
     
     - parameters:
        - field: the existing headerField key which needs to be updated
        - newHeaderField: the new header field with which it should be updated
     
     */
    func update(headerField field: String, with newHeaderField: HTTPHeader) -> Endpoint {
        self.httpHeaderFields?.removeAll { $0.key == field }
        self.httpHeaderFields?.append(newHeaderField)

        return Endpoint(path: path, method: method, task: task, httpHeaderFields: self.httpHeaderFields)
    }

    /**
    Convenience API to update the request task with new one
    
    - parameters:
       - task: the new [Task](x-source-tag://TaskTag) with which current object should be updated.
    
    */
    func replacing(task: RequestTask) -> Endpoint {
        Endpoint(path: path, method: method, task: task, httpHeaderFields: httpHeaderFields)
    }

}

extension Endpoint {

    /**
    Create a `URLRequest` based on the existing properties of [Endpoint](x-source-tag://EndpointTag).
    
    Throws an error if the required parameters are missing.
    
    */
    internal func urlRequest() throws -> URLRequest {
        guard let url = URL(string: self.path) else {
            throw GrowthNetworkError.requestMapping(self.path)
        }

        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue

        if let httpHeaderFields = self.httpHeaderFields {
            for header in httpHeaderFields {
                request.setValue(header.requestHeaderValue, forHTTPHeaderField: header.key)
            }
        }

        request.cachePolicy = self.cachePolicy

        switch task {
        case .requestPlain, .uploadFile, .uploadData, .download, .multipartUpload:
            return request
        case .requestData(let data):
            request.httpBody = data
            return request
        case let .requestJSONEncodable(encodable):
            return try request.encoded(encodable: encodable)
        case let .requestCustomJSONEncodable(encodable, encoder: encoder):
            return try request.encoded(encodable: encodable, encoder: encoder)
        case .multipartCompositeUpload(_, let urlParameters):
            try URLParameterEncoder().encode(urlRequest: &request, with: urlParameters)
            return request
        case .requestParameters(let parameters, let encoding):
            switch encoding {
            case .urlEncoding:
                try encoding.encode(urlRequest: &request, bodyParameters: nil, urlParameters: parameters)
            case .jsonEncoding:
                try encoding.encode(urlRequest: &request, bodyParameters: parameters, urlParameters: nil)
            default:
                throw GrowthNetworkError.requestMapping("Error while performing \(encoding) with current parameters")
            }

            return request
        case .requestCompositeData(let bodyData, let urlParameters):
            request.httpBody = bodyData
            try URLParameterEncoder().encode(urlRequest: &request, with: urlParameters)
            return request
        case .requestCompositeParameters(let bodyParameters, let bodyEncoding, let urlParameters):
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
            return request
        }
    }

}
