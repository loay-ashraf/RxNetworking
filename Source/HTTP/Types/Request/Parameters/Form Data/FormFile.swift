//
//  FormFile.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 21/05/2024.
//

import Foundation

/// Represents the details of a file intended for a multipart upload request.
///
/// The `FormFile` struct encapsulates all necessary information about a file,
/// including its key, name, path, binary data, input stream, MIME type, and size.
/// It supports both small files (which can be represented by their data) and
/// large files (which are accessed via an input stream).
public struct FormFile: FileType {

    /// A unique key used to identify the file in the multipart form request.
    let key: String
    
    /// The name of the file, excluding the extension.
    let name: String
    
    /// The absolute path of the file on the local filesystem, if available.
    let path: String?
    
    /// The binary data of the file, used for small files (optional).
    let data: Data?
    
    /// An input stream for reading the content of the file, used for large files (optional).
    let inputStream: InputStream?
    
    /// The MIME type of the file, representing its format (e.g., `image/jpeg`).
    let mimeType: HTTPMIMEType
    
    /// The size of the file in bytes.
    let size: Int64

    /// Initializes a `FormFile` instance for relatively small files (< 20MB).
    ///
    /// This initializer is intended for files that can fit comfortably into memory.
    /// It accepts the file's key, name, extension, and binary data.
    ///
    /// - Parameters:
    ///   - key: A unique identifier for the file in the form.
    ///   - name: The name of the file.
    ///   - extension: The file's extension (e.g., "jpg", "png").
    ///   - data: A `Data` object representing the file's binary content.
    ///
    /// - Returns: A `FormFile` instance, or `nil` if the MIME type could not be determined.
    public init?(forKey key: String, withName name: String, withExtension `extension`: String, withData data: Data) {
        self.key = key
        self.name = name
        self.path = nil
        self.data = data
        self.inputStream = nil
        guard let mime = HTTPMIMEType(fileExtension: `extension`) else { return nil }
        self.mimeType = mime
        self.size = Int64(data.count)
#if DEBUG
        // Log a warning for large file uploads (> 10MB) during debugging.
        if size > 10_485_760 {
            MemoryLogger.shared.logLargeUploadFile(file: self)
        }
#endif
    }
    
    /// Initializes a `FormFile` instance for relatively large files (> 20MB).
    ///
    /// This initializer is designed for files that are too large to be loaded into memory,
    /// and instead uses an input stream to read the file's content.
    ///
    /// - Parameters:
    ///   - key: A unique identifier for the file in the form.
    ///   - url: A local `URL` pointing to the file's location on disk.
    ///   
    /// - Returns: A `FormFile` instance, or `nil` if the MIME type or file size could not be determined.
    public init?(forKey key: String, withURL url: URL) {
        let fileName = url.lastPathComponent
        let (name, `extension`) = fileName.splitNameAndExtension()
        self.key = key
        self.name = name
        if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
            self.path = url.path()
        } else {
            self.path = url.path
        }
        self.data = nil
        self.inputStream = .init(url: url)
        guard let mime = HTTPMIMEType(fileExtension: `extension`) else { return nil }
        self.mimeType = mime
        guard let size = FileManager.default.sizeOfFile(atURL: url) else { return nil }
        self.size = size
    }
    
}
