//
//  OID.swift
//  FargoCore
//
//  Created by SopanSharma on 4/9/20.
//

import Foundation

// http://www.umich.edu/~x509/ssleay/asn1-oids.html
enum OID: String {

    case etsiQcsCompliance = "0.4.0.1862.1.1"
    case etsiQcsRetentionPeriod = "0.4.0.1862.1.3"
    case etsiQcsQcSSCD = "0.4.0.1862.1.4"
    case dsa = "1.2.840.10040.4.1"
    case ecPublicKey = "1.2.840.10045.2.1"
    case prime256v1 = "1.2.840.10045.3.1.7"
    case ecdsaWithSHA256 = "1.2.840.10045.4.3.2"
    case ecdsaWithSHA512 = "1.2.840.10045.4.3.4"
    case rsaEncryption = "1.2.840.113549.1.1.1"
    case sha256WithRSAEncryption = "1.2.840.113549.1.1.11"
    case md5WithRSAEncryption = "1.2.840.113549.1.1.4"
    case sha1WithRSAEncryption = "1.2.840.113549.1.1.5"
    case pkcs7data = "1.2.840.113549.1.7.1"
    case pkcs7signedData = "1.2.840.113549.1.7.2"
    case pkcs7envelopedData = "1.2.840.113549.1.7.3"
    case emailAddress = "1.2.840.113549.1.9.1"
    case signingCertificateV2 = "1.2.840.113549.1.9.16.2.47"
    case contentType = "1.2.840.113549.1.9.3"
    case messageDigest = "1.2.840.113549.1.9.4"
    case signingTime = "1.2.840.113549.1.9.5"
    case certificateExtension = "1.3.6.1.4.1.11129.2.4.2"
    case authorityInfoAccess = "1.3.6.1.5.5.7.1.1"
    case qcStatements = "1.3.6.1.5.5.7.1.3"
    case cps = "1.3.6.1.5.5.7.2.1"
    case serverAuth = "1.3.6.1.5.5.7.3.1"
    case clientAuth = "1.3.6.1.5.5.7.3.2"
    case ocsp = "1.3.6.1.5.5.7.48.1"
    case caIssuers = "1.3.6.1.5.5.7.48.2"
    case dateOfBirth = "1.3.6.1.5.5.7.9.1"
    case sha256 = "2.16.840.1.101.3.4.2.1"
    case veriSignEVpolicy = "2.16.840.1.113733.1.7.23.6"
    case extendedValidation = "2.23.140.1.1"
    case organizationValidated = "2.23.140.1.2.2"
    case subjectKeyIdentifier = "2.5.29.14"
    case keyUsage = "2.5.29.15"
    case subjectAltName = "2.5.29.17"
    case issuerAltName = "2.5.29.18"
    case basicConstraints = "2.5.29.19"
    case cRLDistributionPoints = "2.5.29.31"
    case certificatePolicies = "2.5.29.32"
    case authorityKeyIdentifier = "2.5.29.35"
    case organizationName = "2.5.4.10"
    case organizationalUnitName = "2.5.4.11"
    case businessCategory = "2.5.4.15"
    case commonName = "2.5.4.3"
    case surname = "2.5.4.4"
    case givenName = "2.5.4.42"
    case dnQualifier = "2.5.4.46"
    case serialNumber = "2.5.4.5"
    case countryName = "2.5.4.6"
    case localityName = "2.5.4.7"
    case stateOrProvinceName = "2.5.4.8"
    case streetAddress = "2.5.4.9"

}

public enum SubjectOID: String {

    case organizationName = "2.5.4.10"
    case organizationalUnitName = "2.5.4.11"
    case commonName = "2.5.4.3"
    case countryName = "2.5.4.6"
    case stateOrProvinceName = "2.5.4.8"

}

let algoIds = [
    "1.2.840.10045.3.1.7": "prime256v1",
    "1.2.840.10045.4.3.2": "ecdsaWithSHA256",
    "1.2.840.10045.4.3.4": "ecdsaWithSHA512",
    "1.2.840.113549.1.1.1": "rsaEncryption",
    "1.2.840.113549.1.1.4": "md5WithRSAEncryption",
    "1.2.840.113549.1.1.5": "sha1WithRSAEncryption",
    "1.2.840.113549.1.1.11": "sha256WithRSAEncryption"
]
