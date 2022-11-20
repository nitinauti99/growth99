
import Foundation

extension HMACAlgorithm: SignAlgorithm, VerifyAlgorithm {

    public func sign(_ message: Data) -> Data {
        HMAC.sign(data: message, algorithm: hash.cryptoSwiftVariant, key: key)
    }

}

extension HMACAlgorithm.Hash {

    var cryptoSwiftVariant: HMAC.Algorithm {
        switch self {
        case .sha256:
            return .sha256
        case .sha384:
            return .sha384
        case .sha512:
            return .sha512
        }
    }

}
