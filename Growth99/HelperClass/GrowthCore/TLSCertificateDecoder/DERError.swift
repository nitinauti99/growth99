
import Foundation

enum DERError: LocalizedError {

    case badOID
    case parseError
    case outOfBuffer

    var errorDescription: String? {
        switch self {
        case .badOID:
            return "Object identifier doesn't exist"
        case .parseError:
            return "Unable to parse data"
        case .outOfBuffer:
            return "No buffer space available"
        }
    }

}
