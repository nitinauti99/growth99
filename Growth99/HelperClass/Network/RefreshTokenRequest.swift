//
//  RefreshTokenRequest.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import Foundation

//extension NetworkManager {
//    
//    /// refresh token api implementaion
//    public func sendRefreshTokenRequest(_ refreshTokenCompletion: @escaping (Result<RefreshTokenReesponse, NetworkError>) -> Void) {
//        
//        let apiEndPoint = "\(RefreshTokenConfiguration.baseUrl)api/v1/sso/refresh-token"
//        
//        guard let url =  URL(string: apiEndPoint) else {
//            refreshTokenCompletion(.failure(.badUrl))
//            return
//        }
//        
//        let token = UserRepository.shared.refreshToken ?? ""
//        let model = RefreshTokenRequestModel(refreshToken: token)
//        
//        return sendRequest(urlString: "\(url)", parameters: model.dictionary, httpMethod: .POST, completion: refreshTokenCompletion)
//    }
//    
//    /// add refresh Token header implentaion
//    func sendRequest<T: Codable>(urlString: String, parameters: [String: Any]?, httpMethod: HTTPMethod = .POST, requestModel: T? =  nil, programId: String? = nil, customerHash: String? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
//        guard let url =  URL(string: urlString) else {
//            completion(.failure(.badUrl))
//            return
//        }
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = httpMethod.rawValue
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        if let authToken = UserRepository.shared.authToken {
//            urlRequest.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//        }
//        if let programId = programId {
//            urlRequest.addValue(programId, forHTTPHeaderField: "Program-Id")
//            urlRequest.addValue(programId, forHTTPHeaderField: "X-ProgramID")
//        }
//        
//        if let customerHash = customerHash {
//            urlRequest.addValue(customerHash, forHTTPHeaderField: "customerId")
//        }
//        
//        if let parameters = parameters {
//            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
//        }
//        if let decodable = requestModel {
//            let encoder = JSONEncoder()
//            let data = try? encoder.encode(decodable)
//            urlRequest.httpBody =  data
//        }
//        urlRequest.cachePolicy = .reloadRevalidatingCacheData
//        loadRequest(request: urlRequest, completion: completion)
//    }
//    
//    ///Api Request for Refresh Token
//    public func loadRequest<T: Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
//        
//        if !Reachability.isConnectedToNetwork() {
//            DispatchQueue.main.async {
//                completion(.failure(.noInternetError))
//            }
//            return
//        }
//        
//        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
//            /* The following code is used for purpose to debug API response. It will work only in debug mode.
//             Debugger.printDictionary(dictionary: data?.dictionary)
//             */
//            
//            // refresh token
//            if let responseStatus = response?.httpStatusCode, responseStatus == 401 {
//                self?.getRefreshToken(request: request, completion: completion)
//                return
//            }
//            
//            if let error = error as NSError?, error.domain == NSURLErrorDomain {
//                DispatchQueue.main.async {
//                    completion(.failure(.domainError))
//                }
//                return
//            } else {
//                
//                if let response = response, let data = data, !response.isSuccess {
//                    do {
//                        let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
//                        let error = NetworkError.badAllErrorResponse(code: response.httpStatusCode, description: result.message, errorCode: result.errorCode, errorMessage: result.errorMessage, errorReason: result.errorReason, error: result.error, responseErrorCode: result.code)
//                        DispatchQueue.main.async {
//                            completion(.failure(error))
//                        }
//                        return
//                    } catch {
//                        DispatchQueue.main.async {
//                            completion(.failure(.decodingError))
//                        }
//                        return
//                    }
//                }
//                
//                if let data = data {
//                    do {
//                        let result = try JSONDecoder().decode(T.self, from: data)
//                        // MARK: - Cookie Management For Native Sign-In Flow
//                        DispatchQueue.main.async {
//                            completion(.success(result))
//                        }
//                    } catch {
//                        DispatchQueue.main.async {
//                            completion(.failure(.decodingError))
//                        }
//                    }
//                }
//            }
//        }.resume()
//    }
//    
//    ///Add New Token
//    func getRefreshToken<T: Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
//        
//        self.sendRefreshTokenRequest { [weak self] (response) in
//            switch response {
//            case .success(let refreshToken):
//                UserRepository.shared.authToken = refreshToken.accessToken ?? ""
//                var urlRequest = request
//                urlRequest.setValue("Bearer \(UserRepository.shared.authToken ?? "")", forHTTPHeaderField: "Authorization")
//                self?.loadRequest(request: urlRequest, completion: completion)
//            case .failure:
//                break
//               // EnvironmentManager.shared.delegate?.logout(isSessionExpired: true)
//            }
//        }
//    }
//}


//public extension URLResponse {
//
//    var isSuccess: Bool {
//        return httpStatusCode >= 200 && httpStatusCode < 300
//    }
//
//    var httpStatusCode: Int {
//        guard let statusCode = (self as? HTTPURLResponse)?.statusCode else {
//            return 0
//        }
//        return statusCode
//    }
//}


//public struct RefreshTokenReesponse: Codable {
//    public var accessToken: String?
//
//    enum CodingKeys: String, CodingKey {
//        case accessToken = "access_token"
//    }
//}

//struct RefreshTokenRequestModel: Codable {
//    let refreshToken: String
//}


//public class RefreshTokenConfiguration {
//    static var baseUrl: String = {
//        return EnvironmentManager.sharedInstance.baseUrl()
//    }()
//}
//
//
//public extension Data {
//    var dictionary: [String: Any]? {
//        return (try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)).flatMap { $0 as? [String: Any] }
//    }
//}
//
//public extension Encodable {
//    var dictionary: [String: Any]? {
//        guard let data = try? JSONEncoder().encode(self) else { return nil }
//        return (try? JSONSerialization.jsonObject(with: data, options: [])).flatMap { $0 as? [String: Any] }
//    }
//}
//
//public enum NetworkError: Error {
//    case noInternetError
//    case domainError
//    case decodingError
//    case badUrl
//    case business
//    case badResponse(code: Int?, description: String?)
//    case badAllErrorResponse(code: Int?, description: String?, errorCode: String?, errorMessage: String?, errorReason: String?, error: String?, responseErrorCode: ResponseErrorCode?)
//}
//
//public enum ClientId: String {
//    case key = "client_id"
//    case value = "TCP-IOS-APP"
//}
//
//public enum ErrorScreenType: String {
//    case fullscreen
//    case toast
//}
//
//public enum ClientSecret: String {
//    case key = "client_secret"
//    case value = "46810aed-1fa2-4935-b79c-c693172fdebb"
//}
//
//public enum ApiTrace: String {
//    case key = "Ocp-Apim-Trace"
//    case value = "true"
//}
//
//public enum ApimSubscriptionKey: String {
//    case key = "Ocp-Apim-Subscription-Key"
//    case value = "354d9be9edce479fbd797edc71ebf50b"
//}
//
//public enum UPIResponseCode: String {
//    case success    = "200"
//    case failure    = "400"
//    case onboarded  = "401"
//}
//
//public enum cookieKeys: String {
//    case session = "SESSION"
//}
//
//extension HTTPURLResponse {
//
//    var isValidResponse: Bool {
//        return (200...299).contains(self.statusCode)
//    }
//}
//
//
