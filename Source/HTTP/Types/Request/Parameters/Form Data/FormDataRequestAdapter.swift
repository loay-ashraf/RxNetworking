//
//  FormDataRequestAdapter.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// A request adapter that transforms a `URLRequest` into a multipart form request
/// by setting the appropriate content type and body using the provided `FormData`.
///
/// The `FormDataRequestAdapter` class modifies an existing `URLRequest` to include
/// multipart form data, which is suitable for sending both text parameters and files
/// in a single request.
final class FormDataRequestAdapter {

    /// The original URL request that will be adapted for multipart form data.
    private let request: URLRequest
    
    /// The form data containing parameters and files to be included in the request.
    private let formData: FormData
    
    /// A factory instance for making the body of the multipart form request.
    private let bodyFactory: FormDataBodyFactory
    
    /// Initializes a new `FormDataRequestAdapter` with the specified request and form data.
    ///
    /// - Parameters:
    ///   - request: The original `URLRequest` to be adapted.
    ///   - formData: The `FormData` object containing parameters and files for the request.
    init(request: URLRequest, formData: FormData) {
        self.request = request
        self.formData = formData
        self.bodyFactory = .init()
    }
    
    /// Adapts the original URL request to include multipart form data.
    ///
    /// - Returns: A new `URLRequest` with the content type and body set for multipart form data.
    func adapt() -> URLRequest {
        var request = request
        request = setContentType(request)
        request = setBody(request)
        return request
    }
    
    /// Sets the content type of the request to multipart/form-data with the appropriate boundary.
    ///
    /// - Parameter request: The original `URLRequest`.
    /// - Returns: The modified `URLRequest` with the content type set.
    private func setContentType(_ request: URLRequest) -> URLRequest {
        var mutableRequest = request
        
        let contentType = "multipart/form-data; boundary=\(formData.boundary)"
        mutableRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return mutableRequest
    }
    
    /// Sets the body of the request using the form data.
    ///
    /// - Parameter request: The original `URLRequest`.
    /// - Returns: The modified `URLRequest` with the body set to the generated multipart form data.
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
