#if canImport(CoreLocation)
import CoreLocation

#if compiler(>=5.4)
extension CLAccuracyAuthorization: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .fullAccuracy:
            return "CLAccuracyAuthorization.fullAccuracy"
        case .reducedAccuracy:
            return "CLAccuracyAuthorization.reducedAccuracy"
        @unknown default:
            return "CLAccuracyAuthorization.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}
#endif

extension CLActivityType: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .airborne:
            return "CLActivityType.airborne"
        case .automotiveNavigation:
            return "CLActivityType.automotiveNavigation"
        case .other:
            return "CLActivityType.other"
        case .fitness:
            return "CLActivityType.fitness"
        case .otherNavigation:
            return "CLActivityType.otherNavigation"
        @unknown default:
            return "CLActivityType.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}

extension CLAuthorizationStatus: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .authorizedAlways:
            return "CLAuthorizationStatus.authorizedAlways"
        case .authorizedWhenInUse:
            return "CLAuthorizationStatus.authorizedWhenInUse"
        case .denied:
            return "CLAuthorizationStatus.denied"
        case .notDetermined:
            return "CLAuthorizationStatus.notDetermined"
        case .restricted:
            return "CLAuthorizationStatus.restricted"
        @unknown default:
            return "CLAuthorizationStatus.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}

extension CLDeviceOrientation: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .faceUp:
            return "CLDeviceOrientation.faceUp"
        case .faceDown:
            return "CLDeviceOrientation.faceDown"
        case .landscapeLeft:
            return "CLDeviceOrientation.landscapeLeft"
        case .landscapeRight:
            return "CLDeviceOrientation.landscapeRight"
        case .portrait:
            return "CLDeviceOrientation.portrait"
        case .portraitUpsideDown:
            return "CLDeviceOrientation.portraitUpsideDown"
        case .unknown:
            return "CLDeviceOrientation.unknown"
        @unknown default:
            return "CLDeviceOrientation.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}

#if compiler(>=5.3)
extension CLProximity: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .far:
            return "CLProximity.far"
        case .immediate:
            return "CLProximity.immediate"
        case .near:
            return "CLProximity.near"
        case .unknown:
            return "CLProximity.unknown"
        @unknown default:
            return "CLProximity.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}
#endif

extension CLRegionState: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .inside:
            return "CLRegionState.inside"
        case .outside:
            return "CLRegionState.outside"
        case .unknown:
            return "CLRegionState.unknown"
        }
    }
}
#endif
