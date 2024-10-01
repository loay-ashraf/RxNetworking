//
//  HTTPMIMEType.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 24/03/2023.
//

/// This is a list of most common HTTP MIME types.
enum HTTPMIMEType: String {
    
    case aac = "audio/aac"
    case avif = "image/avif"
    case bmp = "image/bmp"
    case csv = "text/csv"
    case doc = "application/msword"
    case docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case gz = "application/gzip"
    case gif = "image/gif"
    case html = "text/html"
    case ico = "image/vnd.microsoft.icon"
    case jpeg = "image/jpeg"
    case json = "application/json"
    case mp3 = "audio/mpeg"
    case mp4 = "video/mp4"
    case mpeg = "video/mpeg"
    case png = "image/png"
    case pdf = "application/pdf"
    case ppt = "application/vnd.ms-powerpoint"
    case pptx = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    case rar = "application/vnd.rar"
    case rtf = "application/rtf"
    case sevenZ = "application/x-7z-compressed"
    case svg = "image/svg+xml"
    case tar = "application/x-tar"
    case txt = "text/plain"
    case wav = "audio/wav"
    case webp = "image/webp"
    case xls = "application/vnd.ms-excel"
    case xlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    case xml = "application/xml"
    case zip = "application/zip"
    
    /// Creates `HTTPMIMEType` instance.
    ///
    /// - Parameter fileExtension: file extention `String` ('.png', '.jpeg').
    init?(fileExtension: String) {
        switch fileExtension {
        case "aac": self = .aac
        case "avif": self = .avif
        case "bmp": self = .bmp
        case "csv": self = .csv
        case "doc": self = .doc
        case "docx": self = .docx
        case "gz": self = .gz
        case "gif": self = .gif
        case "html": self = .html
        case "ico": self = .ico
        case "jpg", "jpeg": self = .jpeg
        case "json": self = .json
        case "mp3": self = .mp3
        case "mp4": self = .mp4
        case "mpeg": self = .mpeg
        case "png": self = .png
        case "pdf": self = .pdf
        case "ppt": self = .ppt
        case "pptx": self = .pptx
        case "rar": self = .rar
        case "rtf": self = .rtf
        case "sevenZ": self = .sevenZ
        case "svg": self = .svg
        case "tar": self = .tar
        case "txt": self = .txt
        case "wav": self = .wav
        case "webp": self = .webp
        case "xls": self = .xls
        case "xlsx": self = .xlsx
        case "xml": self = .xml
        case "zip": self = .zip
        default: return nil
        }
    }
    
    /// Creates `HTTPMIMEType` instance.
    ///
    /// - Parameter fileExtension: file name `String` ('example.png', 'example.jpeg').
    init?(fileName: String) {
        guard let fileExtensionSubString = fileName.split(separator: ".").last else { return nil }
        let fileExtensionString = String(fileExtensionSubString)
        self.init(fileExtension: fileExtensionString)
    }
    
}
