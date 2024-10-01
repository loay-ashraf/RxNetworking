//
//  HTTPLogger.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation

/// Object responsible for logging outgoing requests and incoming responses.
final class HTTPLogger {
    
    /// Shared `HTTPLogger` instance.
    static let shared: HTTPLogger = .init()
    
    /// Factory object used to make log messages
    private let messageFactory: HTTPLogMessageFactory = .init()
    
    /// Private initializer to ensure only one instance is created.
    private init() { }
    
    /// Prints outgoing request to console.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` to be printed to console.
    ///   - bodyOption: `HTTPLogBodyOption` option for how body is represented in the log message.
    func log(request: URLRequest, bodyOption: HTTPLogBodyOption = .plain()) {
        let logMessage = messageFactory.make(for: request, bodyOption: bodyOption)
        print(logMessage)
    }
    
    /// Prints incoming response to console.
    ///
    /// - Parameters:
    ///   - responseArguments: `(URL?, URLResponse?, Data?, Error?)` to be printed to console.
    ///   - bodyLogMessage: `String?` placeholder to be printed in place of actual body.
    func log(responseArguments: (URL?, Data?, URLResponse?, Error?), bodyLogMessage: String? = nil) {
        let logMessage = messageFactory.make(for: responseArguments, bodyLogMessage: bodyLogMessage)
        print(logMessage)
    }
    
}
