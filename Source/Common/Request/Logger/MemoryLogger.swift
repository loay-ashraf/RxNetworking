//
//  MemoryLogger.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/05/2024.
//

import Foundation

final class MemoryLogger {
    
    static let shared: MemoryLogger = .init()
    
    private init() { }
    
    func logLargeUploadFile(file: FileType) {
        let logMessage = makeLogMessage(for: file)
        print(logMessage)
    }
    
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
