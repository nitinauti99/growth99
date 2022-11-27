import Foundation

public final class NoneAlgorithm: JWA, SignAlgorithm, VerifyAlgorithm {

    public var name: String {
        "none"
    }

    public init() {}

    public func sign(_ message: Data) -> Data {
        Data()
    }

}
