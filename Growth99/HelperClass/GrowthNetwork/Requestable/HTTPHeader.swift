
import Foundation

/// A `String` alias to represent MIME types
public typealias MIMEType = String

/// A `String` alias to represent Access token
public typealias AccessToken = String

/**
    The header sections of a HTTP request are represented in the `HTTPHeader` enum
*/
/// - Tag: HTTPHeaderTag
public enum HTTPHeader {

    ///  The `Content-Disposition` response header indicates if the content is expected to be displayed _inline_ or as an _attachment_.
    case contentDisposition(String)

    /**
     The `Accept` request header advertises which content types, expressed as _MIME types_, the client is able to understand.
     
        - [MIMEType]: A list of content types in `String` format.
     */
    case accept([MIMEType])

    /**
    The `Content-Type` entity header is used to indicate the media type of the resource.
    
       - MIMEType: The media type of the resource in `String` format.
    */
    case contentType(MIMEType)

    /**
    The `Authorization` request header contains the credentials to authenticate a user agent with a server.
    
       - AccessToken: The credentials to authenticate a user agent in `String` format.
    */
    case authorization(AccessToken)

    /**
    Custom request header can hold the key and the corresponding value of any custom HTTP header
    
       - key: The _key_ for the custom HTTP header.
       - value: The _value_ for the custom HTTP header.
    */
    case custom(key: String, value: String)

    /// The request header Key.
    public var key: String {
        switch self {
        case .contentDisposition:
            return "Content-Disposition"
        case .accept:
            return "Accept"
        case .contentType:
            return "Content-Type"
        case .authorization:
            return "Authorization"
        case .custom(let key, _):
            return key
        }
    }

    /// The request header Value.
    public var requestHeaderValue: String {
        switch self {
        case .contentDisposition(let disposition):
            return disposition
        case .accept(let types):
            return types.joined(separator: ", ")
        case .contentType(let type):
            return type
        case .authorization(let token):
            return token
        case .custom(_, let value):
            return value
        }
    }

    /// The default headers provided by `HTTPHeader`.
    public static var defaultHeaders: [HTTPHeader] {
        [.accept(["application/json"]), .contentType("application/json")]
    }

    /**
        Helper function to convert a request header dictionary to a list of `HTTPHeader`
       
        - Parameters:
           - headers: The request header dictionary
     
        - Returns: The list of request headers in `[HTTPHeader]` format
    */
    public static func httpHeaders(from headers: [String: String]) -> [HTTPHeader] {
        headers.map({ key, value in
            HTTPHeader.custom(key: key, value: value)
        })
    }

}

extension HTTPHeader: Equatable {

    public static func == (lhs: HTTPHeader, rhs: HTTPHeader) -> Bool {
        switch (lhs, rhs) {
        case (let .contentDisposition(lhsString), let .contentDisposition(rhsString)):
            return lhsString == rhsString
        case (let .accept(lhsMimeTypes), let .accept(rhsMimeTypes)):
            return lhsMimeTypes == rhsMimeTypes
        case (let .contentType(lhsType), let .contentType(rhsType)):
            return lhsType == rhsType
        case (let .authorization(lhsToken), let .authorization(rhsToken)):
            return lhsToken == rhsToken
        case (let .custom(lhsKey, lhsValue), let .custom(rhsKey, rhsValue)):
            return lhsKey == rhsKey && lhsValue == rhsValue
        default:
            return false
        }
    }

}
