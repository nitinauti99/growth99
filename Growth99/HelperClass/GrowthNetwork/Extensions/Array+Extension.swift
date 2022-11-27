
import Foundation

func isEqual(_ left: Any, _ right: Any) -> Bool {
    if type(of: left) == type(of: right) && String(describing: left) == String(describing: right) { return true }
    if let left = left as? [Any], let right = right as? [Any] { return left == right }
    if let left = left as? [AnyHashable: Any], let right = right as? [AnyHashable: Any] { return left == right }

    return false
}

extension Array where Element: Any {

    static func != (left: [Element], right: [Element]) -> Bool {
        !(left == right)
    }

    static func == (left: [Element], right: [Element]) -> Bool {
        if left.count != right.count { return false }
        var right = right
        loop: for leftValue in left {
            for (rightIndex, rightValue) in right.enumerated() where isEqual(leftValue, rightValue) {
                right.remove(at: rightIndex)
                continue loop
            }

            return false
        }

        return true
    }

}
