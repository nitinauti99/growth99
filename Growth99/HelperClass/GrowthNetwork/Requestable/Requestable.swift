
import Foundation

/// - Tag: RequestableTag
public protocol Requestable {

    /**
    The consistent part of the web address.
    
        let githubUser = "https://api.github.com/user"
        baseURL = "https://api.github.com"
    */
    var baseURL: String { get }

    /**
    The path identifies the specific resource in the host.
    
        let githubUser = "https://api.github.com/user"
        path = "/user"
    */
    var path: String { get }

    /**
    The request methods to indicate the desired action to be performed for a given resource.
    # Request types supported include:
    
       - GET
       - POST
       - PUT
       - DELETE
     
     More information present [here](x-source-tag://HTTPMethodTag).
    */
    var method: HTTPMethod { get }

    /**
    The type of Request task. Request types could include data, upload, download etc.
    
     More information present [here](x-source-tag://TaskTag).
    */
    var task: RequestTask { get }

    /**
    The header sections of a HTTP request.
     
     More information present [here](x-source-tag://HTTPHeaderTag).
    */
    var headerFields: [HTTPHeader]? { get }

    /**
    This communicates to the `NetworkManager` whether a request is an authentication request or one which relies on authentication credentials.
     
     More information present [here](x-source-tag://RequestModeTag).
    */
    var requestMode: RequestMode { get }

    /**
    Cache policy for a request, defaults to .useProtocolCachePolicy.

    */
    var cachePolicy: URLRequest.CachePolicy { get }

    /**
    Setting up stubs, for mocking or testing. Defaults to 'never'.

     More information present [here](x-source-tag://Stub).
    */
    var stub: Stub { get }

}

public extension Requestable {

    /**
    Returns the URL concatenating the `baseURL` and `path`.
    */
    var requestURL: URL? {
        URL(string: self.baseURL.appending(self.path))
    }

    /**
    Returns the default cache policy
    */
    var cachePolicy: URLRequest.CachePolicy {
        .useProtocolCachePolicy
    }

    /**
    Returns default stub
    */
    var stub: Stub {
        Stub()
    }

}

/**
    `RequestMode` enum communicates to the `NetworkManager` whether a certain request is an authentication request or one which relies on authentication credentials.
    It helps the underlying API to add network requests to specific operation queues and makes sure to suspend only the auth queue (and give a chance to re-auth) when auth credentials
    expires, so that the requests independant of auth are not impacted.

    Works in tandem with [Authenticator](x-source-tag://Authenticator) to formalize re-authentication flow of an app. `noAuth` type should be preferred if not using Authenticator.
*/
/// - Tag: RequestModeTag
public enum RequestMode {

    /// This mode considers the current request as an authentication request.
    case authRequest

    /// This mode considers the current request to be relying on proper authentication credentials.
    case requiresAuth

    /// This mode considers the current request not to be relying on authentication credentials.
    case noAuth

}

internal extension Requestable {

    func updateHeaderFields(_ headerFields: [HTTPHeader]) -> Requestable {
        var requestableHeaderFields = self.headerFields ?? HTTPHeader.defaultHeaders

        for newHeader in headerFields {
            requestableHeaderFields.removeAll(where: { $0.key == newHeader.key })
            requestableHeaderFields.append(newHeader)
        }

        return RequestableType(path: self.path,
                               baseURL: self.baseURL,
                               method: self.method,
                               task: self.task,
                               cachePolicy: self.cachePolicy,
                               headerFields: requestableHeaderFields,
                               mode: self.requestMode)
    }
}

internal class RequestableType: Requestable {

    var baseURL: String
    var path: String
    var method: HTTPMethod
    var task: RequestTask
    var cachePolicy: URLRequest.CachePolicy
    var headerFields: [HTTPHeader]?
    var requestMode: RequestMode
    var stub: Stub

    init(path: String,
         baseURL: String = "",
         method: HTTPMethod = .GET,
         task: RequestTask = .requestPlain,
         cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
         headerFields: [HTTPHeader] = HTTPHeader.defaultHeaders,
         mode: RequestMode = .noAuth,
         stub: Stub = Stub()) {
        self.path = path
        self.baseURL = baseURL
        self.method = method
        self.task = task
        self.cachePolicy = cachePolicy
        self.headerFields = headerFields
        self.requestMode = mode
        self.stub = stub
    }

}
