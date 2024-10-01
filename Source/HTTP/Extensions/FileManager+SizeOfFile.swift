//
//  FileManager+SizeOfFile.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/05/2024.
//

import Foundation

extension FileManager {
    func sizeOfFile(atPath path: String) -> Int64? {
        guard let attrs = try? attributesOfItem(atPath: path) else {
            return nil
        }
        return attrs[.size] as? Int64
    }
    
    func sizeOfFile(atURL url: URL) -> Int64? {
        guard let attributes = try? attributesOfItem(atPath: url.path) else {
            return nil
        }
        return attributes[.size] as? Int64
    }
}
