
import Foundation

// https://www.ietf.org/rfc/rfc4514.txt
/// Struct use for identifying common DistinguishedName
struct ASN1DistinguishedName {

    let oid: String
    let representation: String

}

extension ASN1DistinguishedName {

    static let commonName = ASN1DistinguishedName(oid: "2.5.4.3", representation: "CN")
    static let dnQualifier = ASN1DistinguishedName(oid: "2.5.4.46", representation: "DNQ")
    static let serialNumber = ASN1DistinguishedName(oid: "2.5.4.5", representation: "SERIALNUMBER")
    static let givenName = ASN1DistinguishedName(oid: "2.5.4.42", representation: "GIVENNAME")
    static let surname = ASN1DistinguishedName(oid: "2.5.4.4", representation: "SURNAME")
    static let organizationalUnitName = ASN1DistinguishedName(oid: "2.5.4.11", representation: "OU")
    static let organizationName = ASN1DistinguishedName(oid: "2.5.4.10", representation: "O")
    static let streetAddress = ASN1DistinguishedName(oid: "2.5.4.9", representation: "STREET")
    static let localityName = ASN1DistinguishedName(oid: "2.5.4.7", representation: "L")
    static let stateOrProvinceName = ASN1DistinguishedName(oid: "2.5.4.8", representation: "ST")
    static let countryName = ASN1DistinguishedName(oid: "2.5.4.6", representation: "C")
    static let email = ASN1DistinguishedName(oid: "1.2.840.113549.1.9.1", representation: "E")

}
