//
//  FormParameter.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

/// Represents a key-value pair for a form field in a multipart form request.
public struct FormParameter {

    /// The name of the form field.
    let key: String

    /// The value associated with the form field.
    let value: String

    /// Initializes a new `FormParameter` with a specified key and value.
    ///
    /// - Parameters:
    ///   - key: The name of the form field.
    ///   - value: The value associated with the form field.
    public init(_ key: String, _ value: String) {
        self.key = key
        self.value = value
    }
}
