//
//  FormDataBodyFactory.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

/// A factory class responsible for making `FormDataBody` instances for multipart form requests.
///
/// The `FormDataBodyFactory` class makes the body of a multipart form request,
/// including both text parameters and file uploads. It determines whether to use
/// raw data or input streams based on the size of the files involved.
final class FormDataBodyFactory {

    /// The line break sequence used to separate different parts of the multipart body.
    private let lineBreak: String = "\r\n"

    /// Creates a `FormDataBody` from the given `FormData`.
    ///
    /// This method checks whether any files require streaming and constructs
    /// either a data or stream-based body accordingly.
    ///
    /// - Parameter formData: The `FormData` object containing parameters and files.
    /// - Returns: A `FormDataBody` instance containing the constructed body.
    func make(formData: FormData) -> FormDataBody {
        let shouldUseStreams = formData.files.reduce(false, { $0 || $1.inputStream != nil })
        let parametersSection = makeParametersSection(formData.parameters, formData.boundary)
        
        if shouldUseStreams {
            let parametersSectionStream: InputStream = .init(data: parametersSection)
            let filesSectionStream: InputStream = makeFilesSection(formData.files, formData.boundary)
            let bodyFooterStream = "--\(formData.boundary)--\(lineBreak)".inputStream!
            let body  = ClusterInputStream(inputStreams: [parametersSectionStream, filesSectionStream, bodyFooterStream])
            return .init(inputStream: body)
        } else {
            let filesSection: Data = makeFilesSection(formData.files, formData.boundary)
            let bodyFooter = "--\(formData.boundary)--\(lineBreak)".data(using: .utf8)!
            var body = Data()
            body.append(parametersSection)
            body.append(filesSection)
            body.append(bodyFooter)
            return .init(data: body)
        }
    }

    /// Constructs the parameters section of the multipart body.
    ///
    /// - Parameters:
    ///   - parameters: An array of `FormParameter` objects to be included in the form body.
    ///   - boundary: The boundary string used to separate fields in the body.
    /// - Returns: The constructed parameters section as `Data`.
    private func makeParametersSection(_ parameters: [FormParameter], _ boundary: String) -> Data {
        let parametersSection = parameters.map({ self.makeParameterField($0, boundary) })
        var parametersSectionData = Data()
        parametersSectionData.append(contentsOf: parametersSection)
        return parametersSectionData
    }

    /// Constructs a single parameter field for the multipart body.
    ///
    /// - Parameters:
    ///   - parameter: A `FormParameter` object representing a text field.
    ///   - boundary: The boundary string used to separate fields in the body.
    /// - Returns: The constructed parameter field as `Data`.
    private func makeParameterField(_ parameter: FormParameter, _ boundary: String) -> Data {
        var field = Data()
        field.append("--\(boundary + lineBreak)")
        field.append("Content-Disposition: form-data; name=\"\(parameter.key)\"\(lineBreak + lineBreak)")
        field.append("\(parameter.value + lineBreak)")
        return field
    }

    /// Constructs the files section of the multipart body as `Data`.
    ///
    /// - Parameters:
    ///   - files: An array of `FormFile` objects to be included in the form body.
    ///   - boundary: The boundary string used to separate fields in the body.
    /// - Returns: The constructed files section as `Data`.
    private func makeFilesSection(_ files: [FormFile], _ boundary: String) -> Data {
        let filesSection: [Data] = files.compactMap({ self.makeFileField($0, boundary) })
        var filesSectionData = Data()
        filesSectionData.append(contentsOf: filesSection)
        return filesSectionData
    }

    /// Constructs the files section of the multipart body as an `InputStream`.
    ///
    /// - Parameters:
    ///   - files: An array of `FormFile` objects to be included in the form body.
    ///   - boundary: The boundary string used to separate fields in the body.
    /// - Returns: The constructed files section as an `InputStream`.
    private func makeFilesSection(_ files: [FormFile], _ boundary: String) -> InputStream {
        let filesSection: [InputStream] = files.compactMap({ self.makeFileField($0, boundary) })
        let filesSectionInputStream = ClusterInputStream(inputStreams: filesSection)
        return filesSectionInputStream
    }

    /// Constructs a single file field for the multipart body as `Data`.
    ///
    /// - Parameters:
    ///   - file: A `FormFile` object representing a file to be uploaded.
    ///   - boundary: The boundary string used to separate fields in the body.
    /// - Returns: The constructed file field as `Data`, or `nil` if the file data is not available.
    private func makeFileField(_ file: FormFile, _ boundary: String) -> Data? {
        var field = Data()
        guard let fileData = file.data else { return nil }
        field.append("--\(boundary + lineBreak)")
        field.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.name)\"\(lineBreak)")
        field.append("Content-Type: \(file.mimeType.rawValue + lineBreak + lineBreak)")
        field.append(fileData)
        field.append(lineBreak)
        return field
    }

    /// Constructs a single file field for the multipart body as an `InputStream`.
    ///
    /// - Parameters:
    ///   - file: A `FormFile` object representing a file to be uploaded.
    ///   - boundary: The boundary string used to separate fields in the body.
    /// - Returns: The constructed file field as an `InputStream`, or `nil` if the file input stream is not available.
    private func makeFileField(_ file: FormFile, _ boundary: String) -> InputStream? {
        var fieldStreams: [InputStream] = []
        guard let fileInputStream = file.inputStream else { return nil }
        fieldStreams.append("--\(boundary + lineBreak)".inputStream!)
        fieldStreams.append("Content-Disposition: form-data; name=\"\(file.key)\"; filename=\"\(file.name)\"\(lineBreak)".inputStream!)
        fieldStreams.append("Content-Type: \(file.mimeType.rawValue + lineBreak + lineBreak)".inputStream!)
        fieldStreams.append(fileInputStream)
        fieldStreams.append(lineBreak.inputStream!)
        let field = ClusterInputStream(inputStreams: fieldStreams)
        return field
    }
}
