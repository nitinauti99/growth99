#if canImport(UserNotifications)
import UserNotifications

extension UNAlertStyle: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .alert:
            return "UNAlertStyle.alert"
        case .banner:
            return "UNAlertStyle.banner"
        case .none:
            return "UNAlertStyle.none"
        @unknown default:
            return "UNAlertStyle.(@unknown default, rawValue: /Users/kjogi/Github/Learning/swift-custom-dump/Sources/CustomDump/Conformances/SwiftUI.swift\(self.rawValue))"
        }
    }
}

@available(iOS 13, macOS 10.14, *)
extension UNAuthorizationOptions: FargoDumpReflectable {
    public var fargoDumpMirror: Mirror {
        struct Option: FargoDumpStringConvertible {
            var rawValue: UNAuthorizationOptions

            var fargoDumpDescription: String {
                switch self.rawValue {
                case .alert:
                    return "UNAuthorizationOptions.alert"
                #if os(iOS)
                case .announcement:
                    return "UNAuthorizationOptions.announcement"
                #endif
                case .badge:
                    return "UNAuthorizationOptions.badge"
                case .criticalAlert:
                    return "UNAuthorizationOptions.criticalAlert"
                case .providesAppNotificationSettings:
                    return "UNAuthorizationOptions.providesAppNotificationSettings"
                case .provisional:
                    return "UNAuthorizationOptions.provisional"
                case .sound:
                    return "UNAuthorizationOptions.sound"
                default:
                    return "UNAuthorizationOptions(rawValue: \(self.rawValue))"
                }
            }
        }

        var options = self
        var children: [Option] = []
        var allCases: [UNAuthorizationOptions] = [
            .alert
        ]
        #if os(iOS)
        allCases.append(.announcement)
        #endif
        allCases.append(contentsOf: [
            .badge,
            .carPlay,
            .criticalAlert,
            .providesAppNotificationSettings,
            .provisional,
            .sound
        ])
        for option in allCases where options.contains(option) {
            children.append(.init(rawValue: option))
            options.subtract(option)
        }
        if !options.isEmpty {
            children.append(.init(rawValue: options))
        }

        return .init(
            self,
            unlabeledChildren: children,
            displayStyle: .set
        )
    }
}

extension UNAuthorizationStatus: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .authorized:
            return "UNAuthorizationStatus.authorized"
        case .denied:
            return "UNAuthorizationStatus.denied"
        case .ephemeral:
            return "UNAuthorizationStatus.ephemeral"
        case .notDetermined:
            return "UNAuthorizationStatus.notDetermined"
        case .provisional:
            return "UNAuthorizationStatus.provisional"
        @unknown default:
            return "UNAuthorizationStatus.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}

#if compiler(>=5.5)
@available(iOS 15, macOS 12, *)
extension UNNotificationInterruptionLevel: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .active:
            return "UNNotificationInterruptionLevel.active"
        case .critical:
            return "UNNotificationInterruptionLevel.critical"
        case .passive:
            return "UNNotificationInterruptionLevel.passive"
        case .timeSensitive:
            return "UNNotificationInterruptionLevel.timeSensitive"
        @unknown default:
            return "UNNotificationInterruptionLevel.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}
#endif

extension UNNotificationPresentationOptions: FargoDumpReflectable {
    public var fargoDumpMirror: Mirror {
        struct Option: FargoDumpStringConvertible {
            var rawValue: UNNotificationPresentationOptions
            var fargoDumpDescription: String {
                if self.rawValue == .badge {
                    return "UNNotificationPresentationOptions.badge"
                } else if #available(iOS 14, macOS 11, *), self.rawValue == .banner {
                    return "UNNotificationPresentationOptions.banner"
                } else if #available(iOS 14, macOS 11, *), self.rawValue == .list {
                    return "UNNotificationPresentationOptions.list"
                } else if self.rawValue == .sound {
                    return "UNNotificationPresentationOptions.sound"
                } else {
                    return "UNNotificationPresentationOptions(rawValue: \(self.rawValue))"
                }
            }
        }

        var options = self
        var children: [Option] = []
        var allCases: [UNNotificationPresentationOptions] = [
            .badge
        ]
        if #available(iOS 14, macOS 11, *) {
            allCases.append(contentsOf: [.banner, .list])
        }
        allCases.append(.sound)
        for option in allCases where options.contains(option) {
            children.append(.init(rawValue: option))
            options.subtract(option)
        }
        if !options.isEmpty {
            children.append(.init(rawValue: options))
        }

        return .init(
            self,
            unlabeledChildren: children,
            displayStyle: .set
        )
    }
}

extension UNNotificationSetting: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .disabled:
            return "UNNotificationSetting.disabled"
        case .enabled:
            return "UNNotificationSetting.enabled"
        case .notSupported:
            return "UNNotificationSetting.notSupported"
        @unknown default:
            return "UNNotificationSetting.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}

extension UNShowPreviewsSetting: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {
        case .always:
            return "UNShowPreviewsSetting.always"
        case .never:
            return "UNShowPreviewsSetting.never"
        case .whenAuthenticated:
            return "UNShowPreviewsSetting.whenAuthenticated"
        @unknown default:
            return "UNShowPreviewsSetting.(@unknown default, rawValue: \(self.rawValue))"
        }
    }
}
#endif
