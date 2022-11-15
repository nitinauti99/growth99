//
//  NetworkRequestManager.swift
//  Growth99
//
//  Created by nitin auti on 15/11/22.
//

import Foundation
import Alamofire

class NetworkRequestManager: NSObject {
    
      static let shared = NetworkRequestManager()
      private override init(){}

       var parameters = Parameters()
       var headers = HTTPHeaders()
       var method: HTTPMethod!
       var url :String! = ""
       var encoding: ParameterEncoding! = JSONEncoding.default
    
    init(url: String?, parameters: [String:Any] = [:], headers: [String: String] = [:], method: HTTPMethod = .post, isJSONRequest: Bool = true) {
            super.init()
           parameters.forEach{self.parameters.updateValue($0.value, forKey: $0.key)}
           headers.forEach({self.headers.add(name: $0.key, value: $0.value)})
         
            guard let url = url else {
                return
            }
            self.url = url
           
            if !isJSONRequest{
                encoding = URLEncoding.default
            }
            self.method = method
        
            print("Service: \(self.url ?? "") \n data: \(parameters)")
        }
  
    func executeQuery<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
            AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData (completionHandler: {response in
                switch response.result {
                case .success(let res):
                    if let code = response.response?.statusCode {
                        switch code {
                        case 200...299:
                            do {
                                completion(.success(try JSONDecoder().decode(T.self, from: res)))
                            } catch let error {
                                print(String(data: res, encoding: .utf8) ?? "nothing received")
                                completion(.failure(error))
                            }
                        default:
                         let error = NSError(domain: response.debugDescription, code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
        })
    }
    
    func Headers()-> [String:String] {
        return ["Authorization": "Bearer " + (UserRepository.shared.authToken ?? ""),
                "Content-Type":  "application/json",
                "x-tenantid":    UserRepository.shared.Xtenantid ?? ""
        ]
    }
}

