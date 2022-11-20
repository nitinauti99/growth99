
import Foundation

extension Data {

    @discardableResult
    mutating func append<T>(values: [T]) -> Bool {
        var data = Data()
        var status = true

        if T.self == String.self {
            for value in values {
                guard let convertedString = (value as? String)!.data(using: .utf8) else { status = false; break }
                data.append(convertedString)
            }
        } else if T.self == Data.self {
            for value in values {
                data.append((value as? Data)!)
            }
        } else {
            status = false
        }

        if status {
            self.append(data)
        }

        return status
    }

    func toInt() -> UInt64? {
        guard self.count <= 8 else { return nil }
        var result = UInt64(0)

        for tuple in self.reversed().enumerated() {
            result += UInt64(tuple.element) << (UInt64(tuple.offset) * 8)
        }

        return UInt64(Int(result))
    }

    func toHexString() -> String {
        self.map { String(format: "%02X", $0) }.joined()
    }

}
