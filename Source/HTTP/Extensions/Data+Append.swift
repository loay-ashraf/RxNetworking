//
//  Data+Append.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

extension Data {
    mutating func append(contentsOf data: [Data]) {
        data.forEach({ self.append($0) })
    }
}
