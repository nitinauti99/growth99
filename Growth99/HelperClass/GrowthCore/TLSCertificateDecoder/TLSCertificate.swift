
import Foundation

/// Type depicting X509 Certificate
public class TLSCertificate {

    private struct Constants {
        static let beginPemBlock = "-----BEGIN CERTIFICATE-----"
        static let endPemBlock   = "-----END CERTIFICATE-----"
    }

    private let der: [DERObject]
    private let derBlock: DERObject

    /**
     Convenience initializer for both PEM and DER data
     
     - Parameters
     - data: X509 certificate data
     */
    public convenience init(data: Data) throws {
        if String(data: data, encoding: .utf8)?.contains(Constants.beginPemBlock) ?? false {
            try self.init(pem: data)
        } else {
            try self.init(der: data)
        }
    }

    /**
     Convenience initializer
     
     - Parameters
     - data: pem data
     */
    public convenience init(pem: Data) throws {
        guard let derData = TLSCertificate.decodeToDER(pem: pem) else {
            throw DERError.parseError
        }

        try self.init(der: derData)
    }

    /**
     Designated initializer
     
     - Parameters
     - data: X509 certificate data
     */
    public init(der: Data) throws {
        let decoder = TLSCertificateDecoder()
        self.der = try decoder.decode(data: der)
        guard !self.der.isEmpty,
            let derBlock = self.der.first?.child(at: 0) else {
                throw DERError.parseError
        }

        self.derBlock = derBlock
    }

    /// To verify the validity of the certificate
    public var isValid: Bool {
        let date = Date()
        if let notBefore = self.notBefore, let notAfter = self.notAfter {
            return date > notBefore && date < notAfter
        }

        return false
    }

    /// Gets the version (version number) value from the certificate.
    public var version: Int? {
        if let value = self.firstChildValue(der: derBlock) as? Data, let index = value.toInt() {
            return Int(index) + 1
        }

        return nil
    }

    /// Returns serialNumber value from the certificate.
    public var serialNumber: Data? {
        self.derBlock[TLSCertificateBlockPosition.serialNumber]?.value as? Data
    }

    /// Returns notBefore date from the validity period of the certificate.
    public var notBefore: Date? {
        self.derBlock[TLSCertificateBlockPosition.date]?.child(at: 0)?.value as? Date
    }

    /// Returns notAfter date from the validity period of the certificate.
    public var notAfter: Date? {
        self.derBlock[TLSCertificateBlockPosition.date]?.child(at: 1)?.value as? Date
    }

    /// Returns signature value (the raw signature bits) from the certificate.
    public var signature: Data? {
        self.der[0].child(at: 2)?.value as? Data
    }

    /// Returns signature algorithm name for the certificate signature algorithm.
    public var sigAlgName: String? {
        algoIds[sigAlgOID ?? String.blank]
    }

    /// Returns signature algorithm OID string from the certificate.
    public var sigAlgOID: String? {
        self.derBlock.child(at: 2)?.child(at: 0)?.value as? String
    }

    /// Returns organizationalUnitName string from the certificate.
    public var organizationalUnitName: String? {
        self.subject(oid: OID.organizationalUnitName.rawValue)
    }

    /// Returns organizationalName string from the certificate.
    public var organizationName: String? {
        self.subject(oid: OID.organizationName.rawValue)
    }

    /// Returns commonName string from the certificate.
    public var commonName: String? {
        self.subject(oid: OID.commonName.rawValue)
    }

    /// Returns information of the public key from this certificate.
    public var publicKey: TLSPublicKey? {
        self.derBlock[TLSCertificateBlockPosition.publicKey].map(TLSPublicKey.init)
    }

    /// Returns the issuer (issuer distinguished name) value from the certificate as a String.
    public var issuerDistinguishedName: String? {
        if let issuerBlock = self.derBlock[TLSCertificateBlockPosition.issuer] {
            return blockDistinguishedName(block: issuerBlock)
        }

        return nil
    }

    /// Returns issuer information
    public var issuerOIDs: [String] {
        var result: [String] = []
        if let subjectBlock = self.derBlock[TLSCertificateBlockPosition.issuer] {
            for children in subjectBlock.children ?? [] {
                if let value = self.firstChildValue(der: children) as? String {
                    result.append(value)
                }
            }
        }

        return result
    }

    /// Returns the subject (subject distinguished name) value from the certificate as a String.
    public var subjectDistinguishedName: String? {
        guard let subjectBlock = self.derBlock[TLSCertificateBlockPosition.subject] else { return nil }

        return blockDistinguishedName(block: subjectBlock)
    }

    /**
     Gets a boolean array representing bits of the KeyUsage extension, (OID = 2.5.29.15).
     ```
     KeyUsage ::= BIT STRING {
     digitalSignature        (0),
     nonRepudiation          (1),
     keyEncipherment         (2),
     dataEncipherment        (3),
     keyAgreement            (4),
     keyCertSign             (5),
     cRLSign                 (6),
     encipherOnly            (7),
     decipherOnly            (8)
     }
     ```
     */
    public var keyUsage: [Bool] {
        var result: [Bool] = []
        if let oidBlock = self.derBlock.locateOID(OID.keyUsage) {
            let data = oidBlock.parent?.children?.last?.child(at: 0)?.value as? Data
            let bits: UInt8 = data?.first ?? 0
            for index in 0...7 {
                let value = bits & UInt8(1 << index) != 0
                result.insert(value, at: 0)
            }
        }
        return result
    }

    /// Returns specific issuer information based on the OID
    public func issuer(oid: String) -> String? {
        if let subjectBlock = self.derBlock[TLSCertificateBlockPosition.issuer] {
            if let oidBlock = subjectBlock.locateOID(oid) {
                return oidBlock.parent?.children?.last?.value as? String
            }
        }

        return nil
    }

    /// Returns specific subject information based on the OID
    public func subject(oid: String) -> String? {
        if let subjectBlock = self.derBlock[TLSCertificateBlockPosition.subject] {
            if let oidBlock = subjectBlock.locateOID(oid) {
                return oidBlock.parent?.children?.last?.value as? String
            }
        }

        return nil
    }

    // MARK: Private functions
    // Format subject/issuer information in RFC1779
    private func blockDistinguishedName(block: DERObject) -> String {
        var result = ""
        let oidNames: [ASN1DistinguishedName] = [
            .commonName,
            .dnQualifier,
            .serialNumber,
            .givenName,
            .surname,
            .organizationalUnitName,
            .organizationName,
            .streetAddress,
            .localityName,
            .stateOrProvinceName,
            .countryName,
            .email
        ]
        for oidName in oidNames {
            if let oidBlock = block.locateOID(oidName.oid) {
                if !result.isEmpty {
                    result.append(", ")
                }
                result.append(oidName.representation)
                result.append("=")
                if let value = oidBlock.parent?.children?.last?.value as? String {
                    let specialChar = ",+=\n<>#;\\"
                    let quote = value.contains(where: { specialChar.contains($0) }) ? "\"" : ""
                    result.append(quote)
                    result.append(value)
                    result.append(quote)
                }
            }
        }

        return result
    }

    /// Read possibile PEM encoding
    private static func decodeToDER(pem pemData: Data) -> Data? {
        if let pem = String(data: pemData, encoding: .ascii), pem.contains(Constants.beginPemBlock) {
            let lines = pem.components(separatedBy: .newlines)
            var base64buffer = ""
            var certLine = false
            for line in lines {
                if line == Constants.endPemBlock {
                    certLine = false
                }
                if certLine {
                    base64buffer.append(line)
                }
                if line == Constants.beginPemBlock {
                    certLine = true
                }
            }

            if let derDataDecoded = Data(base64Encoded: base64buffer) {
                return derDataDecoded
            }
        }

        return nil
    }

    private func firstChildValue(der: DERObject) -> Any? {
        if let children = der.children?.first {
            return self.firstChildValue(der: children)
        }

        return der.value
    }

}
