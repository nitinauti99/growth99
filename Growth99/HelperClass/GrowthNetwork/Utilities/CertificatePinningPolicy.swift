//
//  CertificatePinningPolicy.swift
//  FargoNetwork
//
//  Created by Arun on 9/24/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

/// Different pinning techniques supported by FargoHTTPNetwork
public enum PinningType: Equatable {

    /// Compare the local certificate against the server certificate (byte by byte)
    case certificate
    /// Compare subject sequence specific tag of the local certificate against server certificate
    case certificateTag(SubjectOID)
    /// Compare public key of both local and server certificate
    case publicKey

}

/// Protocol to look for resources of specific types in directory
public protocol BundleProtocol {

    /**
        Returns an array containing the pathNames for all bundle resources having the specified filename extension and residing in the resource subdirectory.
       
        - Parameters:
           - ext: The filename extension of the files to locate.
           If you specify an empty string or nil, the extension is assumed not to exist and all of the files in subpath are returned.
           - subpath: The name of the bundle subdirectory to search.
     
        - Returns: An array containing the full pathnames for all bundle resources matching the specified criteria. This method returns an empty array if no matching resource files are found.
    */
    func paths(forResourcesOfType ext: String?, inDirectory subpath: String?) -> [String]
}

extension Bundle: BundleProtocol {}

/// Handle server trust evaluation
protocol TrustEvaluating {

    func evaluateTrust() -> Result<Bool, Error>

}

/// Type to handle certificate pinning policy
public struct PinningPolicy {

    private let bundle: BundleProtocol
    private(set) var type: PinningType

    public init(bundle: BundleProtocol, type: PinningType) {
        self.bundle = bundle
        self.type = type
    }

    /// Private struct containing constants
    private struct Constants {
        static let certificateExtensions = [".cer", ".CER", ".der", ".DER"]
    }

    /**
     To update pinning policy
     
    - Parameters:
        - to: new pinning type to be updated to
     */
    public mutating func updatePinningPolicy(to pinningType: PinningType) {
        self.type = pinningType
    }

    /**
    Returns an array of certificate paths based on the bundle provided in the protocol.
     
    */
    func certificatePaths(in bundle: BundleProtocol) -> [String] {
        Array(Set(Constants.certificateExtensions.flatMap {
            bundle.paths(forResourcesOfType: $0, inDirectory: nil)
        }))
    }

    /**
    Returns an array of certificates data present in the bundle provided in the protocol.
    
    */
    func pinnedCertificates() -> [Data] {
        self.certificatePaths(in: self.bundle).compactMap {
            try? Data(contentsOf: URL(fileURLWithPath: $0))
        }
    }

    /**
     Returns whether the pinning has been succesful
     
     - Parameters:
        - serverTrust: secTrust data associated with server challenge
        - host: host associated with the auth challenge
     */
    func pin(with serverTrust: SecTrust, host: String) -> Result<Bool, Error> {
        let policy = SecPolicyCreateSSL(true, host as CFString)
        let status = SecTrustSetPolicies(serverTrust, policy)

        // Host validation
        guard status == errSecSuccess else {
            return .failure(FargoNetworkError.policyValidationFailed)
        }

        let pinnedCertificates = self.pinnedCertificates()
        if self.type == .certificate {
            let secPinnedCertificates = pinnedCertificates.map { SecCertificateCreateWithData(nil, $0 as CFData) }
            SecTrustSetAnchorCertificates(serverTrust, secPinnedCertificates as CFArray)
            SecTrustSetAnchorCertificatesOnly(serverTrust, true)
        }

        // Default evaluation
        var cfError: CFError?
        guard SecTrustEvaluateWithError(serverTrust, &cfError) else {
            if let cfError = cfError {
                return .failure(cfError)
            } else {
                return .failure(FargoNetworkError.pinningFailed)
            }
        }

        let serverCertificates = self.certificateData(for: serverTrust)

        switch self.type {
        case .certificate:
            let certPinningEvaluator = CertificatePinningEvaluator(serverCertificates: serverCertificates, localCertificates: pinnedCertificates)
            return certPinningEvaluator.evaluateTrust()
        case .certificateTag(let tag):
            let certPinningEvaluator = CertificatePinningEvaluator(serverCertificates: serverCertificates, localCertificates: pinnedCertificates, tag: tag)
            return certPinningEvaluator.evaluateTrust()
        case .publicKey:
            let keyPinningEvaluator = PublicKeyPinningEvaluator(serverCertificates: serverCertificates, localCertificates: pinnedCertificates)
            return keyPinningEvaluator.evaluateTrust()
        }
    }

    private func certificateData(for trust: SecTrust) -> [Data] {
        var certificates = Set<SecCertificate>()

        for index in 0..<SecTrustGetCertificateCount(trust) {
            if let certificate = SecTrustGetCertificateAtIndex(trust, index) {
                certificates.insert(certificate)
            }
        }

        return certificates.map { SecCertificateCopyData($0) as Data }
    }

}

/// Type to evaluate trust for complete certificate or a specific tag
struct CertificatePinningEvaluator: TrustEvaluating {

    private let serverCertificates: [Data]
    private let pinnedCertificates: [Data]
    private let tag: SubjectOID?

    init(serverCertificates: [Data],
         localCertificates: [Data],
         tag: SubjectOID? = nil) {
        self.serverCertificates = serverCertificates
        self.pinnedCertificates = localCertificates
        self.tag = tag
    }

    func evaluateTrust() -> Result<Bool, Error> {
        if let oid = self.tag {
            let serverCertificateOIDList = self.oidList(oid.rawValue, from: self.serverCertificates)
            let pinnedCertificateOIDList = self.oidList(oid.rawValue, from: self.pinnedCertificates)

            if Set(pinnedCertificateOIDList).isDisjoint(with: serverCertificateOIDList) {
                return .failure(FargoNetworkError.pinningFailed)
            } else {
               return .success(true)
            }
        } else {
            if Set(self.pinnedCertificates).isDisjoint(with: serverCertificates) {
                return .failure(FargoNetworkError.pinningFailed)
            } else {
                return .success(true)
            }
        }
    }

    private func oidList(_ oid: String, from certData: [Data]) -> [String] {
        guard !certData.isEmpty else { return [] }

        var result = [String]()
        for data in certData {
            if let oidValue = self.oidValue(oid, from: data) {
                result.append(oidValue)
            }
        }

        return result
    }

    private func oidValue(_ oid: String, from data: Data) -> String? {
        do {
            let tlsCertificate = try TLSCertificate(data: data)
            return tlsCertificate.subject(oid: oid)
        } catch {
            return nil
        }
    }

}

/// Type to evaluate trust for public keys
struct PublicKeyPinningEvaluator: TrustEvaluating {

    private let serverCertificates: [Data]
    private let pinnedCertificates: [Data]

    private var serverPublicKeys: [SecKey] {
        let secCertificateList = self.serverCertificates.compactMap { SecCertificateCreateWithData(nil, $0 as CFData) }

        return secCertificateList.compactMap { $0.publicKey }
    }

    private var pinnedPublicKeys: [SecKey] {
        let secCertificateList = self.pinnedCertificates.compactMap { SecCertificateCreateWithData(nil, $0 as CFData) }

        return secCertificateList.compactMap { $0.publicKey }
    }

    init(serverCertificates: [Data], localCertificates: [Data]) {
        self.serverCertificates = serverCertificates
        self.pinnedCertificates = localCertificates
    }

    func evaluateTrust() -> Result<Bool, Error> {
        for serverPublicKey in self.serverPublicKeys {
            for pinnedPublicKey in self.pinnedPublicKeys where serverPublicKey == pinnedPublicKey {
                return .success(true)
            }
        }

        return .failure(FargoNetworkError.pinningFailed)
    }

}
