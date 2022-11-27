
import Foundation

public enum GrowthNetworkError: Error {

    /// Encoding failed
    case encodingFailed

    /// Invalid data with successful status code
    case invalidDataWithSuccessfulStatusCode

    /// Invalid response
    case invalidResponse

    /// Failed JSON serialization for [response](x-source-tag://ResponseTag)
    case jsonMapping(Response)

    /// Failed JSON serialization due to no data at a specific keypath
    case jsonSerializationNoDataAtKeyPath(String)

    /// Missing URL in `URLRequest`
    case missingURL

    /// Failed to map object with a specific `Error` for [response](x-source-tag://ResponseTag)
    case objectMapping(Error, Response)

    /// Failed parameter encoding due to a specific `Error`
    case parameterEncoding(Error)

    /// Nil parameters
    case parametersNil

    /// Pinning Failed
    case pinningFailed

    /// Setting Policy failed
    case policyValidationFailed

    /// Request was cancelled
    case requestCancelled

    /// Response failed
    case responseFailed

    /// Request Mapping failed for a specific path
    case requestMapping(String)

    /// [Response](x-source-tag://ResponseTag) does not have the required status code
    case statusCode(Response)

    /// Unable to complete request due to failed token refresh
    case tokenRefreshFailed

    /// Unknown `Error`
    case unknown(Error)

}

public extension GrowthNetworkError {

    /// [Response](x-source-tag://ResponseTag) associated to a `GrowthNetworkError`.
    var response: Response? {
        switch self {
        case .encodingFailed:
            return nil
        case .invalidDataWithSuccessfulStatusCode:
            return nil
        case .invalidResponse:
            return nil
        case .jsonMapping(let response):
            return response
        case .jsonSerializationNoDataAtKeyPath:
            return nil
        case .missingURL:
            return nil
        case .objectMapping(_, let response):
            return response
        case .parameterEncoding:
            return nil
        case .parametersNil:
            return nil
        case .pinningFailed:
            return nil
        case .policyValidationFailed:
            return nil
        case .requestCancelled:
            return nil
        case .responseFailed:
            return nil
        case .requestMapping:
            return nil
        case .statusCode(let response):
            return response
        case .tokenRefreshFailed:
            return nil
        case .unknown:
            return nil
        }

    }

    internal var underlyingError: Swift.Error? {
        switch self {
        case .encodingFailed:
            return nil
        case .invalidDataWithSuccessfulStatusCode:
            return nil
        case .invalidResponse:
            return nil
        case .jsonMapping:
            return nil
        case .jsonSerializationNoDataAtKeyPath:
            return nil
        case .missingURL:
            return nil
        case .objectMapping(let error, _):
            return error
        case .parameterEncoding(let error):
            return error
        case .parametersNil,
             .pinningFailed,
             .policyValidationFailed,
             .requestCancelled,
             .responseFailed,
             .requestMapping,
             .statusCode,
             .tokenRefreshFailed:
            return nil
        case .unknown(let error):
            return error
        }
    }

}

extension GrowthNetworkError: LocalizedError {

    /// Error description associated to a `GrowthNetworkError`.
    public var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Encoding failed"
        case .invalidDataWithSuccessfulStatusCode:
            return "Successful status code with failed to JSON mapping"
        case .invalidResponse:
            return "Invalid response"
        case .jsonMapping:
            return "Failed to map data to json"
        case .jsonSerializationNoDataAtKeyPath:
            return "Data corresponding to the keyPath is null"
        case .missingURL:
            return "Missing URL"
        case .objectMapping:
            return "Failed to map data to decodable object"
        case .parameterEncoding:
            return "nil"
        case .parametersNil:
            return "Parameters nil"
        case .pinningFailed:
            return "Pinning validation failed"
        case .policyValidationFailed:
            return "Setting policy for server trust failed"
        case .requestCancelled:
            return "Request was cancelled"
        case .responseFailed:
            return "Response from request operation failed"
        case .requestMapping:
            return "Failed to map request to URLRequest"
        case .statusCode:
            return "Invalid status code"
        case .tokenRefreshFailed:
            return "Could not complete request due to failed token refresh"
        case .unknown(let error):
            return error.localizedDescription
        }
    }

}

extension GrowthNetworkError: CustomNSError {

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        userInfo[NSUnderlyingErrorKey] = underlyingError
        return userInfo
    }

}

extension GrowthNetworkError: Equatable {

    public static func == (lhs: GrowthNetworkError, rhs: GrowthNetworkError) -> Bool {
        switch (lhs, rhs) {
        case (let .jsonMapping(lhsResponse), let .jsonMapping(rhsResponse)):
            return lhsResponse.statusCode == rhsResponse.statusCode
        case (let .objectMapping(lhsError, lhsResponse), let .objectMapping(rhsError, rhsResponse)):
            return (lhsError.localizedDescription == rhsError.localizedDescription && lhsResponse.statusCode == rhsResponse.statusCode)
        case (let .parameterEncoding(lhsError), let .parameterEncoding(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (let .requestMapping(lhsString), let .requestMapping(rhsString)):
            return lhsString == rhsString
        case (let .statusCode(lhsResponse), let .statusCode(rhsResponse)):
            return lhsResponse.statusCode == rhsResponse.statusCode
        case (let .unknown(lhsError), let .unknown(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return lhs.errorDescription == rhs.errorDescription
        }
    }

}
