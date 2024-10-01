//
//  FileType.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// A protocol that defines the requirements for file-related types used in
/// upload requests. Types conforming to this protocol must provide
/// details about the file, including its name, path, data, input stream,
/// MIME type, and size.
protocol FileType {
    
    /// The name of the file.
    /// This property should return the original name of the file, excluding
    /// its extension.
    var name: String { get }
    
    /// The absolute path of the file, if available.
    /// This property returns an optional string representing the file's
    /// location in the file system.
    var path: String? { get }
    
    /// The data of the file, if available.
    /// This property returns an optional `Data` object representing the
    /// contents of the file. This is typically used for smaller files.
    var data: Data? { get }
    
    /// The input stream of the file, if available.
    /// This property returns an optional `InputStream` that can be used to
    /// read the contents of the file in a streaming manner, suitable for
    /// larger files.
    var inputStream: InputStream? { get }
    
    /// The MIME type of the file.
    /// This property returns an `HTTPMIMEType` indicating the type of the
    /// file, which is necessary for correct handling during the upload.
    var mimeType: HTTPMIMEType { get }
    
    /// The size of the file in bytes.
    /// This property returns the size of the file as an `Int64`, which is
    /// useful for determining if the file meets size restrictions.
    var size: Int64 { get }
}

