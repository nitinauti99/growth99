
import Foundation

public extension String {

    subscript(_ offsetIndex: Int) -> String {
        let idx1 = index(startIndex, offsetBy: offsetIndex)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }

    subscript (range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }

    subscript (range: CountableClosedRange<Int>) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(startIndex, offsetBy: range.upperBound - range.lowerBound)
        return String(self[startIndex...endIndex])
    }

    var isAlphanumeric: Bool {
        self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && !self.isEmpty
    }

    var isNumeric: Bool {
        range(of: "(^-?[\\d]+$)|(-?[\\d]+[.,]{1}[\\d]+$)",
              options: String.CompareOptions.regularExpression,
              range: nil,
              locale: nil) != nil
    }

    static var blank: String {
        return ""
    }

    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }

        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }

    func indexInt(of char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
}


extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Date {

    func toString(withFormat format: String = "dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
}
