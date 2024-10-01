//
//  URLSession+DownloadTask.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation

extension URLSession {
    /// Creates a download data task.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create data task.
    ///   - completionHandler: completion handler to be called on task completion.
    ///
    /// - Returns: download`URLSessionDataTask` created using given request.
    func fileDownloadTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
#if DEBUG
        if URLSession.logRequests {
            let finalRequest = finalRequest(for: request)
            HTTPLogger.shared.log(request: finalRequest)
        }
#endif
        let task = dataTask(with: request, completionHandler: completionHandler)
        return task
    }
    /// Creates a download data task.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create data task.
    ///   - url: local `URL` to which file is saved after download.
    ///   - completionHandler: completion handler to be called on task completion.
    ///
    /// - Returns: download`URLSessionDataTask` created using given request and local url.
    func fileDownloadTask(with request: URLRequest, saveTo url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
#if DEBUG
        if URLSession.logRequests {
            let finalRequest = finalRequest(for: request)
            HTTPLogger.shared.log(request: finalRequest)
        }
#endif
        let task = dataTask(with: request) { data, response, error in
            do {
                if let data = data {
                    try data.write(to: url)
                }
            } catch {
              completionHandler(data, response, error)
            }
            completionHandler(data, response, error)
        }
        return task
    }
}
