//
//  SessionConfiguration.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation

/// Wrapper object for `URLSessionConfiguration` and additional configuration parameters.
public class SessionConfiguration {
    
    /// Default `SessionConfiguration` object.
    public static var `default`: SessionConfiguration {
        .init(urlSessionConfiguration: .default)
    }
    
    public static var ephemeral: SessionConfiguration {
        .init(urlSessionConfiguration: .ephemeral)
    }
    
    /// `URLSessionConfiguration` object used to create `URLSession` object.
    let urlSessionConfiguration: URLSessionConfiguration
    /// `Bool` flag that indicates wether a `URLSession` should add `User-Agent` header to outgoing requests.
    public var setUserAgentHeader: Bool = true
    /// `Bool` flag that indicates wether a `URLSession` should print outgoing requests to the console.
    public var logRequests: Bool = true
    public var tlsTrustEvaluatorConfiguration: TLSTrustEvaluatorConfiguration = .default
    
    /// Creates a `SessionConfiguration` instance.
    ///
    /// - Parameters:
    ///   - urlSessionConfiguration: `URLSessionConfiguration` object used to create `URLSession` object.
    public init(urlSessionConfiguration: URLSessionConfiguration) {
        self.urlSessionConfiguration = urlSessionConfiguration
    }
    
    public static func background(withIdentifier identifier: String) -> SessionConfiguration {
        .init(urlSessionConfiguration: .background(withIdentifier: identifier))
    }
    
}
