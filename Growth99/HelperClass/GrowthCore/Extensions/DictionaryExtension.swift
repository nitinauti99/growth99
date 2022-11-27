

public extension Dictionary {
    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
        self.init()
        for (key, value) in sequence {
            self[key] = value
        }
    }

    /// Return value from nested dictionary when keyPath is represented
    /// similar to "key-value coding" in cocoa using dot notation
    subscript(keyPath keyPath: String) -> Any? {
        var keys = keyPath.components(separatedBy: ".")
        guard let firstKey = keys.first as? Key,
            let value = self[firstKey] else { return nil }

        keys.removeFirst()

        if !keys.isEmpty, let subDictionary = value as? [Key: Any] {
            let rejoinedKeyPath = keys.joined(separator: ".")

            return subDictionary[keyPath: rejoinedKeyPath]
        }

        return value
    }

    mutating func merge(withDictionary dictionary: [Key: Value]) {
        for (key, value) in dictionary {
            self.updateValue(value, forKey: key)
        }
    }

    func merged(withDictionary dictionary: [Key: Value]) -> Dictionary {
        var resultingDictionary = self
        resultingDictionary.merge(withDictionary: dictionary)

        return resultingDictionary
    }

    /// data.mapPairs { (k, v) in (k, v.characters.count) }
    func mapPairs<K: Hashable, V>(transform: (Element) throws -> (K, V)) rethrows -> [K: V] {
        [K: V](try map(transform))
    }

    /// data.filterPairs { (k, v) in k != "badKey" }
    func filterPairs(includeElement: (Element) throws -> Bool) rethrows -> [Key: Value] {
        Dictionary(try filter(includeElement))
    }

 }

