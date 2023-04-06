//
//  UploadFormData.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

public struct UploadFormData {
    /// parameters (text data fields) to be included in the form HTTP body.
    let parameters: [String: String]
    /// files to be included in the form HTTP body.
    let files: [UploadFile]
}
