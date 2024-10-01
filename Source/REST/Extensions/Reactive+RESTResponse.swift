//
//  Reactive+RESTResponse.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/01/2024.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {
    
    /// Observable sequence of responses for request.
    ///
    /// - Parameter request: `URLRequest` object.
    ///
    /// - Returns: Observable sequence of response.
    func restResponse(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        return Observable.create { observer in
            
#if DEBUG
            if URLSession.logRequests {
                let finalRequest = base.finalRequest(for: request)
                HTTPLogger.shared.log(request: finalRequest)
            }
#endif
            
            let task = self.base.dataTask(with: request) { data, response, error in
#if DEBUG
                if URLSession.logRequests {
                    HTTPLogger.shared.log(responseArguments: (request.url, data, response, error))
                }
#endif
                
                guard let response = response, let data = data else {
                    observer.on(.error(error ?? RxCocoaURLError.unknown))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.on(.error(RxCocoaURLError.nonHTTPResponse(response: response)))
                    return
                }
                
                observer.on(.next((httpResponse, data)))
                observer.on(.completed)
            }
            
            task.resume()
            
            return Disposables.create(with: task.cancel)
        }
    }
    
}
