//
//  ImageUplodingServiceManager.swift
//  Growth99
//
//  Created by Nitin Auti on 25/08/23.
//

import Foundation
typealias HTTPHeaders = [String: String]
typealias ImageUploadResult = Result<Response, ResponseError>

class ImageUplodManager {
    let uploadImage: UIImage
    let parameters: Parameters?
    let boundary = UUID().uuidString
    let fileName: String
    let url: URL
    let method: String
    var headers: HTTPHeaders {
        return [ "Content-Type": "multipart/form-data; boundary=\(boundary)",
                 "Accept": "application/json",
                 "x-tenantid": UserRepository.shared.Xtenantid ?? String.blank,
                 "Authorization": "Bearer "+(UserRepository.shared.authToken ?? String.blank)
        ]
    }
    
    init(uploadImage: UIImage, parameters: [String: Any], url: URL, method: String, fileName: String) {
        self.uploadImage = uploadImage
        self.parameters = parameters
        self.url = url
        self.method = method
        self.fileName = fileName
    }
    
    func uploadImage(completionHandler:@escaping(ImageUploadResult) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields =  headers
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        for (key, value) in self.parameters ?? [:] {
            data.append(contentsOf: "--\(boundary)\r\n" .data(using: .utf8)!)
            data.append(contentsOf: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" .data(using: .utf8)!)
            data.append(contentsOf: "\(value)\r\n" .data(using: .utf8)!)
        }
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
       
        data.append("Content-Disposition: form-data; name=\"\(fileName)\"; filename=\"\(self.uploadImage)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
       
        data.append(self.uploadImage.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        print("data .....", data)
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? 0
            if let data = data {
                switch statusCode {
                case 200:
                    do {
                        let value = try Response(from: data, statusCode: statusCode)
                        completionHandler(.success(value))
                    } catch {
                        let _error = ResponseError(statusCode: statusCode, error: AnyError(error))
                        completionHandler(.failure(_error))
                    }
                default:
                    do {
                        let value = try Response(from: data, statusCode: statusCode)
                        completionHandler(.success(value))
                    } catch {
                        let _error = ResponseError(statusCode: statusCode, error: AnyError(error))
                        completionHandler(.failure(_error))
                    }
                }
            }
        }
        task.resume()
    }
}


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
