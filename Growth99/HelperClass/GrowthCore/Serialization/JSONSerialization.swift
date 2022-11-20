

import Foundation

/**
 * Errors which can be thrown during JSONSerialization
 *
 * - notSerializable: Very generic, but means that the current object/value cannot be serialized or contains an object/value which cannot be serialized
 */
public enum JSONSerializationError: Error {
    case notSerializable
}

public enum JSONRoot {
    case array(JSONArray)
    case dictionary(JSONDictionary)

    public func toJSONData() throws -> Data {
        switch self {
        case .array(let array):
            return try array.toJSONData()
        case .dictionary(let dictionary):
            return try dictionary.toJSONData()
        }
    }
}

/**
 * Objects conforming to JSONSerializable can be serializing to JSON
 */
public protocol JSONSerializable {
    /**
     * Should return an Any instance which can be consumed by JSONSerialization for serialization to JSON
     *
     * - returns: Any which should be a JSON serializable object
     * - throws: JSONSerializationError
     */
    func toJSONSerializable() throws -> Any
}

/**
 * Protocol which is extended to provide JSONSerializable extensions for
 * `simple` types which are supported by JSON by default.
 * Float, Double, Int and String
 */
public protocol SimpleJSONSerializable: JSONSerializable { }

public extension SimpleJSONSerializable {
    func toJSONSerializable() throws -> Any {
        self as Any
    }
}

extension Bool: SimpleJSONSerializable { }
extension Float: SimpleJSONSerializable { }
extension Double: SimpleJSONSerializable { }
extension Int: SimpleJSONSerializable { }
extension UInt: SimpleJSONSerializable { }
extension String: SimpleJSONSerializable { }

// Extending Optional to conform to JSONSerializable
extension Optional: JSONSerializable {
    public func toJSONSerializable() throws -> Any {
        switch self {
        case .none:
            return NSNull()
        case .some(let value):
            // try to serialize it
            if let value = value as? JSONSerializable {
                return try value.toJSONSerializable()
            }

            throw JSONSerializationError.notSerializable
        }
    }
}

// Extending Array to conform to JSONSerializable
// Officially we want to solve this using
// `extension Array: JSONSerializable where Element: JSONSerializable`
// but this is not possible yet in Swift.
extension Array: JSONSerializable {
    public func toJSONSerializable() throws -> Any {
        let array: [Any] = try self.map { element in
            if let element = element as? JSONSerializable {
                return try element.toJSONSerializable()
            }

            // we found an element that doesn't conform to JSONSerializble
            throw JSONSerializationError.notSerializable
        }

        return array as Any
    }
}

public extension Array where Element: JSONSerializable {
    /**
     * Returns an Data instance containing JSON data. When this array contains
     * an object that is not `JSONSerializable` a `JSONSerializationError` will
     * be thrown.
     *
     * - returns Data
     * - throws JSONSerializationError.notSerializable
     */
    func toJSONData() throws -> Data {
        let array = try self.map { try $0.toJSONSerializable() }

        return try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions())
    }
}

// Extending Dictionary to conform to JSONSerializable
// Officially we want to solve this using
// `extension Dictionary: JSONSerializable where Key: StringLiteralConvertible, Value: JSONSerializable`
// but this is not possible yet in Swift.
extension Dictionary: JSONSerializable {
    public func toJSONSerializable() throws -> Any {
        var dictionary: [String: Any] = [:]

        try self.forEach { key, value in
            if let key = key as? String {
                if let value = value as? JSONSerializable {
                    dictionary[key] = try value.toJSONSerializable()
                } else {
                    throw JSONSerializationError.notSerializable
                }
            } else {
                throw JSONSerializationError.notSerializable
            }
        }

        return dictionary as Any
    }
}

public extension Dictionary where Key: ExpressibleByStringLiteral, Value: JSONSerializable {
    /**
     * Returns an Data instance containing JSON data. When this dictionary contains
     * an object that is not `JSONSerializable` a `JSONSerializationError` will
     * be thrown.
     *
     * - returns Data
     * - throws JSONSerializationError.notSerializable
     */
    func toJSONData() throws -> Data {
        var dictionary: [String: Any] = [:]

        try self.forEach { key, value in
            let keyString = String(describing: key)
            dictionary[keyString] = try value.toJSONSerializable()
        }

        return try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions())
    }
}

/**
 * Because of the lack of conditional generics (`extension Array: JSONSerializable where Element: JSONSerializable`)
 * this array can be used to restrict elements to be JSONSerializable.
 *
 * Usage:
 * ```
 * let array: JSONArray = ["test", 22, 5.6, true]
 * ```
 */
public struct JSONArray: JSONSerializable, ExpressibleByArrayLiteral {
    let array: [JSONSerializable]

    public init(array: [JSONSerializable]) {
        self.array = array
    }

    public init(arrayLiteral elements: JSONSerializable...) {
        var array: [JSONSerializable] = []

        for element in elements {
            array.append(element)
        }

        self.array = array
    }

    // MARK: JSONSerializable
    public func toJSONSerializable() throws -> Any {
        try self.array.toJSONSerializable()
    }

    /**
     * Returns an Data instance containing JSON data. When this array contains
     * an objects that is not `JSONSerializable` a `JSONSerializationError` will
     * be thrown.
     *
     * - returns Data
     * - throws JSONSerializationError.notSerializable
     */
    public func toJSONData() throws -> Data {
        try JSONSerialization.data(withJSONObject: try self.toJSONSerializable(), options: JSONSerialization.WritingOptions())
    }
}

/**
 * Because of the lack of conditional generics (`extension Dictionary: JSONSerializable where Key: StringLiteralConvertible, Value: JSONSerializable`)
 * this dictionary can be used to restrict elements to be JSONSerializable.
 *
 * Usage:
 * ```
 * let dict: JSONDictionary = ["test":"test", "number": 22, "float": 5.6, "bool": true]
 * ```
 */
public struct JSONDictionary: JSONSerializable, ExpressibleByDictionaryLiteral {
    let dictionary: [String: JSONSerializable]

    public init(dictionary: [String: JSONSerializable]) {
        self.dictionary = dictionary
    }

    public init(dictionaryLiteral elements: (String, JSONSerializable)...) {
        var dictionary: [String: JSONSerializable] = [:]
        for (key, value) in elements {
            dictionary[key] = value
        }

        self.dictionary = dictionary
    }

    // MARK: JSONSerializable
    public func toJSONSerializable() throws -> Any {
        try self.dictionary.toJSONSerializable()
    }

    /**
     * Returns an Data instance containing JSON data. When this array contains
     * an objects that is not `JSONSerializable` a `JSONSerializationError` will
     * be thrown.
     *
     * - returns Data
     * - throws JSONSerializationError.notSerializable
     */
    public func toJSONData() throws -> Data {
        try JSONSerialization.data(withJSONObject: try self.toJSONSerializable(), options: JSONSerialization.WritingOptions())
    }
}
