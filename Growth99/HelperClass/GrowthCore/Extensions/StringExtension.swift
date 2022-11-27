
import Foundation

public extension String {

    var lines: [String] {
        self.components(separatedBy: CharacterSet.newlines)
    }

    var words: [String] {
        var words: [String] = []

        self.enumerate(.byWords) { words.append($0) }

        return words
    }

    func trimHexPrefix() -> String {
        self.trim(prefix: "0x")
    }

    func trim(prefix: String) -> String {
        hasPrefix(prefix) ? String(self.dropFirst(prefix.count)) : self
    }

    func trim(_ characterSet: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        self.trimmingCharacters(in: characterSet)
    }

    func enumerate(_ kind: NSString.EnumerationOptions, block: @escaping (String) -> Void) {
        let range = self.startIndex ..< self.endIndex
        self.enumerateSubstrings(in: range, options: kind) { substring, _, _, _ in
            if let substring = substring {
                block(substring)
            }
        }
    }

    func numberOfOccurencesOfSubstring(_ substring: String) -> Int {

        var count = 0
        var searchRange: Range<String.Index>?

        while let foundRange = range(of: substring, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }

        return count
    }

    mutating func dropFirstWhile(_ condition: (Character) -> Bool) -> Int {
        var count = 0

        while true {
            guard let character = self.first else {
                self = ""
                break
            }

            if condition(character) == false {
                break
            }

            self = String(self.dropFirst())
            count += 1
        }

        return count
    }

    mutating func dropLastWhile(_ condition: (Character) -> Bool) -> Int {
        var count = 0
        while true {
            guard let character = self.last else {
                self = ""
                break
            }

            if condition(character) == false {
                break
            }

            self = String(self.dropLast())
            count += 1
        }

        return count
    }

    func filtered(_ predicate: (Character) -> Bool) -> String {
        var string = ""
        for character in self where predicate(character) {
                string.append(character)
        }

        return string
    }

    func allCharactersMatch(_ range: ClosedRange<String>) -> Bool {
        for character in self where range.contains(String(character)) == false {
            return false
        }
        return true
    }

    var slice: ArraySlice<Character> {
        ArraySlice(self)
    }
}

public extension String {

    init(data: DispatchData) throws {
        self = ""
        data.apply { _, data -> Bool in
            if let substring = String(bytes: data, encoding: String.Encoding.ascii) {
                self += substring
            }

            return true
        }
    }

    var data: DispatchData? {
        let encoding = String.Encoding.utf8
        if let stringData = self.data(using: encoding) {
            return stringData.withUnsafeBytes { bufferPointer in
                DispatchData(bytes: bufferPointer)
            }
        }

        return nil
    }
}

public extension String {
    func applySubstitutions(_ substitutions: [String: String]) -> String {
        var substitutedString = self

        for (key, value) in substitutions {
            assert(!key.isEmpty, "Expecting non-empty key for string '\(self)' with substitutions '\(substitutions)'")
            substitutedString = substitutedString.replacingOccurrences(of: "{\(key)}", with: value)
        }

        return substitutedString
    }
}
