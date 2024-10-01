//
//  FormDataBody.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// Represents the body of a form data request, encapsulating either raw data or an input stream.
///
/// The `FormDataBody` struct is used to hold the content of a form data request,
/// allowing for flexible input methods. It supports both in-memory data and
/// streaming data from an input source.
struct FormDataBody {
    
    /// The raw data for the form body, if provided (optional).
    let data: Data?
    
    /// An input stream for reading the form body content, if provided (optional).
    let inputStream: InputStream?
    
    /// Initializes a `FormDataBody` instance with the provided raw data.
    ///
    /// - Parameter data: The raw `Data` object to be included in the form body.
    init(data: Data) {
        self.data = data
        self.inputStream = nil
    }
    
    /// Initializes a `FormDataBody` instance with the provided input stream.
    ///
    /// - Parameter inputStream: An `InputStream` for reading the form body content.
    init(inputStream: InputStream) {
        self.data = nil
        self.inputStream = inputStream
    }
}
