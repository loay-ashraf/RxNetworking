//
//  URLRequest+OutgoingRequest.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation

extension URLSession {
    
    /// Computes actual outgoing request for a given initial request.
    ///
    /// - Parameter initialRequest: Initial `URLRequest` object.
    ///
    /// - Returns: Actual outgoing `URLRequest` after applying additional HTTP headers.
    func finalRequest(for initialRequest: URLRequest) -> URLRequest {
        var finalRequest = initialRequest
        let initialRequestHTTPHeaders = initialRequest.allHTTPHeaderFields ?? [:]
        let configurationAdditionalHTTPHeaders = (configuration.httpAdditionalHeaders) as? [String: String] ?? [:]
        finalRequest.allHTTPHeaderFields = initialRequestHTTPHeaders.merging(configurationAdditionalHTTPHeaders, uniquingKeysWith: { _, new in new })
        return finalRequest
    }
    
}
