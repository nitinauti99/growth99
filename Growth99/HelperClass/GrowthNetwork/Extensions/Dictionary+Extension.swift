
import Foundation

extension Dictionary where Value: Equatable {
  /// Returns all keys mapped to the specified value.
  /// ```
  /// let dict = ["A": 1, "B": 2, "C": 3]
  /// let keys = dict.keysForValue(2)
  /// assert(keys == ["B"])
  /// assert(dict["B"] == 2)
  /// ```
    func keysForValue(value: Value) -> [Key] {
        compactMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }

}

extension Dictionary where Value: Any {

    static func != (left: [Key: Value], right: [Key: Value]) -> Bool {
        !(left == right)
    }

    static func == (left: [Key: Value], right: [Key: Value]) -> Bool {
        if left.count != right.count { return false }
        for element in left {
            guard let rightValue = right[element.key],
                isEqual(rightValue, element.value) else { return false }
        }

        return true
    }

}
