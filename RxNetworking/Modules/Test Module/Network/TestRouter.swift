//
//  TestRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 20/03/2023.
//

import Foundation

enum TestRouter: Router {
    case test1
    var scheme: HTTPScheme {
        .https
    }
    var method: HTTPMethod {
        .post
    }
    var domain: String {
        "www.apimocha.com"
    }
    var path: String {
        "hi-world/test1"
    }
    var headers: [String: String] {
        ["Accept": "application/json",
         "Content-Type": "application/json"]
    }
    var parameters: [String: String]? {
        ["test": "hello"]
    }
    var body: [String: String]? {
        ["test": "hello"]
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}

enum TestUploadRouter: UploadRouter {
    case basic(accountId: String)
    case formData(accountId: String)
    var scheme: HTTPScheme {
        .https
    }
    var method: HTTPMethod {
        .post
    }
    var domain: String {
        "api.upload.io"
    }
    var path: String {
        switch self {
        case .basic(let accountId):
            return "v2/accounts/\(accountId)/uploads/binary"
        case .formData(let accountId):
            return "v2/accounts/\(accountId)/uploads/form_data"
        }
    }
    var headers: [String: String] {
        switch self {
        case .basic:
            return ["Authorization": "Bearer public_FW25b9ZFF26sbDfyj9zR8EsHbzA4",
                    "Content-Type": "image/png"]
        case .formData:
            return ["Authorization": "Bearer public_FW25b9ZFF26sbDfyj9zR8EsHbzA4"]
        }
        
    }
    var parameters: [String: String]? {
        nil
    }
    var body: [String: String]? {
        nil
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
