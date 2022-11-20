#if canImport(CoreMotion)
import CoreMotion

extension CMAuthorizationStatus: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .authorized:
            return "CMAuthorizationStatus.authorized"
        case .denied:
            return "CMAuthorizationStatus.denied"
        case .notDetermined:
            return "CMAuthorizationStatus.notDetermined"
        case .restricted:
            return "CMAuthorizationStatus.restricted"
        @unknown default:
            return "CMAuthorizationStatus.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}

#if compiler(>=5.4)
extension CMDeviceMotion.SensorLocation: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .default:
            return "CMDeviceMotion.SensorLocation.default"
        case .headphoneLeft:
            return "CMDeviceMotion.SensorLocation.headphoneLeft"
        case .headphoneRight:
            return "CMDeviceMotion.SensorLocation.headphoneRight"
        @unknown default:
            return "CMDeviceMotion.SensorLocation.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}
#endif

extension CMMotionActivityConfidence: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .high:
            return "CMMotionActivityConfidence.high"
        case .low:
            return "CMMotionActivityConfidence.low"
        case .medium:
            return "CMMotionActivityConfidence.medium"
        @unknown default:
            return "CMMotionActivityConfidence.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}

extension CMPedometerEventType: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .pause:
            return "CMPedometerEventType.pause"
        case .resume:
            return "CMPedometerEventType.resume"
        @unknown default:
            return "CMPedometerEventType.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}
#endif
