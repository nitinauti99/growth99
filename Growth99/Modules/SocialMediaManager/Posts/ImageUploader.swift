//
//  ImageUploader.swift
//  Growth99
//
//  Created by Nitin Auti on 03/06/23.
//

import Foundation
import UIKit

typealias HTTPHeaders = [String: String]

final class ImageUploader {

    let uploadImage: UIImage
    let parameters: Parameters?
    let boundary = UUID().uuidString
    let fieldName = "upload_image"
    let url: URL
    let method: String
    var headers: HTTPHeaders {
        return [ "Content-Type": "multipart/form-data; boundary=\(boundary)",
                   "Accept": "application/json",
                   "x-tenantid": UserRepository.shared.Xtenantid ?? String.blank,
                   "Authorization": "Bearer "+(UserRepository.shared.authToken ?? String.blank)
               ]
    }

    init(uploadImage: UIImage, parameters: [String: Any], url: URL, method: String) {
        self.uploadImage = uploadImage
        self.parameters = parameters
        self.url = url
        self.method = method
    }
    
    func uploadImage(completionHandler:@escaping(ImageUploadResult) -> Void) {
        
        let imageData = self.uploadImage.pngData() ?? Data()
      
        var request = URLRequest(url: url, method: method, headers: headers)
        request.httpBody = createHttpBody(binaryData: imageData, mimeType: "image/jpeg")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? 0
            if let data = data, case (200..<300) = statusCode {
                do {
                    let value = try Response(from: data, statusCode: statusCode)
                    completionHandler(.success(value))
                } catch {
                    let _error = ResponseError(statusCode: statusCode, error: AnyError(error))
                    completionHandler(.failure(_error))
                }
            }
        }
        task.resume()
    }
    
    private func createHttpBody(binaryData: Data, mimeType: String) -> Data {
        var postContent = "--\(boundary)\r\n"
        let fileName = "\(UUID().uuidString).jpeg"
        postContent += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        postContent += "Content-Type: \(mimeType)\r\n\r\n"

        var data = Data()
        guard let postData = postContent.data(using: .utf8) else { return data }
        data.append(postData)
        data.append(binaryData)

        if let parameters = parameters {
            var content = ""
            parameters.forEach {
                content += "\r\n--\(boundary)\r\n"
                content += "Content-Disposition: form-data; name=\"\($0.key)\"\r\n\r\n"
                content += "\($0.value)"
            }
            if let postData = content.data(using: .utf8) { data.append(postData) }
        }

        guard let endData = "\r\n--\(boundary)--\r\n".data(using: .utf8) else { return data }
        data.append(endData)
        return data
    }
}


typealias ImageUploadResult = Result<Response, ResponseError>

struct Response {

    let statusCode: Int
    let body: Parameters?

    init(from data: Data, statusCode: Int) throws {
        self.statusCode = statusCode
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? Parameters
        self.body = jsonObject
    }
}

struct ResponseError: Error {

    let statusCode: Int
    let error: AnyError
}

extension URLRequest {

    init(url: URL, method: String, headers: HTTPHeaders?) {
        self.init(url: url)
        httpMethod = method

        if let headers = headers {
            headers.forEach {
                setValue($0.1, forHTTPHeaderField: $0.0)
            }
        }
    }
}

struct AnyError: Error {

    let error: Error

    init(_ error: Error) {
        self.error = error
    }
}

extension Data {

    var mimeType: String? {
        var values = [UInt8](repeating: 0, count: 1)
        copyBytes(to: &values, count: 1)

        switch values[0] {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49, 0x4D:
            return "image/tiff"
        default:
            return nil
        }
    }
}
