//
//  File.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

/// Holds file details for upload requests, conforming to the `FileType` protocol.
/// This struct is used to represent a file that can be uploaded,
/// including its name, path, data, input stream, MIME type, and size.
public struct File: FileType {
    
    /// The name of the file, including its extension.
    let name: String
    
    /// The absolute path of the file, if available.
    let path: String?
    
    /// The data of the file, if available.
    /// This property holds the contents of the file as a `Data` object.
    let data: Data?
    
    /// The input stream of the file, if available.
    /// This property allows reading the file's contents in a streaming manner,
    /// which is useful for larger files.
    let inputStream: InputStream?
    
    /// The MIME type of the file, indicating its format.
    let mimeType: HTTPMIMEType
    
    /// The size of the file in bytes.
    let size: Int64
    
    /// Creates a `File` instance for relatively small files (less than 20MB).
    ///
    /// - Parameters:
    ///   - name: The name of the file, including its extension.
    ///   - extension: The file extension, used to determine its MIME type.
    ///   - data: A `Data` object containing the file's contents.
    ///
    /// - Returns: A `File` instance if successful; `nil` if the MIME type could not be determined.
    public init?(withName name: String, withExtension `extension`: String, withData data: Data) {
        self.name = name
        self.path = nil
        self.data = data
        self.inputStream = nil
        
        guard let mime = HTTPMIMEType(fileExtension: `extension`) else { return nil }
        self.mimeType = mime
        self.size = Int64(data.count)
        
#if DEBUG
        if size > 10_485_760 { // Log large file uploads for debugging.
            MemoryLogger.shared.logLargeUploadFile(file: self)
        }
#endif
    }
    
    /// Creates a `File` instance for relatively large files (greater than 20MB).
    ///
    /// - Parameters:
    ///   - url: A local `URL` pointing to the file to be uploaded.
    ///
    /// - Returns: A `File` instance if successful; `nil` if the MIME type or size could not be determined.
    public init?(withURL url: URL) {
        let fileName = url.lastPathComponent
        let (name, `extension`) = fileName.splitNameAndExtension()
        
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
