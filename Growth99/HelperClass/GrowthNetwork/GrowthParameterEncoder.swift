
import Foundation

public typealias Parameters = [String: Any]

public protocol GrowthParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum ParameterEncoding {

    case urlEncoding(arrayEncoding: URLParameterEncoder.ArrayEncoding = .noBrackets, boolEncoding: URLParameterEncoder.BoolEncoding = .numeric)

    case jsonEncoding

    case urlAndJsonEncoding(arrayEncoding: URLParameterEncoder.ArrayEncoding = .noBrackets, boolEncoding: URLParameterEncoder.BoolEncoding = .numeric)

    public func encode(urlRequest: inout URLRequest, bodyParameters: Parameters?, urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding(let arrayEncoding, let boolEncoding):
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder(arrayEncoding: arrayEncoding, boolEncoding: boolEncoding).encode(urlRequest: &urlRequest, with: urlParameters)

            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)

            case .urlAndJsonEncoding(let arrayEncoding, let boolEncoding):
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder(arrayEncoding: arrayEncoding, boolEncoding: boolEncoding).encode(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }

}

public struct JSONParameterEncoder: GrowthParameterEncoder {

    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw GrowthNetworkError.encodingFailed
        }
    }

}

public struct URLParameterEncoder: GrowthParameterEncoder {

    public let arrayEncoding: ArrayEncoding
    public let boolEncoding: BoolEncoding
    public enum ArrayEncoding {
        case brackets
        case noBrackets

        func encode(key: String) -> String {
            switch self {
            case .brackets:
                return "\(key)[]"
            case .noBrackets:
                return key
            }
        }
    }

    public enum BoolEncoding {
        case numeric
        case literal

        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }

    public init(arrayEncoding: ArrayEncoding = .noBrackets, boolEncoding: BoolEncoding = .numeric) {
        self.arrayEncoding = arrayEncoding
        self.boolEncoding = boolEncoding
    }

    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw GrowthNetworkError.missingURL }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? String.blank) + self.query(parameters)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            urlRequest.url = urlComponents.url
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = Data(query(parameters).utf8)
        }
    }

    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += self.queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += self.queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += self.queryComponents(fromKey: self.arrayEncoding.encode(key: key), value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((self.encode(key), self.encode(self.boolEncoding.encode(value: value.boolValue))))
            } else {
                components.append((self.encode(key), self.encode("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((self.encode(key), self.encode(boolEncoding.encode(value: bool))))
        } else {
            components.append((self.encode(key), self.encode("\(value)")))
        }

        return components
    }

    private func encode(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowedCharacterSet()) ?? string
    }

}

extension ParameterEncoding: Equatable {

    public static func == (lhs: ParameterEncoding, rhs: ParameterEncoding) -> Bool {
        switch (lhs, rhs) {
        case (let .urlEncoding(lhsArrayEncoding, lhsBoolEncoding), let .urlEncoding(rhsArrayEncoding, rhsBoolEncoding)):
            return lhsArrayEncoding == rhsArrayEncoding && lhsBoolEncoding == rhsBoolEncoding
        case (let .urlAndJsonEncoding(lhsArrayEncoding, lhsBoolEncoding), let .urlAndJsonEncoding(rhsArrayEncoding, rhsBoolEncoding)):
            return lhsArrayEncoding == rhsArrayEncoding && lhsBoolEncoding == rhsBoolEncoding
        case (.jsonEncoding, .jsonEncoding):
            return true
        default:
            return false
        }
    }
}
