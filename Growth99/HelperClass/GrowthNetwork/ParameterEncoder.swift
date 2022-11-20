//
//  ParameterEncoder.swift
//  FargoNetwork
//
//  Created by SopanSharma on 9/17/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

/// Protocol to encode specified url/body parameters
public protocol ParameterEncoder {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

/// Enum to provide encoding types
public enum ParameterEncoding {

    /// Encodes url parameters with [ArrayEncoding](x-source-tag://ArrayEncodingTag) and [BoolEncoding](x-source-tag://BoolEncodingTag)
    case urlEncoding(arrayEncoding: URLParameterEncoder.ArrayEncoding = .noBrackets, boolEncoding: URLParameterEncoder.BoolEncoding = .numeric)

    /// to encode json body parameters
    case jsonEncoding

    /// to encode both url and body parameters present in the request with [ArrayEncoding](x-source-tag://ArrayEncodingTag) and [BoolEncoding](x-source-tag://BoolEncodingTag)
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

/// JSONParameterEncoder type to perform json encoding
public struct JSONParameterEncoder: ParameterEncoder {

    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw FargoNetworkError.encodingFailed
        }
    }

}

/// URLParameterEncoder type to perform url encoding
public struct URLParameterEncoder: ParameterEncoder {

    /// The encoding to use for `Array` parameters.
    public let arrayEncoding: ArrayEncoding

    /// The encoding to use for `Bool` parameters.
    public let boolEncoding: BoolEncoding

    /// Configure how `Array` parameters are encoded
    /// - Tag: ArrayEncodingTag
    public enum ArrayEncoding {
        /// An empty set of square brackets is appended to the key for every value. This is the default behavior.
        case brackets
        /// No brackets are appended. The key is encoded as is.
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

    /// Configures how `Bool` parameters are encoded.
    /// - Tag: BoolEncodingTag
    public enum BoolEncoding {
        /// Encode `true` as `1` and `false` as `0`. This is the default behavior.
        case numeric
        /// Encode `true` and `false` as string literals.
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
        guard let url = urlRequest.url else { throw FargoNetworkError.missingURL }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + self.query(parameters)
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

    // Using Alamofire's way of creating components since it handles all the different cases properly
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
