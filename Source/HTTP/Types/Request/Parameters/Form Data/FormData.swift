//
//  FormData.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

/// Represents the data for a multipart form request, which contains both parameters and files.
///
/// The `FormData` struct is designed to encapsulate all information needed for a multipart form request.
/// It includes both text parameters and file uploads, enabling flexible and efficient handling of form submissions.
public struct FormData {

    /// A unique boundary string used to separate form data fields in the request body.
    let boundary: String = "Boundary-\(UUID().uuidString)"

    /// An array of `FormParameter` objects representing the text parameters to be included in the form HTTP body.
    /// Each `FormParameter` typically includes the field name and its associated value.
    let parameters: [FormParameter]

    /// An array of `FormFile` objects representing the files to be included in the form HTTP body.
    /// Each `FormFile` includes metadata like file name, mime type, and content.
    let files: [FormFile]

    /// Initializes a new `FormData` object with the provided parameters and files.
    ///
    /// - Parameters:
    ///   - parameters: An array of `FormParameter` objects representing text fields in the form.
    ///   - files: An array of `FormFile` objects representing files to be uploaded.
    public init(parameters: [FormParameter], files: [FormFile]) {
        self.parameters = parameters
        self.files = files
    }
}
