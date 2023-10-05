//
//  DefaultNetworkAPIError.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 19/02/2023.
//

/// Default type used for decoding internal api error bodies.
public struct DefaultNetworkAPIError: NetworkAPIError {
    
    /// error message.
    let message: String
    
}
