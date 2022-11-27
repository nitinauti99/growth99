
import Foundation

public extension URLRequest {
    /// A textual representation of this instance, including the `HTTPMethod` and `URL` if the `URLRequest` has been
    /// created, as well as the headers.
    var debugDescription: String {
        guard let url = self.url, let method = self.httpMethod else { return "No request created yet." }

        return """
        [Url]: \(url.absoluteString)
        [Method]: \(method)
        [Headers]:
        \(String(describing: self.allHTTPHeaderFields))
        """
    }

}

extension URLRequest {

    mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            let encodable = AnyEncodable(encodable)
            httpBody = try encoder.encode(encodable)

            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }

            return self
        } catch {
            throw GrowthNetworkError.encodingFailed
        }
    }

}

extension URLRequest {

    func requestDescription(for logSettings: LogSettings, with httpAdditionalHeaders: [AnyHashable: Any]?) -> String {
        var components: [String] = ["\r"]

        guard let url = self.url, let method = self.httpMethod else {
            return "[Request] nil"
        }

        if logSettings.logOptions.contains(.logRequestUrl) {
            components.append("[Request:] \(method) \(url.absoluteString)")
        }

        if logSettings.logOptions.contains(.logRequestHeaders) {
            var headers: [String: Any] = [:]

            components.append("[Request Headers]")

            if let requestHeaderFields = self.allHTTPHeaderFields {
                requestHeaderFields.forEach { key, value in
                    headers.updateValue(logSettings.redactedRequestHeaderKeys.contains(key) ? logSettings.redactedValue : value, forKey: key)
                }
            }

            headers.forEach { key, value in components.append("\t\(key): \(value)") }
        }

        if logSettings.logOptions.contains(.logAdditionalHeaders) {
            var headers: [String: Any] = [:]

            components.append("[Additional Headers]")

            if let httpAdditionalHeaders = httpAdditionalHeaders as? [String: Any] {
                httpAdditionalHeaders.forEach { key, value in
                    headers.updateValue(logSettings.redactedRequestHeaderKeys.contains(key) ? logSettings.redactedValue : value, forKey: key)
                }
            }

            headers.forEach { key, value in components.append("\t\(key): \(value)") }
        }

        if logSettings.logOptions.contains(.logRequestBody), let httpBody = self.httpBody, let jsonObject = JSON.dataToJSONObject(httpBody) {
            components.append("[Request Body]")

            let redactedObject = JSON.redactJSONKeys(logSettings.redactedRequestBodyKeys, object: jsonObject, redactedValue: logSettings.redactedValue)
            if let httpBodyString = JSON.prettyStringFromJSONObject(redactedObject) {
                components.append(httpBodyString)
            }
        }

        return components.joined(separator: "\n")
    }

}
