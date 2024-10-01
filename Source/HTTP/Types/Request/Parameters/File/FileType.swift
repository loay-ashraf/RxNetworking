//
//  FileType.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

protocol FileType {
    /// name of the file.
    var name: String { get }
    /// absolute path of the file.
    var path: String? { get }
    /// data of the file.
    var data: Data? { get }
    /// input stream of the file.
    var inputStream: InputStream? { get }
    /// MIME type of the file.
    var mimeType: HTTPMIMEType { get }
    /// size of the file.
    var size: Int64 { get }
}
