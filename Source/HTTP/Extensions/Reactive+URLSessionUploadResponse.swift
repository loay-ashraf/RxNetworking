//
//  Reactive+URLSessionResponse.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 22/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {
    /// Creates a tuple that includes progress `PublishSubject` and response and data `Single`.
    /// This method is inspired by RxCocoa's `response` method.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - file: `HTTPUploadRequestFile` object to be uploaded.
    ///
    /// - Returns: a tuple of progress `PublishSubject` and response and data `Singsle`.
    func uploadResponse(request: URLRequest, file: File) -> (PublishSubject<Progress>, Single<(response: HTTPURLResponse, data: Data)>) {
        let adaptedRequest = adaptUploadRequest(originalRequest: request, withFile: file)
        let uploadRequestObservables = makeUploadRequestObservables(request: adaptedRequest, completion: {
            self.logUploadResponse(url: adaptedRequest.url, data: $0, urlResponse: $1, error: $2)
        })
        logUploadRequest(request: adaptedRequest, file: file)
        return uploadRequestObservables
    }
    
    /// Creates a tuple that includes progress `PublishSubject` and response and data `Single`.
    /// This method is inspired by RxCocoa's `response` method.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - formData: `FormData` object that includes parameters and files to be uploaded.
    ///
    /// - Returns: a tuple of progress `PublishSubject` and response and data `Single`.
    func uploadResponse(request: URLRequest, formData: FormData) -> (PublishSubject<Progress>, Single<(response: HTTPURLResponse, data: Data)>) {
        let adaptedRequest = adaptUploadRequest(originalRequest: request, withFormData: formData)
        let uploadRequestObservables = makeUploadRequestObservables(request: adaptedRequest, completion: {
            self.logUploadResponse(url: adaptedRequest.url, data: $0, urlResponse: $1, error: $2)
        })
        logUploadRequest(request: adaptedRequest, formData: formData)
        return uploadRequestObservables
    }
}

extension Reactive where Base: URLSession {
    /// Adapts upload request by applying 'Content-Type' HTTP header and HTTP body.
    ///
    /// - Parameters:
    ///   - originalRequest: original `URLRequest`.
    ///   - file: `HTTPUploadRequestFile` to be added to the request.
    ///
    /// - Returns: Adapted `URLRequest`.
    fileprivate func adaptUploadRequest(originalRequest: URLRequest, withFile file: File) -> URLRequest {
        var request = originalRequest
        request.setValue(file.name, forHTTPHeaderField: "File-Name")
        request.setValue(file.mimeType.rawValue, forHTTPHeaderField: "Content-Type")
        request.setValue(file.size, forHTTPHeaderField: "Content-Length")
        if let data = file.data {
            request.httpBody = data
        } else if let inputStream = file.inputStream {
            request.httpBodyStream = inputStream
        }
        return request
    }
    
    /// Adapts upload request by applying 'Content-Type' HTTP header and HTTP body via `FormDataRequestAdapter`.
    ///
    /// - Parameters:
    ///   - originalRequest: original `URLRequest`.
    ///   - file: `HTTPUploadRequestFile` to be added to the request.
    ///
    /// - Returns: Adapted `URLRequest`.
    fileprivate func adaptUploadRequest(originalRequest: URLRequest, withFormData formData: FormData) -> URLRequest {
        let requestAdapter = FormDataRequestAdapter(request: originalRequest, formData: formData)
        let request = requestAdapter.adapt()
        return request
    }
    
    fileprivate func logUploadRequest(request: URLRequest, file: File) {
#if DEBUG
        if URLSession.logRequests {
            let finalRequest = base.finalRequest(for: request)
            HTTPLogger.shared.log(request: finalRequest, bodyOption: .file(file))
        }
#endif
    }
    
    fileprivate func logUploadRequest(request: URLRequest, formData: FormData) {
#if DEBUG
        if URLSession.logRequests {
            let finalRequest = base.finalRequest(for: request)
            HTTPLogger.shared.log(request: finalRequest, bodyOption: .formData(formData))
        }
#endif
    }
    
    fileprivate func logUploadResponse(url: URL?, data: Data?, urlResponse: URLResponse?, error: Error?) {
#if DEBUG
        if URLSession.logRequests {
            HTTPLogger.shared.log(responseArguments: (url, data, urlResponse, error))
        }
#endif
    }
    
    fileprivate func handleRequestCompletion(using single: (Result<(response: HTTPURLResponse, data: Data), any Error>) -> Void,
                                             with arguments: (Data?, URLResponse?, Error?)) {
        guard let response = arguments.1,
              let data = arguments.0 else {
                  single(.failure(arguments.2 ?? RxCocoaURLError.unknown))
            return
        }
        guard let httpResponse = arguments.1 as? HTTPURLResponse else {
            single(.failure(RxCocoaURLError.nonHTTPResponse(response: response)))
            return
        }
        single(.success((httpResponse, data)))
    }
    
    fileprivate func makeUploadRequestObservables(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> (PublishSubject<Progress>, Single<(response: HTTPURLResponse, data: Data)>) {
        var taskProgressObservation: NSKeyValueObservation?
        let taskProgressSubject = PublishSubject<Progress>()
        let taskResponseSingle = Single<(response: HTTPURLResponse, data: Data)>.create { single in
            let task = self.base.dataTask(with: request) { data, response, error in
                completion(data, response, error)
                self.handleRequestCompletion(using: single, with: (data, response, error))
            }
            taskProgressObservation = task.progress.observe(\.fractionCompleted) { progress, _ in
                taskProgressSubject.onNext(progress)
                if progress.fractionCompleted == 1.00 {
                    taskProgressSubject.onCompleted()
                }
            }
            _ = taskProgressObservation
            task.resume()
            return Disposables.create(with: task.cancel)
        }
        return (taskProgressSubject, taskResponseSingle)
    }
}
