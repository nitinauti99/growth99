
import Foundation

/**
 A value type encapsulating the metrics for a session task.
*/
/// - Tag: MetricsTag
public struct GrowthMetrics {

    /// The time taken for the URLSession task to complete the name lookup for the resource.
    private(set) var domainLookupTimeInterval: TimeInterval?

    /// The time taken for the URLSession task to establish a TCP connection to the server.
    private(set) var tcpConnectionTimeInterval: TimeInterval?

    /// The time taken for the URLSession task to complete a TLS security handshake to secure the current connection.
    private(set) var tlsSecurityHandshakeTimeInterval: TimeInterval?

    /// The time taken for the URLSession task to finish requesting server or local resources.
    private(set) var requestResourceTimeInterval: TimeInterval?

    /// The time taken for the URLSession task to receive the complete response from the server.
    private(set) var responseTimeInterval: TimeInterval?

    /// The time interval between when a URLSession task is instantiated and when the task is completed.
    private(set) var taskInterval: TimeInterval

    /**
        Initializer to instantiate metrics object
     
        - parameters:
            - sessionTaskTransactionMetrics: `URLSessionTaskTransactionMetrics` which encapsulates the performance metrics collected during the execution of a session task.
            - taskInterval: The time interval between when a task is instantiated and when the task is completed.
     */
    init(sessionTaskTransactionMetrics: URLSessionTaskTransactionMetrics, taskInterval: TimeInterval) {
        if let domainLookupEndDate = sessionTaskTransactionMetrics.domainLookupEndDate, let domainLookupStartDate = sessionTaskTransactionMetrics.domainLookupStartDate {
            self.domainLookupTimeInterval = domainLookupEndDate.timeIntervalSince(domainLookupStartDate)
        }

        if let connectEndDate = sessionTaskTransactionMetrics.connectEndDate, let connectStartDate = sessionTaskTransactionMetrics.connectStartDate {
            self.tcpConnectionTimeInterval = connectEndDate.timeIntervalSince(connectStartDate)
        }

        if let secureConnectionEndDate = sessionTaskTransactionMetrics.secureConnectionEndDate, let secureConnectionStartDate = sessionTaskTransactionMetrics.secureConnectionStartDate {
            self.tlsSecurityHandshakeTimeInterval = secureConnectionEndDate.timeIntervalSince(secureConnectionStartDate)
        }

        if let requestEndDate = sessionTaskTransactionMetrics.requestEndDate, let requestStartDate = sessionTaskTransactionMetrics.requestStartDate {
            self.requestResourceTimeInterval = requestEndDate.timeIntervalSince(requestStartDate)
        }

        if let responseEndDate = sessionTaskTransactionMetrics.responseEndDate, let responseStartDate = sessionTaskTransactionMetrics.responseStartDate {
            self.responseTimeInterval = responseEndDate.timeIntervalSince(responseStartDate)
        }

        self.taskInterval = taskInterval
    }

}

extension GrowthMetrics: CustomStringConvertible {

    /// A textual representation of the total time interval between when a task is instantiated and when the task is completed.
    public var description: String {
        var metricsList = ["[METRICS]"]
        metricsList.append(self.taskIntervalDescription)

        return metricsList.joined(separator: "\n")
    }

    /**
    A detailed textual representation of the various [metrics](x-source-tag://MetricsTag).
     
    This includes:
    - domainLookupTimeInterval
    - tcpConnectionTimeInterval
    - tlsSecurityHandshakeTimeInterval
    - requestResourceTimeInterval
    - responseTimeInterval
    - taskInterval
     */
    public var detailedMetricsDescription: String {
        var metricsList = ["[METRICS]"]
        metricsList.append(self.domainLookupTimeIntervalDescription)
        metricsList.append(self.tcpConnectionDescription)
        metricsList.append(self.tlsSecurityHandshakeDescription)
        metricsList.append(self.requestResourceDescription)
        metricsList.append(self.responseDescription)
        metricsList.append(self.taskIntervalDescription)

        return metricsList.joined(separator: "\n")
    }

    private var domainLookupTimeIntervalDescription: String {
        "[Domain Lookup TimeInterval] :: \(String(format: "%.4f", self.domainLookupTimeInterval ?? String.blank))"
    }

    private var tcpConnectionDescription: String {
        "[TCP Connection TimeInterval] :: \(String(format: "%.4f", self.tcpConnectionTimeInterval ?? String.blank))"
    }

    private var tlsSecurityHandshakeDescription: String {
        "[Security Handshake TimeInterval] :: \(String(format: "%.4f", self.tlsSecurityHandshakeTimeInterval ?? String.blank))"
    }

    private var requestResourceDescription: String {
        "[Request Resource TimeInterval] :: \(String(format: "%.4f", self.requestResourceTimeInterval ?? String.blank))"
    }

    private var responseDescription: String {
        "[Response TimeInterval] :: \(String(format: "%.4f", self.responseTimeInterval ?? String.blank))"
    }

    private var taskIntervalDescription: String {
        "[Total TimeInterval] :: \(String(format: "%.4f", self.taskInterval))"
    }

}
