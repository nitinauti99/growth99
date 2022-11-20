#if canImport(Photos)
import Photos

@available(iOS 14, macOS 11, *)
extension PHAccessLevel: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .addOnly:
            return "PHAccessLevel.addOnly"
        case .readWrite:
            return "PHAccessLevel.readWrite"
        @unknown default:
            return "PHAccessLevel.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}

extension PHAuthorizationStatus: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .authorized:
            return "PHAuthorizationStatus.authorized"
        case .denied:
            return "PHAuthorizationStatus.denied"
        case .notDetermined:
            return "PHAuthorizationStatus.notDetermined"
        case .restricted:
            return "PHAuthorizationStatus.restricted"
        case .limited:
            return "PHAuthorizationStatus.limited"
        @unknown default:
            return "PHAuthorizationStatus.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}
#endif
