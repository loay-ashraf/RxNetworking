//
//  HTTPLogMessageFactory.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// A singleton class responsible for making log messages for outgoing HTTP requests
/// and incoming HTTP responses.
///
/// The `HTTPLogMessageFactory` provides formatted output
/// for monitoring and debugging HTTP communications, including details such as headers,
/// body content, and CURL commands.
final class HTTPLogMessageFactory {

    /// Factory responsible for maling body log messages.
    private let logBodyMessageFactory: HTTPLogBodyMessageFactory = .init()
    
    /// Factory responsible for making CURL commands.
    private let curlCommandFactory: CURLCommandFactory = .init()
    
    /// Makes console message for outgoing request.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` to be included in the message.
    ///   - bodyOption: `HTTPLogBodyOption` option for how body is represented in the log message.
    ///
    /// - Returns: `String` of the outgoing request message.
    func make(for request: URLRequest, bodyOption: HTTPLogBodyOption) -> String {
        var logMessage: String = ""
        
        logMessage += "* * * * * * * * * * OUTGOING REQUEST * * * * * * * * * *\n"
        
        let urlString = request.url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlString)
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var requestDetails = """
       \n\(urlString) \n
       \(method) \(path)?\(query) HTTP/1.1 \n
       HOST: \(host)\n
       """
        
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestDetails += "\(key): \(value) \n"
        }
        
        let logBodyMessage = logBodyMessageFactory.make(bodyOption: bodyOption)
        requestDetails += logBodyMessage.isEmpty ? "" : "\n"
        requestDetails += logBodyMessage
        
        logMessage += requestDetails
        
        let curlCommand = curlCommandFactory.make(for: request, bodyOption: bodyOption)
        logMessage += """
        \n- - - - - - - - - - - CURL COMMAND - - - - - - - - - - -\n
        """
        logMessage += "\n\(curlCommand)\n"
        logMessage += "\n* * * * * * * * * * * * * END * * * * * * * * * * * * *\n"
        
        return logMessage
    }
    
    /// Makes console message for incoming response.
    ///
    /// - Parameters:
    ///   - responseArguments: `(URL?, Data?, URLResponse?, Error?)` to be included in the message.
    ///   - bodyLogMessage: `String?` placeholder to be included in the message in place of actual body.
    ///
    /// - Returns: `String` of the incoming response message.
    func make(for responseArguments: (URL?, Data?, URLResponse?, Error?), bodyLogMessage: String?) -> String {
        var logMessage: String = ""
        
        logMessage += "* * * * * * * * * * INCOMING RESPONSE * * * * * * * * * *\n"
        
        let url = responseArguments.0
        let httpResponse = responseArguments.2 as? HTTPURLResponse
        let responseBody = responseArguments.1
        let responseError = responseArguments.3
        
        
        let urlString = url?.absoluteString ?? ""
        let urlComponents = URLComponents(string: urlString)
        let host = "\(urlComponents?.host ?? "")"
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        
        var responseDetails = ""
        
        responseDetails += "\n\(urlString)"
        responseDetails += "\n\n"
        
        if let statusCode = httpResponse?.statusCode {
            responseDetails += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        
        responseDetails += "Host: \(host)\n"
        
        for (key, value) in httpResponse?.allHeaderFields ?? [:] {
            responseDetails += "\(key): \(value)\n"
        }
        
        if let bodyLogMessage = bodyLogMessage,
           responseError == nil {
            responseDetails += "\n\(bodyLogMessage)\n"
        } else if let body = responseBody {
            if let jsonString = body.json {
                responseDetails += "\n\(jsonString)\n"
            } else {
                responseDetails += "\n\(String(decoding: body, as: UTF8.self))\n"
            }
        }
        
        if let responseError = responseError {
            let errorCode = (responseError as NSError).code
            if errorCode == -999,
               TLSTrustEvaluator.getBlockedHosts().contains(host) {
                responseDetails += "\nError: TLS trust evaluation failed for the specified host, you may need to update the pinned certificates or public keys.\n"
            } else {
                responseDetails += "\nError: \(responseError.localizedDescription)\n"
            }
        }
        
        logMessage += responseDetails
        logMessage += "\n* * * * * * * * * * * * * END * * * * * * * * * * * * *\n"
        
        return logMessage
    }
}
