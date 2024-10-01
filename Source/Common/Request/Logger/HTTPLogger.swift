//
//  HTTPLogger.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation

/// A singleton class responsible for logging outgoing HTTP requests and incoming HTTP responses.
///
/// The `HTTPLogger` provides a shared instance for logging purposes, enabling developers
/// to monitor and debug HTTP communications in their applications. It includes methods
/// for logging both requests and responses with customizable logging options.
final class HTTPLogger {
    
    /// Shared `HTTPLogger` instance, implementing the singleton pattern.
    static let shared: HTTPLogger = .init()
    
    /// A factory object used to create log messages for requests and responses.
    private let messageFactory: HTTPLogMessageFactory = .init()
    
    /// Private initializer to ensure that only one instance of `HTTPLogger` can be created.
    private init() { }
    
    /// Logs an outgoing HTTP request to the console.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` to be logged, containing information about the HTTP request.
    ///   - bodyOption: An `HTTPLogBodyOption` indicating how the request body should be represented in the log message.
    ///                 Defaults to `.plain()`.
    func log(request: URLRequest, bodyOption: HTTPLogBodyOption = .plain()) {
        let logMessage = messageFactory.make(for: request, bodyOption: bodyOption)
        print(logMessage) // Print the log message to the console.
    }
    
    /// Logs an incoming HTTP response to the console.
    ///
    /// - Parameters:
    ///   - responseArguments: A tuple containing optional values:
    ///     - `URL?`: The URL of the response, if available.
    ///     - `Data?`: The data received in the response, if available.
    ///     - `URLResponse?`: The metadata associated with the response, if available.
    ///     - `Error?`: An optional error that occurred during the request, if applicable.
    ///   - bodyLogMessage: An optional `String?` placeholder to be printed in place of the actual body data.
    func log(responseArguments: (URL?, Data?, URLResponse?, Error?), bodyLogMessage: String? = nil) {
        let logMessage = messageFactory.make(for: responseArguments, bodyLogMessage: bodyLogMessage)
        print(logMessage) // Print the log message to the console.
    }
    
}
