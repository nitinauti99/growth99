
import Foundation

internal class JSON {

    internal static func dataToJSONObject(_ data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        } catch {
            return nil
        }
    }

    internal static func JSONObjectFromString(_ string: String) -> Any? {
        guard let stringData = string.data(using: .utf8) else { return nil }
        return JSON.dataToJSONObject(stringData)
    }

    internal static func stringFromJSONObject(_ object: Any) -> String? {
        JSON.stringFromJSONObject(object, withOptions: [])
    }

    internal static func prettyStringFromJSONObject(_ object: Any) -> String? {
        JSON.stringFromJSONObject(object, withOptions: .prettyPrinted)
    }

    fileprivate static func stringFromJSONObject(_ object: Any, withOptions options: JSONSerialization.WritingOptions) -> String? {
        guard JSONSerialization.isValidJSONObject(object) else { return nil }

        do {
            let data = try JSONSerialization.data(withJSONObject: object, options: options)
            if let string = String(data: data, encoding: .utf8) {
                return string
            }
        } catch {}

        return nil
    }

    /// This function will take an array of keys and delete the keys and values completely.
    internal static func filterJSONKeys(_ keys: [String], object: Any) -> Any {
        if let dictionary = object as? [String: Any] {
            var filterDictionary = dictionary.filter { key, _ in !keys.contains(key) }
            _ = filterDictionary.map { key, value in
                filterDictionary[key] = self.filterJSONKeys(keys, object: value)
            }
            return filterDictionary
        } else if let array = object as? [Any] {
            return array.map { filterJSONKeys(keys, object: $0) }
        } else {
            return object
        }
    }

    /// This function will take an array of keys and replace their values with `redactedValue`
    internal static func redactJSONKeys(_ keys: [String], object: Any, redactedValue: String = "") -> Any {
        guard !keys.isEmpty else { return object }

        if let dictionary = object as? [String: Any] {
            var redactedDictionary: [String: Any] = [:]
            for (key, value) in dictionary {
                if keys.contains(key) {
                    redactedDictionary.updateValue(redactedValue, forKey: key)
                } else {
                    redactedDictionary.updateValue(self.redactJSONKeys(keys, object: value, redactedValue: redactedValue), forKey: key)
                }
            }
            return redactedDictionary
        } else if let array = object as? [Any] {
            return array.map { redactJSONKeys(keys, object: $0, redactedValue: redactedValue) }
        } else {
            return object
        }
    }

}
