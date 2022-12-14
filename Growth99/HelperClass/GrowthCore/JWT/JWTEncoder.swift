import Foundation

public class JWTEncoder {

    /*** Encode a set of claims
     - parameter claims: The set of claims
     - parameter algorithm: The algorithm to sign the payload with
     - returns: The JSON web token as a String
     */
    public static func encode(claims: ClaimSet, algorithm: Algorithm, headers: [String: String]? = nil) -> String {
        let encoder = CompactJSONEncoder()

        var headers = headers ?? [:]
        if !headers.keys.contains("typ") {
            headers["typ"] = "JWT"
        }
        headers["alg"] = algorithm.description
        guard let header = try? encoder.encodeString(headers) else {
            return  "" }
        let payload = encoder.encodeString(claims.claims)!
        let signingInput = "\(header).\(payload)"
        let signature = base64encode(algorithm.algorithm.sign(signingInput.data(using: .utf8)!))
        return "\(signingInput).\(signature)"
    }

    /*** Encode a dictionary of claims
     - parameter claims: The dictionary of claims
     - parameter algorithm: The algorithm to sign the payload with
     - returns: The JSON web token as a String
     */
    public static func encode(claims: [String: Any], algorithm: Algorithm, headers: [String: String]? = nil) -> String {
        encode(claims: ClaimSet(claims: claims), algorithm: algorithm, headers: headers)
    }

    /// Encode a set of claims using the builder pattern
    public static func encode(_ algorithm: Algorithm, closure: ((ClaimSetBuilder) -> Void)) -> String {
        let builder = ClaimSetBuilder()
        closure(builder)
        return encode(claims: builder.claims, algorithm: algorithm)
    }

}
