#if canImport(UserNotificationsUI)
import UserNotificationsUI

extension UNNotificationContentExtensionMediaPlayPauseButtonType: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .default:
            return "UNNotificationContentExtensionMediaPlayPauseButtonType.default"
        case .none:
            return "UNNotificationContentExtensionMediaPlayPauseButtonType.none"
        case .overlay:
            return "UNNotificationContentExtensionMediaPlayPauseButtonType.overlay"
        @unknown default:
            return "UNNotificationContentExtensionMediaPlayPauseButtonType.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}

extension UNNotificationContentExtensionResponseOption: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .dismiss:
            return "UNNotificationContentExtensionResponseOption.dismiss"
        case .dismissAndForwardAction:
            return "UNNotificationContentExtensionResponseOption.dismissAndForwardAction"
        case .doNotDismiss:
            return "UNNotificationContentExtensionResponseOption.doNotDismiss"
        @unknown default:
            return "UNNotificationContentExtensionResponseOption.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}
#endif
