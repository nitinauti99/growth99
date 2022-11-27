

import Foundation

public struct Timestamp: CustomStringConvertible, Equatable, Comparable {
    static let dateFormatter = DateFormatter()

    let timestamp: Foundation.TimeInterval

    public enum Since {
        case unix
        case now
    }

    public static func now() -> Timestamp {
        Timestamp()
    }

    init() {
        self.timestamp = Date().timeIntervalSince1970
    }

    init(seconds: Foundation.TimeInterval, since: Since) {
        switch since {
        case .now:
            self.timestamp = Date().timeIntervalSince1970 + seconds
        case .unix:
            self.timestamp = seconds
        }
    }

    public var unixTimestamp: UInt {
        UInt(self.timestamp) * 1000
    }

    // MARK: CustomStringConvertible
    public var description: String {
        let date = Date(timeIntervalSince1970: self.timestamp)
        return Timestamp.dateFormatter.string(from: date)
    }
}

public extension TimeInterval {
    init(seconds: Int) {
        self = TimeInterval(seconds)
    }

    init(minutes: Int) {
        self = TimeInterval(seconds: minutes * 60)
    }

    init(hours: Int) {
        self.init(minutes: hours * 60)
    }

    init(days: Int) {
        self.init(hours: days * 24)
    }
}

// Add & Subtract

public func + (lhs: Timestamp, rhs: TimeInterval) -> Timestamp {
    Timestamp(seconds: lhs.timestamp + rhs, since: .unix)
}

public func - (lhs: Timestamp, rhs: TimeInterval) -> Timestamp {
    Timestamp(seconds: lhs.timestamp - rhs, since: .unix)
}

public func - (lhs: Timestamp, rhs: Timestamp) -> TimeInterval {
    lhs.timestamp - rhs.timestamp
}

// Equatable

public func == (lhs: Timestamp, rhs: Timestamp) -> Bool {
    lhs.timestamp == rhs.timestamp
}

// Comparable

public func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
    lhs.timestamp < rhs.timestamp
}

public func <= (lhs: Timestamp, rhs: Timestamp) -> Bool {
    lhs.timestamp <= rhs.timestamp
}

public func > (lhs: Timestamp, rhs: Timestamp) -> Bool {
    lhs.timestamp > rhs.timestamp
}

public func >= (lhs: Timestamp, rhs: Timestamp) -> Bool {
    lhs.timestamp >= rhs.timestamp
}
