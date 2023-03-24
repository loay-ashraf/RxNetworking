//
//  File.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

struct File {
    let key: String
    let name: String
    let url: URL?
    let data: Data?
    let mimeType: HTTPMIMEType
    init?(forKey key: String, withName name: String, withData data: Data) {
        self.key = key
        self.name = name
        self.url = nil
        self.data = data
        guard let mime = HTTPMIMEType(fileName: name) else { return nil }
        self.mimeType = mime
    }
    init?(forKey key: String, withURL url: URL) {
        let name = url.lastPathComponent
        self.key = key
        self.name = name
        self.url = url
        self.data = nil
        guard let mime = HTTPMIMEType(fileName: name) else { return nil }
        self.mimeType = mime
    }
}
