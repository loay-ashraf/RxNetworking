//
//  URLSessionConfiguration+setUserAgentHTTPHeader.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 21/08/2023.
//

import Foundation

extension URLSessionConfiguration {
    /// Sets `User-Agent` header as an additional HTTP header.
    func setUserAgentHTTPHeader() {
        let mainBundle = Bundle.main
        let mainBundleIndentifier = mainBundle.bundleIdentifier ?? "Unknown Client Identifier"
        let frameworkVersion = "3.0.1"
        let osName = ProcessInfo.processInfo.operatingSystemName
        let osVersion = ProcessInfo.processInfo.operatingSystemVersionString
        setAdditionalHTTPHeader("User-Agent", value: "RxNetworkKit/\(frameworkVersion) (\(osName) \(osVersion)) (\(mainBundleIndentifier))")
    }
}
