
import Foundation

enum TLSCertificateBlockPosition: Int {
    case version = 0
    case serialNumber = 1
    case signatureAlgorithm = 2
    case issuer = 3
    case date = 4
    case subject = 5
    case publicKey = 6
    case extensions = 7
}
