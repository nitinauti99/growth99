//
//  NetworkManager.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import Foundation
import UIKit

class RequestManager: NetworkManager {

    override init(configuration: URLSessionConfiguration = .default, rootQueue: DispatchQueue? = nil, logger: Logger = OSLogger.shared, logSettings: LogSettings = .default, authenticator: Authenticator? = nil, pinningPolicy: PinningPolicy? = nil) {
        super.init(configuration: configuration, rootQueue: rootQueue, authenticator: authenticator, pinningPolicy: pinningPolicy)
    }

    convenience init() {
        self.init(configuration: .default)
    }

}


//public class NetworkManagerFile {
//    
//    enum ErrorTypes: String {
//        case domainError = "Domain Error"
//        case decodingError = "We are facing some technical glitch. Please try again later"
//        case noInternetError = "No internet connection. Please try again after some time"
//        case fetchBillError = "We can't fetch your bill right now, we'll get back to you when we have a response"
//    }
//    
//    enum HTTPMethod: String {
//        case post = "POST"
//        case put = "PUT"
//        case delete = "DELETE"
//        case get = "GET"
//        case patch = "PATCH"
//    }
//    
//    struct Body: Codable {}
//    
//    /// Api Base request called from each module
//    static func connect<RequestType: Codable, ResponseType: Decodable>(httpMethod: HTTPMethod, request: URLRequest, responseType: ResponseType.Type, body: RequestType, _ retrialCount: Int? = nil,completion: @escaping (Result<ResponseType, ErrorModel>) -> Void) {
//        
//        if !Reachability.isConnectedToNetwork() {
//            DispatchQueue.main.async {
//                if let retrialCount = retrialCount, retrialCount != 0 {
//                    NetworkManager.connect(httpMethod: httpMethod, request: request, responseType: responseType, body: Body(), retrialCount - 1) { result in
//                        completion(result)
//                    }
//                }else {
//                    completion(.failure(ErrorModel(message: ErrorTypes.noInternetError.rawValue)))
//                }
//            }
//            return
//        }
//        var request = request
//        request.httpMethod = httpMethod.rawValue
//       // request.addValue("123", forHTTPHeaderField: "X-TenantID")
//     //   request = APIRequest.addCommonAPIHeaders(request: request)
//        if httpMethod != .get {
//            request.httpBody = try! JSONEncoder().encode(body)
//        }
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            data?.printJSON()
//            
//            if let responseStatus = (response as? HTTPURLResponse)?.statusCode, responseStatus == 401 {
//                if let retrialCount = retrialCount, retrialCount != 0 {
//                    NetworkManager.updateAccessToken(httpMethod: httpMethod, request: request, responseType: responseType, body: Body(), retrialCount - 1) { result in
//                        completion(result)
//                    }
//                } else {
//                    NetworkManager.updateAccessToken(httpMethod: httpMethod, request: request, responseType: responseType, body: Body()) { result in
//                        completion(result)
//                    }
//                }
//                return
//            }
//            
//            guard let data = data, error == nil else {
//                if let error = error as NSError?, error.domain == NSURLErrorDomain {
//                    DispatchQueue.main.async {
//                        if let retrialCount = retrialCount, retrialCount != 0 {
//                            NetworkManager.connect(httpMethod: httpMethod, request: request, responseType: responseType, body: Body(), retrialCount - 1) { result in
//                                completion(result)
//                            }
//                        } else {
//                            retrialCount != nil ? completion(.failure(ErrorModel(message: ErrorTypes.fetchBillError.rawValue))) : completion(.failure(ErrorModel(message: ErrorTypes.domainError.rawValue)))
//                        }
//                    }
//                }
//                return
//            }
//            if (response as? HTTPURLResponse)?.statusCode == 200 {
//                do {
//                    let decodedResult = try JSONDecoder().decode(ResponseType.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.success(decodedResult))
//                    }
//                    return
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(.failure(ErrorModel(message: ErrorTypes.decodingError.rawValue)))
//                    }
//                    return
//                }
//            } else {
//                do {
//                    let responseError = try JSONDecoder().decode(ErrorDetails.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.failure(ErrorModel(message: responseError.errorMessage ?? "")))
//                    }
//                    return
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(.failure(ErrorModel(message: ErrorTypes.decodingError.rawValue)))
//                    }
//                    return
//                }
//            }
//        }
//        task.resume()
//    }
//    
//    /// Api Base request called wwithout model calls called from each module
//    static func connectWithNoResponseModel<RequestType: Codable>(httpMethod: HTTPMethod, request: URLRequest, body: RequestType, completion: @escaping (Result<[String: Any]?, ErrorModel>) -> Void) {
//        if !Reachability.isConnectedToNetwork() {
//            DispatchQueue.main.async {
//                completion(.failure(ErrorModel(message: ErrorTypes.noInternetError.rawValue)))
//            }
//            return
//        }
//        var request = request
//        request.httpMethod = httpMethod.rawValue
//        if httpMethod != .get {
//            request.httpBody = try! JSONEncoder().encode(body)
//        }
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let responseStatus = (response as? HTTPURLResponse)?.statusCode, responseStatus == 401 {
//                // Under development..
//                return
//            }
//            
//            guard let data = data, error == nil else {
//                if let error = error as NSError?, error.domain == NSURLErrorDomain {
//                    DispatchQueue.main.async {
//                        completion(.failure(ErrorModel(message: ErrorTypes.domainError.rawValue)))
//                    }
//                }
//                return
//            }
//            
//            if (response as? HTTPURLResponse)?.statusCode == 200 {
//                do {
//                    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                        DispatchQueue.main.async {
//                            completion(.failure(ErrorModel(message: ErrorTypes.decodingError.rawValue)))
//                        }
//                        return
//                    }
//                    DispatchQueue.main.async {
//                        completion(.success(json))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(.failure(ErrorModel(message: ErrorTypes.decodingError.rawValue)))
//                    }
//                }
//            } else {
//                do {
//                    let responseError = try JSONDecoder().decode(ErrorDetails.self, from: data)
//                    DispatchQueue.main.async {
//                        completion(.failure(ErrorModel(message: responseError.errorMessage ?? "")))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(.failure(ErrorModel(message: ErrorTypes.decodingError.rawValue)))
//                    }
//                }
//            }
//        }
//        task.resume()
//    }
//    
//    /// download  image form request called from each module
//    static func downloadImage(imageURL: URL, completion: @escaping (_ image: UIImage?) -> Void) {
//        let cache =  URLCache.shared
//        let request = URLRequest(url: imageURL)
//        DispatchQueue.global(qos: .userInitiated).async {
//            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
//                completion(image)
//            } else {
//                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, _) in
//                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
//                        let cachedData = CachedURLResponse(response: response, data: data)
//                        cache.storeCachedResponse(cachedData, for: request)
//                        completion(image)
//                    } else {
//                        completion(nil)
//                    }
//                }).resume()
//            }
//        }
//    }
//    
//    ///Refresh Token genrated from belwo request
//    static func updateAccessToken<RequestType: Codable, ResponseType: Decodable>(httpMethod: HTTPMethod, request: URLRequest, responseType: ResponseType.Type, body: RequestType, _ retrialCount: Int? = nil, completion: @escaping (Result<ResponseType, ErrorModel>) -> Void) {
//        NetworkManager().sendRefreshTokenRequest { (response) in
//            switch response {
//            case .success(let refreshToken):
//                UserRepository.shared.authToken = refreshToken.accessToken ?? ""
//                if let retrialCount = retrialCount, retrialCount != 0 {
//                    NetworkManager.connect(httpMethod: httpMethod, request: request, responseType: responseType, body: Body(), retrialCount - 1) { result in
//                        completion(result)
//                    }
//                } else {
//                    NetworkManager.connect(httpMethod: httpMethod, request: request, responseType: responseType, body: Body()) { result in
//                        completion(result)
//                    }
//                }
//            case .failure:
//                break
//               // EnvironmentManager.shared.delegate?.logout(isSessionExpired: true)
//            }
//        }
//    }
//    
//    static func connect<ResponseType: Decodable>(httpMethod: HTTPMethod, request: URLRequest, responseType: ResponseType.Type, completion: @escaping (Result<ResponseType, ErrorModel>) -> Void) {
//        NetworkManager.connect(httpMethod: httpMethod, request: request, responseType: responseType, body: Body()) { result in
//            completion(result)
//        }
//    }
//    
//}

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    }
}

struct ErrorModel: Error {
    let message: String
}

