//
//  ServiceManager.swift
//  Growth99
//
//  Created by nitin auti on 18/10/22.
//

import Foundation
import Alamofire

class ServiceManager {
    
    static func request<ResponseType: Decodable>(request: URLRequest, responseType: ResponseType.Type, completion: @escaping (Result<ResponseType, Error>) -> Void) {
        
        AF.request(request).validate().responseDecodable(of: responseType.self) { response in
            self.DataToJSON(data: response.data ?? Data())
            switch response.result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
   static func DataToJSON(data: Data) {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonData)
        } catch let myJSONError {
            print(myJSONError)
        }
    }
}
