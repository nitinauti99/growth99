//
//  ServiceCallImageUpload.swift
//  Growth99
//
//  Created by Nitin Auti on 24/08/23.
//

import Foundation

//class ServiceCallImageUpload {
//    
//    let uploadImage: UIImage
//    let parameters: Parameters?
//    let boundary = UUID().uuidString
//    let fileName = "file"
//    let url: URL
//    let method: String
//    var headers: HTTPHeaders {
//        return [ "Content-Type": "multipart/form-data; boundary=\(boundary)",
//                   "Accept": "application/json",
//                   "x-tenantid": UserRepository.shared.Xtenantid ?? String.blank,
//                   "Authorization": "Bearer "+(UserRepository.shared.authToken ?? String.blank)
//               ]
//    }
//
//    init(uploadImage: UIImage, parameters: [String: Any], url: URL, method: String) {
//        self.uploadImage = uploadImage
//        self.parameters = parameters
//        self.url = url
//        self.method = method
//    }
//    
//    func uploadImageWithParameters(completionHandler:@escaping(ImageUploadResult) -> Void) {
//    
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields =  headers
//        
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        var data = Data()
//        
//        for (key, value) in self.parameters ?? [:] {
//            data.append("--\(boundary)\r\n".data(using: .utf8)!)
//            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//            data.append("\(value)\r\n".data(using: .utf8)!)
//        }
//        
//        // Image data
//        if let image = UIImage(named: "your_image_filename") {
//            if let imageData = image.jpegData(compressionQuality: 0.8) {
//                data.append("--\(boundary)\r\n".data(using: .utf8)!)
//                data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
//                data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//                data.append(imageData)
//                data.append("\r\n".data(using: .utf8)!)
//            }
//        }
//        
//        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        
//        request.httpBody = data
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
//            let statusCode = (urlResponse as? HTTPURLResponse)?.statusCode ?? 0
//            if let data = data {
//                switch statusCode {
//                case 200:
//                    do {
//                        let value = try Response(from: data, statusCode: statusCode)
//                        completionHandler(.success(value))
//                    } catch {
//                        let _error = ResponseError(statusCode: statusCode, error: AnyError(error))
//                        completionHandler(.failure(_error))
//                    }
//                default:
//                    do {
//                        let value = try Response(from: data, statusCode: statusCode)
//                        completionHandler(.success(value))
//                    } catch {
//                      let _error = ResponseError(statusCode: statusCode, error: AnyError(error))
//                      completionHandler(.failure(_error))
//                  }
//                }
//            }
//        }
//        task.resume()
//    }
//}
