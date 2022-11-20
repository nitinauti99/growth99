//
//  OSLogger.swift
//  FargoNetwork
//
//  Created by Stevil on 11/25/19.
//

import Foundation
import os

public struct OSLogger {

    /// Shared singleton, used as the default logger. It prints to `os_log`.
    public static let shared = OSLogger()

    /// Private initializer; no need for multiple instances.
    private init() {  }
}

// MARK: - Formatting
private extension OSLogger {

    static func format(message: String, file: String, function: String, line: Int) -> String {
        #if DEBUG || TESTING /* Line numbers and functions are discouraged in prod logs */
        return "[\(Date()) \(OSLogger.sourceFileName(filePath: file)) \(function):\(line)] \(message) \n"
        #else
        return "[\(Date())] \(message) \n"
        #endif
    }

    static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.last ?? ""
    }
}

// MARK: - `Logger` Protocol
extension OSLogger: Logger {

    public func log(_ entry: LogEntry) {
        let log = OSLog(
            subsystem: "com.apple.FargoNetwork",
            category: entry.category
        )
        let formattedText: String = OSLogger.format(
            message: entry.message,
            file: entry.file,
            function: entry.function,
            line: entry.line
        )
        #if DEBUG || TESTING
        switch entry.level {
        case .debug:
            os_log("%{public}@", log: log, type: .debug, formattedText)
        case .error:
            os_log("%{public}@", log: log, type: .error, formattedText)
        case .fault:
            os_log("%{public}@", log: log, type: .fault, formattedText)
        case .info:
            os_log("%{public}@", log: log, type: .info, formattedText)
        case .default:
            os_log("%{public}@", log: log, type: .default, formattedText)
        }
        #else
        switch entry.level {
        case .error:
            os_log("%{public}@", log: log, type: .error, formattedText)
        case .debug, .fault, .info, .default:
            return
        }
        #endif
    }
}
