//
//  HTTPClient.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 10/10/2023.
//

import Foundation
import RxSwift

/// Entry point for creating http requests.
public class HTTPClient {
    
    /// Principal `Session` object that encapsulates `URLSession` instance.
    private let session: Session
    /// Principal `URLSession` object used to create request tasks.
    private var urlSession: URLSession {
        session.urlSession
    }
    /// Principal `HTTPRequestInterceptor` object used to intercept requests.
    private let requestInterceptor: HTTPRequestInterceptor
    
    /// Creates a `RESTClient` instance.
    ///
    /// - Parameters:
    ///   - session: `Session` object that encapsulates `URLSession` instance.
    ///   - requestInterceptor: `HTTPRequestInterceptor` object used for intercepting requests.
    public init(session: Session, requestInterceptor: HTTPRequestInterceptor) {
        // Initialize manager's properties.
        self.session = session
        self.requestInterceptor = requestInterceptor
    }
    
    /// Creates a `Observable` object encapsulating download request using given `Router`.
    /// Use this method if you are downloading a relatively small file (keeps data in memory).
    ///
    /// - Parameters:
    ///   - router: `HTTPDownloadRequestRouter` object used to create request.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating download request.
    public func download<E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPDownloadRequestRouter, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Observable<HTTPDownloadRequestEvent> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: urlSession)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: urlSession)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: urlSession)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.urlSession, dueTo: error)
        }
        let observable = urlSession
            .rx
            .downloadResponse(request: adaptedRequest, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    
    /// Creates a `Observable` object encapsulating download request using given `Router`.
    /// Use this method if you are downloading a relatively small file (saves file to disk).
    ///
    /// - Parameters:
    ///   - router: `HTTPDownloadRequestRouter` object used to create request.
    ///   - fileURL: `URL` used to save downloaded file to disk.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating download request.
    public func download<E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPDownloadRequestRouter, _ fileURL: URL, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Observable<HTTPDownloadRequestEvent> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: urlSession)
        let retryMaxAttempts = requestInterceptor.retryMaxAttempts(adaptedRequest, for: urlSession)
        let retryPolicy = requestInterceptor.retryPolicy(adaptedRequest, for: urlSession)
        let shouldRetry = { (error: HTTPError) in
            self.requestInterceptor.shouldRetry(adaptedRequest, for: self.urlSession, dueTo: error)
        }
        let observable = urlSession
            .rx
            .downloadResponse(request: adaptedRequest, saveTo: fileURL, httpErrorType: E.self, apiErrorType: AE.self)
            .retry(retryMaxAttempts, delay: retryPolicy, shouldRetry: shouldRetry)
        return observable
    }
    
    /// Creates a `Observable` object encapsulating upload request using given `Router`.
    /// Use this method if you are uploading single file at a time.
    ///
    /// - Parameters:
    ///   - router: `HTTPUploadRequestRouter` object used to create request.
    ///   - file: `HTTPUploadRequestFile` object including file details for upload.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating upload request.
    public func upload<T: Decodable, E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPUploadRequestRouter, _ file: File, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Observable<HTTPUploadRequestEvent<T>> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: urlSession)
        let observable = urlSession
            .rx
            .uploadResponse(request: adaptedRequest, file: file, modelType: T.self, httpErrorType: E.self, apiErrorType: AE.self)
        return observable
    }
    
    /// Creates a `Observable` object encapsulating upload request using given `Router`.
    /// Use this method if you are uploading multiple files at a time.
    ///
    /// - Parameters:
    ///   - router: `HTTPUploadRequestRouter` object used to create request.
    ///   - formData: `FormData` object including parameters and files for upload.
    ///   - httpErrorType: `HTTPBodyError` http body error type.
    ///   - apiErrorType: `HTTPAPIError` type expected to be received in response body.
    ///
    /// - Returns: `Observable` object encapsulating upload request.
    public func upload<T: Decodable, E: HTTPBodyError, AE: HTTPAPIError>(_ router: HTTPUploadRequestRouter, _ formData: FormData, _ httpErrorType: E.Type = DefaultHTTPBodyError.self, _ apiErrorType: AE.Type = DefaultHTTPAPIError.self) -> Observable<HTTPUploadRequestEvent<T>> {
        let originalRequest = router.asURLRequest()
        let adaptedRequest = requestInterceptor.adapt(originalRequest, for: urlSession)
        let observable = urlSession
            .rx
            .uploadResponse(request: adaptedRequest, formData: formData, modelType: T.self, httpErrorType: E.self, apiErrorType: AE.self)
        return observable
    }
    
}
