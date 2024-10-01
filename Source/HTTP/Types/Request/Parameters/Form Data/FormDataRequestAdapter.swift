//
//  FormDataRequestAdapter.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

class FormDataRequestAdapter {
    
    private let request: URLRequest
    private let formData: FormData
    private let bodyFactory: FormDataBodyFactory
    
    init(request: URLRequest, formData: FormData) {
        self.request = request
        self.formData = formData
        self.bodyFactory = .init()
    }
    
    func adapt() -> URLRequest {
        var request = request
        request = setContentType(request)
        request = setBody(request)
        return request
    }
    
    private func setContentType(_ request: URLRequest) -> URLRequest {
        var mutableRequest = request
        
        let contentType = "multipart/form-data; boundary=\(formData.boundary)"
        mutableRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return mutableRequest
    }
    
    private func setBody(_ request: URLRequest) -> URLRequest {
        var mutableRequest = request
        
        let body = bodyFactory.make(formData: formData)
        
        if let data = body.data {
            mutableRequest.httpBody = data
        } else if let inputStream = body.inputStream {
            mutableRequest.httpBodyStream = inputStream
        }
        
        return mutableRequest
    }
    
}
