//
//  Reactive+URLSessionDownloadResponse.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
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
    ///
    /// - Returns: a tuple of progress `PublishSubject` and response and data `Single`
    func downloadResponse(request: URLRequest) -> (PublishSubject<Progress>, Single<(response: HTTPURLResponse, data: Data)>) {
        // we must keep refernce to task progress observation object
        var taskProgressObservation: NSKeyValueObservation?
        let taskProgressSubject = PublishSubject<Progress>()
        let taskResponseSingle = Single<(response: HTTPURLResponse, data: Data)>.create { single in
            let task = self.base.fileDownloadTask(with: request) { data, response, error in
#if DEBUG
                if URLSession.logRequests {
                    HTTPLogger.shared.log(responseArguments: (request.url, data, response, error), bodyLogMessage: "[File Body]")
                }
#endif
                guard let response = response, let data = data else {
                    single(.failure(error ?? RxCocoaURLError.unknown))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    single(.failure(RxCocoaURLError.nonHTTPResponse(response: response)))
                    return
                }
                single(.success((httpResponse, data)))
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
    /// Creates a tuple that includes progress `PublishSubject` and response and data `Single`.
    /// This method is inspired by RxCocoa's `response` method.
    ///
    /// - Parameters:
    ///   - request: `URLRequest` used to create upload task and its observables.
    ///   - url: `URL` path that the downloaded file will be downloaded to.
    ///
    /// - Returns: a tuple of progress `PublishSubject` and response and data `Single`.
    func downloadResponse(request: URLRequest, saveTo url: URL) -> (PublishSubject<Progress>, Single<(response: HTTPURLResponse, data: Data)>) {
        // we must keep refernce to task progress observation object
        var taskProgressObservation: NSKeyValueObservation?
        let taskProgressSubject = PublishSubject<Progress>()
        let taskResponseSingle = Single<(response: HTTPURLResponse, data: Data)>.create { single in
            let task = self.base.fileDownloadTask(with: request, saveTo: url) { data, response, error in
#if DEBUG
                if URLSession.logRequests {
                    HTTPLogger.shared.log(responseArguments: (request.url, data, response, error), bodyLogMessage: "[File Body]")
                }
#endif
                guard let response = response, let data = data else {
                    single(.failure(error ?? RxCocoaURLError.unknown))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    single(.failure(RxCocoaURLError.nonHTTPResponse(response: response)))
                    return
                }
                single(.success((httpResponse, data)))
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
