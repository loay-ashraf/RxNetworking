//
//  String+SplitNameAndExtension.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/05/2024.
//

import Foundation

extension String {
    func splitNameAndExtension() -> (String, String) {
        var components = self.components(separatedBy: ".")
        guard components.count > 1 else { return (self, "") }
        let `extension` = components.removeLast()
        let name = components.joined(separator: ".")
        return (name, `extension`)
    }
}
