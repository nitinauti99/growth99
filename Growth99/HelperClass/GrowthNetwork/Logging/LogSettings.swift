
import Foundation

/**
 Enum describing the level of [Metrics](x-source-tag://MetricsTag) information to be provided.
*/
/// - Tag: MetricsDescriptionTag
public enum MetricsDescription {

    /// Provides the total time interval taken for a `URLSessionTask`.
    case compact

    /**
    Provides a detailed breakdown of the various metrics for a `URLSessionTask`.
     
    This includes:
    - domainLookupTimeInterval
    - tcpConnectionTimeInterval
    - tlsSecurityHandshakeTimeInterval
    - requestResourceTimeInterval
    - responseTimeInterval
    - taskInterval
     */
    case detailed

    /// No metrics would be provided.
    case none
}

/// An object describing the various settings available for logging.
public class LogSettings {

    public static let `default` = LogSettings(shouldAllowLogging: true)

    /**
     An `OptionSet` describing the various combinations for logging.
    */
    /// - Tag: LogOptionsTag
    public struct LogOptions: OptionSet {

        public let rawValue: Int

        /// Logs the request URL.
        public static let logRequestUrl = LogOptions(rawValue: 1 << 0)

        /// Logs request Headers.
        public static let logRequestHeaders = LogOptions(rawValue: 1 << 1)

        /// Logs the request Body.
        public static let logRequestBody = LogOptions(rawValue: 1 << 2)

        /// Logs the response URL.
        public static let logResponseUrl = LogOptions(rawValue: 1 << 3)

        /// Logs response Headers.
        public static let logResponseHeaders = LogOptions(rawValue: 1 << 4)

        /// Logs response Data.
        public static let logResponseData = LogOptions(rawValue: 1 << 5)

        /// Logs Additional Headers.
        public static let logAdditionalHeaders = LogOptions(rawValue: 1 << 6)

        static let all: LogOptions = [.logRequestUrl, .logRequestHeaders, .logRequestBody, .logResponseUrl, .logResponseHeaders, .logResponseData, .logAdditionalHeaders]

        // Convenience

        /**
        Logs all the various options in [LogOptions](x-source-tag://LogOptionsTag) .
         
        This includes:
        - Request URL
        - Request Headers
        - Request Body
        - Response URL
        - Response Headers
        - Response Data
        - Additional Headers
         */
        public static let verbose = all

        /// Logs the Request URL, Response URL and Additional Headers.
        public static let info: LogOptions = [.logRequestUrl, .logResponseUrl, .logAdditionalHeaders]

        /// Logs the Response URL and Additional Headers.
        public static let error: LogOptions = [.logResponseUrl, .logAdditionalHeaders]

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    let shouldAllowLogging: Bool
    let metricsDescription: MetricsDescription
    let redactedValue: String
    let logOptions: LogOptions

    // MARK: - Request
    let redactedRequestHeaderKeys: [String]
    let redactedRequestBodyKeys: [String]

    // MARK: - Response
    let redactedResponseHeaderKeys: [String]
    let redactedResponseBodyKeys: [String]

    /**
     Creates a `LogSettings` object.
        
     - parameters:
         - shouldAllowLogging: A `Boolean` value indicating if logging is enabled.
         - metricsDescription: [MetricsDescription](x-source-tag://MetricsDescriptionTag) type, defaults to `compact`.
         - redactedValue: A `String` value used in place of any redacted attributes.
         - logOptions: [LogOptions](x-source-tag://LogOptionsTag) type, defaults to `verbose`.
         - redactedRequestHeaderKeys: An array of `request headers` keys whose values need to be redacted.
         - redactedRequestBodyKeys: An array of `request body` keys whose values need to be redacted.
         - redactedResponseHeaderKeys: An array of `response headers` keys whose values need to be redacted.
         - redactedResponseBodyKeys: An array of `response body` keys whose values need to be redacted.
    */
    public init(shouldAllowLogging: Bool = true,
                metricsDescription: MetricsDescription = .compact,
                redactedValue: String = "",
                logOptions: LogOptions = .verbose,
                redactedRequestHeaderKeys: [String] = [],
                redactedRequestBodyKeys: [String] = [],
                redactedResponseHeaderKeys: [String] = [],
                redactedResponseBodyKeys: [String] = []) {
        self.shouldAllowLogging = shouldAllowLogging
        self.metricsDescription = metricsDescription
        self.redactedValue = redactedValue
        self.logOptions = logOptions
        self.redactedRequestHeaderKeys = redactedRequestHeaderKeys
        self.redactedRequestBodyKeys = redactedRequestBodyKeys
        self.redactedResponseHeaderKeys = redactedResponseHeaderKeys
        self.redactedResponseBodyKeys = redactedResponseBodyKeys
    }

    convenience init(shouldAllowLogging: Bool) {
        self.init(shouldAllowLogging: shouldAllowLogging, metricsDescription: .compact, redactedValue: "", logOptions: .verbose, redactedRequestHeaderKeys: [], redactedRequestBodyKeys: [], redactedResponseHeaderKeys: [], redactedResponseBodyKeys: [])
    }
}

extension LogSettings: CustomStringConvertible {

    public var description: String {
        "<shouldAllowLogging: \(shouldAllowLogging),\n metricsDescription: \(metricsDescription),\n redactedValue: \(redactedValue),\n logOptions: \(logOptions),\n redactedRequestHeaderKeys: \(redactedRequestHeaderKeys),\n redactedRequestBodyKeys: \(redactedRequestBodyKeys),\n redactedResponseHeaderKeys: \(redactedResponseHeaderKeys),\n redactedResponseBodyKeys: \(redactedResponseBodyKeys)>"
    }

}
