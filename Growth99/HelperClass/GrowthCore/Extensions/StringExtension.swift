
import Foundation

public extension String {

    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
            var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
            for index in 0 ..< pattern.count {
                guard index < pureNumber.count else { return pureNumber }
                let stringIndex = String.Index(utf16Offset: index, in: pattern)
                let patternCharacter = pattern[stringIndex]
                guard patternCharacter != replacementCharacter else { continue }
                pureNumber.insert(patternCharacter, at: stringIndex)
            }
            return pureNumber
        }
    
    
    
    func isValidMobile() -> Bool {
        let mobileRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        let result = mobileTest.evaluate(with: self)
        return result
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func validateUrl() -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: self)
        return result
    }
    
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

extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
