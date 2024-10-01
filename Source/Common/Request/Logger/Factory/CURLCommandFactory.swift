//
//  CURLCommandFactory.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// A factory class responsible for making cURL command representations
/// for HTTP requests.
///
/// This class provides methods to create a cURL command string from a given
/// `URLRequest`, including handling different body options like plain data,
/// file uploads, and multipart form data.
final class CURLCommandFactory {
    
    /// Makes cURL command representation for a given request.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to make the cURL command representation.
    ///   - bodyOption: `HTTPLogBodyOption` that determines how the body is represented in the cURL command.
    ///
    /// - Returns: cURL command representation for the given request.
    func make(for request: URLRequest, bodyOption: HTTPLogBodyOption) -> String {
        guard let url = request.url else { return "" }
        var baseCommand = #"curl "\#(url.absoluteString)""#

        if request.httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = request.httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        switch bodyOption {
        case .plain:
            if let data = request.httpBody,
               let body = String(data: data, encoding: .utf8) {
                command.append("-d '\(body)'")
            }
        case .file(let file):
            command.append("--upload-file \(file.path ?? "{ Path to the file }")")
        case .formData(let formData):
            for parameter in formData.parameters {
                command.append("-F '\(parameter.key)=\(parameter.value)'")
            }
            
            for file in formData.files {
                command.append("-F '\(file.key)=@\(file.path ?? "{ Path to the file }");filename=\(file.name)'")
            }
        }

        return command.joined(separator: " \\\n\t")
    }
    
}
