//
//  MemoryLogger.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/05/2024.
//

import Foundation

/// A singleton class responsible for logging memory warnings related to large file uploads.
/// The `MemoryLogger` logs messages when files larger than 10 MB are held in memory,
/// providing details about the file to help developers understand potential performance impacts.
final class MemoryLogger {
    
    /// The shared instance of `MemoryLogger`, implementing the singleton pattern.
    static let shared: MemoryLogger = .init()
    
    /// Private initializer to ensure that `MemoryLogger` cannot be instantiated from outside.
    private init() { }
    
    /// Logs a warning message for a large file held in memory during upload.
    ///
    /// - Parameter file: An instance conforming to the `FileType` protocol,
    ///                   representing the large file for upload.
    func logLargeUploadFile(file: FileType) {
        let logMessage = makeLogMessage(for: file)
        print(logMessage) // Print the log message to the console.
    }
    
    /// Creates a formatted log message for the specified file.
    ///
    /// - Parameter file: An instance conforming to the `FileType` protocol,
    ///                   from which details will be extracted for logging.
    /// - Returns: A string containing the formatted log message with file details.
    private func makeLogMessage(for file: FileType) -> String {
        var logMessage = ""
        
        logMessage += "\n* * * * * * * * * * MEMORY WARNING * * * * * * * * * *\n"
        logMessage += "\nHolding a large file for upload in the device memory (> 10 MB),\nPerformance may be reduced if the available memory is low.\n"
        logMessage += "\nFile Details:\n"
        logMessage += "- Name: \(file.name)\n"
        logMessage += "- Type: \(file.mimeType.rawValue)\n"
        logMessage += "- Size: \(file.size.formattedSize)\n"
        logMessage += "\n* * * * * * * * * * * * * END * * * * * * * * * * * * *\n"
        
        return logMessage
    }
}
