//
//  HTTPLogBodyOption.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

enum HTTPLogBodyOption {
    case plain(_ body: Data? = nil)
    case file(_ file: FileType)
    case formData(_ formData: FormData)
}
