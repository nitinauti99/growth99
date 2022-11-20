import CommonCrypto
import Foundation

public extension Data {

    func hmac(key: Data, algorithm: HMAC.Algorithm) -> Data {
        HMAC.sign(data: self, algorithm: algorithm, key: key)
    }

    var hex: String {
        map { String(format: "%02x", $0) }.reduce("", +)
    }

}
