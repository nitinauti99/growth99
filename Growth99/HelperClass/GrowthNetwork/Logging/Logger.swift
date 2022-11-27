
import Foundation

public enum LogLevel: UInt8, CaseIterable {
    case `default` = 0
    case info = 1
    case debug = 2
    case error = 16
    case fault = 17
}

// MARK: -
public struct LogEntry {

    public let message: String
    public let category: String
    public let level: LogLevel
    public let file: String
    public let function: String
    public let line: Int

    internal init(message: String,
                  category: String = "default",
                  level: LogLevel = .default,
                  file: String = #file,
                  function: String = #function,
                  line: Int = #line) {

        self.message = message
        self.category = category
        self.level = level
        self.file = file
        self.function = function
        self.line = line
    }
}

// MARK: -
public protocol Logger {

    func log(_ entry: LogEntry)
}
