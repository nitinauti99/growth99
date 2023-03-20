//
//  NetworkRequestManager.swift
//  Growth99
//
//  Created by nitin auti on 15/11/22.
//

import Foundation

class GrowthRequestManager: GrowthNetworkManager {

    override init(configuration: URLSessionConfiguration = .default, rootQueue: DispatchQueue? = nil, logger: Logger = OSLogger.shared, logSettings: LogSettings = .default, authenticator: Authenticator? = nil) {
        super.init(configuration: configuration, rootQueue: rootQueue, authenticator: authenticator)
    }

    convenience init() {
        self.init(configuration: .default)
    }
    
    func Headers()-> [HTTPHeader] {
        return [.custom(key: "x-tenantid", value: UserRepository.shared.Xtenantid ?? String.blank),
             .custom(key: "Content-Type", value: "application/json"),
             .authorization("Bearer "+(UserRepository.shared.authToken ?? String.blank))]
     }
    
    
    func publicHeader()-> [HTTPHeader] {
        return [
             .custom(key: "Content-Type", value: "application/json"),
             ]
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
    
    func getBaseUrl() -> String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            print("Path not found")
            return ""
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            print("Unable to get dictionary from path")
            return ""
        }
        
        if let config = dictionary.object(forKey: "Config") {
           
            guard let path = Bundle.main.path(forResource: config as? String, ofType: "plist") else {
                print("Path not found")
                return ""
            }
            
            guard let dictionary = NSDictionary(contentsOfFile: path) else {
                print("Unable to get dictionary from path")
                return ""
            }
            
            print(dictionary)

         return  dictionary.object(forKey: "baseUrl") as! String
        }
        
        return ""
    }
}
