//
//  Data+Append.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// An extension to the `Data` class that provides additional functionalities
/// for appending multiple `Data` objects to an existing `Data` instance.
extension Data {
    
    /// Appends the contents of an array of `Data` objects to the current `Data` instance.
    ///
    /// This method iterates through the provided array and appends each `Data` object
    /// to the receiver.
    /// 
    /// - Parameter data: An array of `Data` objects to append to the current instance.
    mutating func append(contentsOf data: [Data]) {
        data.forEach({ self.append($0) })
    }
    
}

