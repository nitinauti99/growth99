
import Foundation
import os

 class Log: NSObject {

    static func debug(_ message: String, logger: Logger, logCategory: String = "default", file: String = #file, function: String = #function, line: Int = #line, shouldLog: Bool) {
        self.log(message, logger: logger, logCategory: logCategory, level: .debug, file: file, function: function, line: line, shouldLog: shouldLog)
    }

    static func info(_ message: String, logger: Logger, logCategory: String = "default", file: String = #file, function: String = #function, line: Int = #line, shouldLog: Bool) {
        self.log(message, logger: logger, logCategory: logCategory, level: .info, file: file, function: function, line: line, shouldLog: shouldLog)
    }

    static func fault(_ message: String, logger: Logger, logCategory: String = "default", file: String = #file, function: String = #function, line: Int = #line, shouldLog: Bool) {
        self.log(message, logger: logger, logCategory: logCategory, level: .fault, file: file, function: function, line: line, shouldLog: shouldLog)
    }

    static func error(_ message: String, logger: Logger, logCategory: String = "default", file: String = #file, function: String = #function, line: Int = #line, shouldLog: Bool) {
        self.log(message, logger: logger, logCategory: logCategory, level: .error, file: file, function: function, line: line, shouldLog: shouldLog)
    }

    static func log(_ message: String,
                    logger: Logger = OSLogger.shared,
                    logCategory: String = "default",
                    level: LogLevel = .default,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line,
                    shouldLog: Bool = true) {

        guard shouldLog else { return }
        let entry = LogEntry(message: message, category: logCategory, level: level, file: file, function: function, line: line)
        logger.log(entry)
    }
}
