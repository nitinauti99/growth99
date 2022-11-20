
import Foundation

func parseTimeInterval(_ value: Any?) -> Date? {
    guard let value = value else { return nil }

    if let string = value as? String, let interval = TimeInterval(string) {
        return Date(timeIntervalSince1970: interval)
    }

    if let interval = value as? TimeInterval {
        return Date(timeIntervalSince1970: interval)
    }

    return nil
}

public struct ClaimSet {
    public var claims: [String: Any]

    public init(claims: [String: Any]? = nil) {
        self.claims = claims ?? [:]
    }

    public subscript(key: String) -> Any? {
        get {
            claims[key]
        }

        set {
            if let newValue = newValue, let date = newValue as? Date {
                claims[key] = date.timeIntervalSince1970
            } else {
                claims[key] = newValue
            }
        }
    }
}

// MARK: Accessors

public extension ClaimSet {
    var issuer: String? {
        get {
            claims["iss"] as? String
        }

        set {
            claims["iss"] = newValue
        }
    }

    var audience: String? {
        get {
            claims["aud"] as? String
        }

        set {
            claims["aud"] = newValue
        }
    }

    var expiration: Date? {
        get {
            parseTimeInterval(claims["exp"])
        }

        set {
            self["exp"] = newValue
        }
    }

    var notBefore: Date? {
        get {
            parseTimeInterval(claims["nbf"])
        }

        set {
            self["nbf"] = newValue
        }
    }

    var issuedAt: Date? {
        get {
            parseTimeInterval(claims["iat"])
        }

        set {
            self["iat"] = newValue
        }
    }
}

// MARK: Validations

public extension ClaimSet {
    func validate(audience: String? = nil, issuer: String? = nil, leeway: TimeInterval = 0) throws {
        if let issuer = issuer {
            try validateIssuer(issuer)
        }

        if let audience = audience {
            try validateAudience(audience)
        }

        try validateExpiary(leeway: leeway)
        try validateNotBefore(leeway: leeway)
        try validateIssuedAt(leeway: leeway)
    }

    func validateAudience(_ audience: String) throws {
        if let aud = self["aud"] as? [String] {
            if !aud.contains(audience) {
                throw InvalidToken.invalidAudience
            }
        } else if let aud = self["aud"] as? String {
            if aud != audience {
                throw InvalidToken.invalidAudience
            }
        } else {
            throw InvalidToken.decodeError("Invalid audience claim, must be a string or an array of strings")
        }
    }

    func validateIssuer(_ issuer: String) throws {
        if let iss = self["iss"] as? String {
            if iss != issuer {
                throw InvalidToken.invalidIssuer
            }
        } else {
            throw InvalidToken.invalidIssuer
        }
    }

    func validateExpiary(leeway: TimeInterval = 0) throws {
        try validateDate(claims, key: "exp", comparison: .orderedAscending, leeway: (-1 * leeway), failure: .expiredSignature, decodeError: "Expiration time claim (exp) must be an integer")
    }

    func validateNotBefore(leeway: TimeInterval = 0) throws {
        try validateDate(claims, key: "nbf", comparison: .orderedDescending, leeway: leeway, failure: .immatureSignature, decodeError: "Not before claim (nbf) must be an integer")
    }

    func validateIssuedAt(leeway: TimeInterval = 0) throws {
        try validateDate(claims, key: "iat", comparison: .orderedDescending, leeway: leeway, failure: .invalidIssuedAt, decodeError: "Issued at claim (iat) must be an integer")
    }
}

// MARK: Builder

public class ClaimSetBuilder {
    var claims = ClaimSet()

    public var issuer: String? {
        get {
            claims.issuer
        }

        set {
            claims.issuer = newValue
        }
    }

    public var audience: String? {
        get {
            claims.audience
        }

        set {
            claims.audience = newValue
        }
    }

    public var expiration: Date? {
        get {
            claims.expiration
        }

        set {
            claims.expiration = newValue
        }
    }

    public var notBefore: Date? {
        get {
            claims.notBefore
        }

        set {
            claims.notBefore = newValue
        }
    }

    public var issuedAt: Date? {
        get {
            claims.issuedAt
        }

        set {
            claims.issuedAt = newValue
        }
    }

    public subscript(key: String) -> Any? {
        get {
            claims[key]
        }

        set {
            claims[key] = newValue
        }
    }
}

typealias PayloadBuilder = ClaimSetBuilder
