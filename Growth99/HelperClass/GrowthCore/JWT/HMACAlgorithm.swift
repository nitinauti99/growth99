
import Foundation

public final class HMACAlgorithm: JWA {

    let key: Data
    let hash: Hash

    enum Hash {
        case sha256
        case sha384
        case sha512
    }

    init(key: Data, hash: Hash) {
        self.key = key
        self.hash = hash
    }

    init?(key: String, hash: Hash) {
        guard let key = key.data(using: .utf8) else { return nil }
        self.key = key
        self.hash = hash
    }

    public var name: String {
        switch hash {
        case .sha256:
            return "HS256"
        case .sha384:
            return "HS384"
        case .sha512:
            return "HS512"
        }
    }

}
