//
//  Logger.swift
//  Jetman
//
//  Created by Thomas Ganley on 12/3/17.
//  Copyright © 2017 Thomas Ganley. All rights reserved.
//

import Foundation

class Logger {
    
    // MARK: Visible methods
    
    static func info(_ message: String, filePath: String, funcName: String, lineNumber: Int) {
        let severity = LogEventSeverity.info
        let fileName = extractFileName(filePath: filePath)
        logWith(severity: severity, message: message, fileName: fileName, funcName: funcName, lineNumber: lineNumber)
    }
    
    static func warning(_ message: String, filePath: String, funcName: String, lineNumber: Int) {
        let severity = LogEventSeverity.warning
        let fileName = extractFileName(filePath: filePath)
        logWith(severity: severity, message: message, fileName: fileName, funcName: funcName, lineNumber: lineNumber)
    }
    
    static func error(_ message: String, filePath: String, funcName: String, lineNumber: Int) {
        let severity = LogEventSeverity.error
        let fileName = extractFileName(filePath: filePath)
        logWith(severity: severity, message: message, fileName: fileName, funcName: funcName, lineNumber: lineNumber)
    }
    
    static func severe(_ message: String, filePath: String, funcName: String, lineNumber: Int) {
        let severity = LogEventSeverity.severe
        let fileName = extractFileName(filePath: filePath)
        logWith(severity: severity, message: message, fileName: fileName, funcName: funcName, lineNumber: lineNumber)
    }
    
    static func verbose(_ message: String, filePath: String, funcName: String, lineNumber: Int) {
        let severity = LogEventSeverity.verbose
        let fileName = extractFileName(filePath: filePath)
        logWith(severity: severity, message: message, fileName: fileName, funcName: funcName, lineNumber: lineNumber)
    }
    
    static func debug(_ message: String, filePath: String, funcName: String, lineNumber: Int) {
        let severity = LogEventSeverity.debug
        let fileName = extractFileName(filePath: filePath)
        logWith(severity: severity, message: message, fileName: fileName, funcName: funcName, lineNumber: lineNumber)
    }
    
    // MARK: Private methods
    
    private static func extractFileName(filePath: String) -> String {
        let filePathComponents = filePath.components(separatedBy: "/")
        return filePathComponents.last ?? "Unknown File"
    }
    
    private static func logWith(severity: LogEventSeverity, message: String, fileName: String, funcName: String, lineNumber: Int) {
        #if DEBUG
            let dateString = Date().stringWithFormat(Constants.LoggerDefaults.defaultFormat)
            let formattedLogMessage = "\(dateString): \(severity.rawValue) - [\(fileName)]: Line \(lineNumber) \(funcName) -> \(message)"
            print(formattedLogMessage)
        #endif
    }
    
}

extension Logger {
    
    enum LogEventSeverity: String {
        case info = "[ℹ️]"
        case warning = "[⚠️]"
        case error = "[‼️]"
        case severe = "[🔥]"
        case verbose = "[🔬]"
        case debug = "[💬]"
    }
    
}
