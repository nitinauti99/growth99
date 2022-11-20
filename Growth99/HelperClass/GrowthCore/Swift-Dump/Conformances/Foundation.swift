import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

#if compiler(>=5.5)
@available(iOS 15, macOS 12, *)
extension AttributedString: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        NSAttributedString(self).string
    }
}
#endif

extension Calendar: FargoDumpReflectable {
    public var fargoDumpMirror: Mirror {
        .init(
            self,
            children: [
                "identifier": self.identifier,
                "locale": self.locale as Any,
                "timeZone": self.timeZone,
                "firstWeekday": self.firstWeekday,
                "minimumDaysInFirstWeek": self.minimumDaysInFirstWeek
            ],
            displayStyle: .struct
        )
    }
}

extension Data: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        "Data(\(Self.formatter.string(fromByteCount: .init(self.count))))"
    }

    private static let formatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useBytes
        return formatter
    }()
}

extension Date: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        "Date(\(Self.formatter.string(from: self)))"
    }

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)!
        return formatter
    }()
}

extension Decimal: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        self.description
    }
}

extension Locale: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        "Locale(\(self.identifier))"
    }
}

extension NSAttributedString: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self.string
    }
}

extension NSCalendar: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as Calendar
    }
}

extension NSData: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as Data
    }
}

extension NSDate: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as Date
    }
}

extension NSError: FargoDumpReflectable {
    public var fargoDumpMirror: Mirror {
        .init(
            self,
            children: [
                "domain": self.domain,
                "code": self.code,
                "userInfo": self.userInfo
            ],
            displayStyle: .class
        )
    }
}

extension NSException: FargoDumpReflectable {
    public var fargoDumpMirror: Mirror {
        .init(
            self,
            children: [
                "name": self.name,
                "reason": self.reason as Any,
                "userInfo": self.userInfo as Any
            ],
            displayStyle: .class
        )
    }
}

extension NSExceptionName: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        self.rawValue
    }
}

extension NSExpression: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        self.debugDescription
    }
}

extension NSIndexPath: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as IndexPath
    }
}

extension NSIndexSet: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as IndexSet
    }
}

extension NSLocale: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as Locale
    }
}

extension NSMeasurement: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as Measurement
    }
}

extension NSNotification: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as Notification
    }
}

extension NSOrderedSet: FargoDumpReflectable {
    public var fargoDumpMirror: Mirror {
        .init(
            self,
            unlabeledChildren: self.array,
            displayStyle: .collection
        )
    }
}

extension NSPredicate: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        self.debugDescription
    }
}

extension NSRange: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        Range(self) as Any
    }
}

extension NSString: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as String
    }
}

extension NSTimeZone: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as TimeZone
    }
}

extension NSURL: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as URL
    }
}

extension NSURLComponents: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as URLComponents
    }
}

extension NSURLQueryItem: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as URLQueryItem
    }
}

extension NSURLRequest: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as URLRequest
    }
}

extension NSUUID: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        self as UUID
    }
}

extension NSValue: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        self.debugDescription
    }
}

extension TimeZone: FargoDumpReflectable {
    public var fargoDumpMirror: Mirror {
        .init(
            self,
            children: [
                "identifier": self.identifier,
                "abbreviation": self.abbreviation() as Any,
                "secondsFromGMT": self.secondsFromGMT(),
                "isDaylightSavingTime": self.isDaylightSavingTime()
            ],
            displayStyle: .struct
        )
    }
}

extension URL: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        "URL(\(self.absoluteString))"
    }
}

extension URLRequest.NetworkServiceType: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        switch self {#if canImport(FoundationNetworking)
        case .background:
            return "URLRequest.NetworkServiceType.background"
        case .default:
            return "URLRequest.NetworkServiceType.default"
        case .networkServiceTypeCallSignaling:
            return "URLRequest.NetworkServiceType.networkServiceTypeCallSignaling"
        case .video:
            return "URLRequest.NetworkServiceType.video"
        case .voice:
            return "URLRequest.NetworkServiceType.voice"
        case .voip:
            return "URLRequest.NetworkServiceType.voip"
#else
        case .avStreaming:
            return "URLRequest.NetworkServiceType.avStreaming"
        case .background:
            return "URLRequest.NetworkServiceType.background"
        case .callSignaling:
            return "URLRequest.NetworkServiceType.callSignaling"
        case .default:
            return "URLRequest.NetworkServiceType.default"
        case .responsiveAV:
            return "URLRequest.NetworkServiceType.responsiveAV"
        case .responsiveData:
            return "URLRequest.NetworkServiceType.responsiveData"
        case .video:
            return "URLRequest.NetworkServiceType.video"
        case .voice:
            return "URLRequest.NetworkServiceType.voice"
        case .voip:
            return "URLRequest.NetworkServiceType.voip"
        @unknown default:
            return "URLRequest.NetworkServiceType.(@unknown default, rawValue: \(self.rawValue))"
#endif
        }
    }
}

extension UUID: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        "UUID(\(self.uuidString))"
    }
}
