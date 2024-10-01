//
//  String+InputStream.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// An extension to the `String` class providing additional functionalities,
/// specifically for converting a string into an `InputStream`.
extension String {
    
    /// Converts the string into an `InputStream`.
    ///
    /// This property creates an `InputStream` from the string's UTF-8 encoded data.
    /// If the conversion fails, it returns `nil`.
    ///
    /// - Returns: An optional `InputStream` created from the string's data.
    var inputStream: InputStream? {
        guard let data = self.data(using: .utf8) else { return nil }
        return .init(data: data)
    }
    
}
