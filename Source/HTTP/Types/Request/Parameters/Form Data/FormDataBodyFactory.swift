//
//  FormDataBodyFactory.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/10/2024.
//

import Foundation

class FormDataBodyFactory {
    
    private let lineBreak: String = "\r\n"
    
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
    
    private func makeParametersSection(_ parameters: [FormParameter], _ boundary: String) -> Data {
        let parametersSection = parameters.map({ self.makeParameterField($0, boundary) })
        var parametersSectionData = Data()
        parametersSectionData.append(contentsOf: parametersSection)
        return parametersSectionData
    }
    
    private func makeParameterField(_ parameter: FormParameter, _ boundary: String) -> Data {
        var field = Data()
        field.append("--\(boundary + lineBreak)")
        field.append("Content-Disposition: form-data; name=\"\(parameter.key)\"\(lineBreak + lineBreak)")
        field.append("\(parameter.value + lineBreak)")
        return field
    }
    
    private func makeFilesSection(_ files: [FormFile], _ boundary: String) -> Data {
        let filesSection: [Data] = files.compactMap({ self.makeFileField($0, boundary) })
        var filesSectionData = Data()
        filesSectionData.append(contentsOf: filesSection)
        return filesSectionData
    }
    
    private func makeFilesSection(_ files: [FormFile], _ boundary: String) -> InputStream {
        let filesSection: [InputStream] = files.compactMap({ self.makeFileField($0, boundary) })
        let filesSectionInputStream = ClusterInputStream(inputStreams: filesSection)
        return filesSectionInputStream
    }
    
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
