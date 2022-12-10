//
//  NetworkRequestManager.swift
//  Growth99
//
//  Created by nitin auti on 15/11/22.
//

import Foundation
import Alamofire

class RequestManager: NetworkManager {

    override init(configuration: URLSessionConfiguration = .default, rootQueue: DispatchQueue? = nil, logger: Logger = OSLogger.shared, logSettings: LogSettings = .default, authenticator: Authenticator? = nil, pinningPolicy: PinningPolicy? = nil) {
        super.init(configuration: configuration, rootQueue: rootQueue, authenticator: authenticator, pinningPolicy: pinningPolicy)
    }

    convenience init() {
        self.init(configuration: .default)
    }
    
    func Headers()-> [HTTPHeader] {
        return [.custom(key: "x-tenantid", value: UserRepository.shared.Xtenantid ?? String.blank),
             .custom(key: "Content-Type", value: "application/json"),
             .authorization("Bearer "+(UserRepository.shared.authToken ?? ""))]
     }
           
       /// sendding common header parameter from here
    func PublicHeaders()-> HTTPHeaders{
                  return ["Content-Type": "application/json"
           ] as HTTPHeaders
    }
    
    func queryItems(from params: [String: Any]) -> [URLQueryItem] {
         let queryItems: [URLQueryItem] = params.compactMap { parameter -> URLQueryItem? in
             var result: URLQueryItem?
             if let intValue = parameter.value as? Int {
                 result = URLQueryItem(name: parameter.key, value: String(intValue))
             } else if let stringValue = parameter.value as? String {
                 result = URLQueryItem(name: parameter.key, value: stringValue)
             } else if let boolValue = parameter.value as? Bool {
                 let value = boolValue ? "1" : "0"
                 result = URLQueryItem(name: parameter.key, value: value)
             } else {
                 return nil
             }
             return result
         }
         return queryItems
     }
    
}
