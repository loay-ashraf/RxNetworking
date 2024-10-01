//
//  Int64+FormattedSize.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/05/2024.
//

import Foundation

extension Int64 {
    var formattedSize: String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB, .useMB, .useGB]
        bcf.countStyle = .file
        let size = bcf.string(fromByteCount: self)
        return size
    }
}
