import Foundation

public class CompactJSONEncoder: JSONEncoder {

    override public func encode<T: Encodable>(_ value: T) throws -> Data {
        try encodeString(value).data(using: .ascii) ?? Data()
    }

    func encodeString<T: Encodable>(_ value: T) throws -> String {
        base64encode(try super.encode(value))
    }

    func encodeString(_ value: [String: Any]) -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: value) {
            return base64encode(data)
        }

        return nil
    }

}
