//
//  HTTPLogBodyMessageFactory.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

final class HTTPLogBodyMessageFactory {
    
    /// Makes console body message for outgoing request.
    ///
    /// - Parameters:
    ///   - bodyOption: `HTTPLogBodyOption` option for how body is represented in the log message.
    ///
    /// - Returns: `String` of outgoing request body message.
    func make(bodyOption: HTTPLogBodyOption) -> String {
        switch bodyOption {
        case .plain(let body):
            return make(body)
        case .file(let file):
            return make(file)
        case .formData(let formData):
            return make(formData)
        }
    }
    
    private func make(_ rawData: Data?) -> String {
        var logBodyMessage = ""
        if let rawData = rawData {
            if let jsonString = rawData.json {
                logBodyMessage += "\n\(jsonString)\n"
            } else {
                logBodyMessage += "\n\(String(data: rawData, encoding: .utf8) ?? "{ HTTP Body }")\n"
            }
        }
        return logBodyMessage
    }
    
    /// Makes console body message for outgoing request.
    ///
    /// - Parameters:
    ///   - file: `FileType` file details to be printed in place of body.
    ///
    /// - Returns: `String` of outgoing request body message.
    private func make(_ file: FileType) -> String {
        var logBodyMessage: String = ""
        
        if let filePath = file.path {
            let fileName = file.name
            let fileType = file.mimeType.rawValue
            let fileSize = file.size.formattedSize
            logBodyMessage += "{ File From Disk }\n"
            logBodyMessage += "- Name: \(fileName)\n"
            logBodyMessage += "- Type: \(fileType)\n"
            logBodyMessage += "- Size: \(fileSize)\n"
            logBodyMessage += "- Path: \(filePath)"
        } else if file.data != nil {
            let fileName = file.name
            let fileType = file.mimeType.rawValue
            let fileSize = file.size.formattedSize
            logBodyMessage += "{ File From Memory }\n"
            logBodyMessage += "- Name: \(fileName)\n"
            logBodyMessage += "- Type: \(fileType)\n"
            logBodyMessage += "- Size: \(fileSize)"
        }
        
        return logBodyMessage
    }
    
    /// Makes console body message for outgoing request.
    ///
    /// - Parameters:
    ///   - formData: `FormData` form data details to be printed in place of body.
    ///
    /// - Returns: `String` of outgoing request body message.
    private func make(_ formData: FormData) -> String {
        var logBodyMessage: String = "\n"
        let boundary = formData.boundary
        let lineBreak: String = "\r\n"
        
        for parameter in formData.parameters {
            logBodyMessage += "--\(formData.boundary + lineBreak)"
            logBodyMessage += "Content-Disposition: form-data; name=\"\(parameter.key)\"\(lineBreak + lineBreak)"
            logBodyMessage += "\(parameter.value + lineBreak)"
        }
        
        for file in formData.files {
            logBodyMessage += "--\(boundary + lineBreak)"
            logBodyMessage += "Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.name)\"\(lineBreak)"
            logBodyMessage += "Content-Type: \(file.mimeType.rawValue + lineBreak + lineBreak)"
            
            let fileBodyLogMessage = make(file)
            logBodyMessage += fileBodyLogMessage
            
            logBodyMessage += lineBreak
        }
        
        logBodyMessage += "--\(boundary)--\(lineBreak)"
        
        return logBodyMessage
    }
    
}
