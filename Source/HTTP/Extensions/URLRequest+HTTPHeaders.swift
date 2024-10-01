//
//  URLRequest+HTTPHeaders.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/05/2024.
//

import Foundation

extension URLRequest {
    mutating func setValue(_ value: Int64?, forHTTPHeaderField field: String) {
        guard let value = value else { return }
        setValue("\(value)", forHTTPHeaderField: field)
    }
}
