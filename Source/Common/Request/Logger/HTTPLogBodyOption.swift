//
//  HTTPLogBodyOption.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// Represents the options for logging the body of an HTTP request or response.
///
/// This enum provides different methods to log the body content, which can be plain data,
/// a file, or multipart form data. Each case allows for flexible logging depending on
/// the specific needs of the request or response being handled.
enum HTTPLogBodyOption {
    
    /// Logs the body as plain data.
    /// - Parameter body: Optional `Data` object to be logged. Default is `nil`.
    case plain(_ body: Data? = nil)
    
    /// Logs the body as a file.
    /// - Parameter file: The `FileType` object representing the file to be logged.
    case file(_ file: FileType)
    
    /// Logs the body as multipart form data.
    /// - Parameter formData: The `FormData` object containing the form data to be logged.
    case formData(_ formData: FormData)
}
