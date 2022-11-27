import Foundation

/// Represents a JSON Web Algorithm (JWA)
/// https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40
public protocol JWA: AnyObject {
    var name: String { get }
}

// MARK: Signing

/// Represents a JSON Web Algorithm (JWA) that is capable of signing
public protocol SignAlgorithm: JWA {
    func sign(_ message: Data) -> Data
}

// MARK: Verifying

/// Represents a JSON Web Algorithm (JWA) that is capable of verifying
public protocol VerifyAlgorithm: JWA {
    func verify(_ message: Data, signature: Data) -> Bool
}

public extension SignAlgorithm {

    /// Verify a signature for a message using the algorithm
    func verify(_ message: Data, signature: Data) -> Bool {
        sign(message) == signature
    }
}
