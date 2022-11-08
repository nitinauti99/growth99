//
//  ApiEndPoints.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import Foundation

public enum ContentType: String {
    case key = "Content-Type", value = "application/json"
}

enum ApiRouter: URLRequestConvertible {
    
    case getLogin(String, String)
    case sendRequesRegistration(String, String, String, String, String, String, String, Bool)
    case sendRequestForgotPassword(String)
    case sendRequesVerifyForgotPassword(String, String, String, String)


    var stringValue: String {
        switch self {
        case .getLogin(_, _):
            return ApiUrl.auth
        case .sendRequesRegistration(_, _, _, _, _, _, _, _):
            return ApiUrl.register
        case .sendRequestForgotPassword(_):
            return ApiUrl.forgotPassword
        case .sendRequesVerifyForgotPassword(_, _, _, _):
            return ApiUrl.VerifyforgotPassword
        }
    }
    
    var parameters: [String : Any] {
           switch self {
           case .getLogin(let email, let password):
               return [
                   "email": email,
                   "password": password,
               ]
           case .sendRequesRegistration(let firstName, let lastName, let email, let phone, let password, let confirmPassword, let businessName, let agreeTerms):
               return [
//                   "firstName": firstName,
//                   "lastName": lastName,
//                   "email": email,
//                   "phone": phone,
//                   "password": password,
//                   "confirmPassword": confirmPassword,
//                   "businessName": businessName,
//                   "agreeTerms": agreeTerms,
//                   "address": "Punee Rd, Koloa, HI 96756, USA"
                   "firstName": "test",
                   "lastName": "test",
                   "email": "tes123gdtet@test.com",
                   "password": "Password1@!",
                   "confirmPassword": "Password1@!",
                   "phone": "1111111111",
                   "businessName": "test business 123",
                   "agreeTerms": true,
                   "address": "Geeding Str, Gratis, OH 45381, USA"
               ]
           case .sendRequestForgotPassword(let email):
               return ["username":email]
           case .sendRequesVerifyForgotPassword(let email, let password, let confirmPassword, let confirmationCode):
               return [
                "username":email,
                "password":password,
                "confirmPassword":confirmPassword,
                "confirmationCode":confirmationCode
               ]
           }
       }
    
    var urlRequest: URLRequest {
       switch self {
       case .getLogin(_, _) :
           let components = URLComponents(string: ApiUrl.auth)
           var request = URLRequest(url: (components?.url)!)
           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
           let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
           request.httpBody = jsonData
           request.method = .post
           return request
       case .sendRequesRegistration(_, _, _, _, _, _, _, _):
           let components = URLComponents(string: ApiUrl.register)
           var request = URLRequest(url: (components?.url)!)
           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
           let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
           request.httpBody = jsonData
           request.method = .post
           return request
       case .sendRequestForgotPassword(_):
           var components = URLComponents(string: ApiUrl.forgotPassword)
           components?.queryItems = self.queryItems(from: parameters)
           var request = URLRequest(url: (components?.url)!)
           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
           request.method = .get
           return request

       case .sendRequesVerifyForgotPassword(_, _, _, _):
           let components = URLComponents(string: ApiUrl.VerifyforgotPassword)
           var request = URLRequest(url: (components?.url)!)
           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
           let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
           request.httpBody = jsonData
           request.method = .put
           return request
       }
    }

}

protocol URLRequestConvertible {
    func queryItems(from params: [String: Any]) -> [URLQueryItem]
}

extension URLRequestConvertible {
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

