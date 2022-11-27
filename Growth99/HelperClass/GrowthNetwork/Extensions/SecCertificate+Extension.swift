
import Foundation

extension SecCertificate {

    var publicKey: SecKey? {
        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let trustCreationStatus = SecTrustCreateWithCertificates(self, policy, &trust)

        guard let createdTrust = trust, trustCreationStatus == errSecSuccess else { return nil }

        if #available(iOS 14.0, macOS 11.0, *) {
            return SecTrustCopyKey(createdTrust)
        } else {
            return SecTrustCopyPublicKey(createdTrust)
        }
    }

}
