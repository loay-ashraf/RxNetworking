//
//  String+InputStream.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

extension String {
    var inputStream: InputStream? {
        guard let data = self.data(using: .utf8) else { return nil }
        return .init(data: data)
    }
}
