////
////  ApiEndPoints.swift
////  Growth99
////
////  Created by nitin auti on 08/10/22.
////
//
//import Foundation
//
//public enum ContentType: String {
//    case key = "Content-Type", value = "application/json"
//}
//
////public enum TokenType: String {
////    case Token = "Authorization", TokenValue = "Bearer \(UserRepository.shared.id)"
////}
//enum ApiRouter: URLRequestConvertible {
//    
//    case getLogin(String, String)
//    case sendRequesRegistration(String, String, String, String, String, String, String, Bool)
//    case sendRequestForgotPassword(String)
//    case sendRequesVerifyForgotPassword(String, String, String, String)
//    case sendRequestChangePassword(String, String, String, String)
//    case getRequestForUserProfile(Int)
//    case getRequestForAllClinics
//    case getRequesServiceCategoriesForSelectedClinics(Array<Any>)
//    case getRequesServiceSelectedCategories(Array<Any>)
//    case sendRequestForvacation(String, String, String, String, String, String)
//
//    var stringValue: String {
//        switch self {
//        case .getLogin(_, _):
//            return ApiUrl.auth
//        case .sendRequesRegistration(_, _, _, _, _, _, _, _):
//            return ApiUrl.register
//        case .sendRequestForgotPassword(_):
//            return ApiUrl.forgotPassword
//        case .sendRequesVerifyForgotPassword(_, _, _, _):
//            return ApiUrl.VerifyforgotPassword
//        case .sendRequestChangePassword(_, _, _, _):
//            return ApiUrl.changeUserPassword
//        case .sendRequestForvacation(_, _, _, _, _, _):
//            return ApiUrl.vacationSubmit
//        case .getRequestForUserProfile(_):
//            return ApiUrl.userProfile
//        case .getRequestForAllClinics:
//            return ""
//       case .getRequesServiceCategoriesForSelectedClinics(_ ):
//           return ApiUrl.serviceCategories
//       case .getRequesServiceSelectedCategories(_):
//          return  ApiUrl.serviceCategories
//        }
//    }
//    
//    var parameters: [String : Any] {
//           switch self {
//           case .getLogin(let email, let password):
//               return [
//                   "email": email,
//                   "password": password,
//               ]
//           case .sendRequesRegistration(let firstName, let lastName, let email, let phone, let password, let confirmPassword, let businessName, let agreeTerms):
//               return [
//                   "firstName": firstName,
//                   "lastName": lastName,
//                   "email": email,
//                   "phone": phone,
//                   "password": password,
//                   "confirmPassword": confirmPassword,
//                   "businessName": businessName,
//                   "agreeTerms": agreeTerms
//               ]
//           case .sendRequestForgotPassword(let email):
//               return ["username":email]
//           case .sendRequesVerifyForgotPassword(let email, let password, let confirmPassword, let confirmationCode):
//               return [
//                "username":email,
//                "password":password,
//                "confirmPassword":confirmPassword,
//                "confirmationCode":confirmationCode
//               ]
//           case .sendRequestChangePassword(let email, let oldPassword, let newPassword, let verifyNewPassword):
//               return [
//                "userName": email,
//                "oldPassword": oldPassword,
//                "newPassword": newPassword,
//                "confirmPassword": verifyNewPassword
//               ]
//           case .sendRequestForvacation(let clinicId, let providerId, let endDate, let startDate, let endTime, let startTime):
//               return [
//                "clinicId": clinicId,
//                "providerId": providerId,
//                "vacationSchedules": [
//                    ["endDate": endDate,
//                     "startDate": startDate,
//                     "time": [["endTime": endTime,
//                               "startTime": startTime]]
//                    ]
//                ]
//               ]
//           case .getRequestForUserProfile(_):
//               return [:]
//           case .getRequestForAllClinics:
//               return [:]
//           case .getRequesServiceCategoriesForSelectedClinics(let serviceCategories):
//               print((serviceCategories as NSArray).componentsJoined(by: ","))
//               return ["clinicId": (serviceCategories as NSArray).componentsJoined(by: ",")]
//           case .getRequesServiceSelectedCategories(let services):
//               print((services as NSArray).componentsJoined(by: ","))
//               return ["categoryId": (services as NSArray).componentsJoined(by: ",")]
//           }
//    }
//    
//    var urlRequest: URLRequest {
//       switch self {
//       case .getLogin(_, _) :
//           let components = URLComponents(string: ApiUrl.auth)
//           var request = URLRequest(url: (components?.url)!)
//           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//           let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//           request.httpBody = jsonData
//           request.method = .post
//           return request
//       case .sendRequesRegistration(_, _, _, _, _, _, _, _):
//           let components = URLComponents(string: ApiUrl.register)
//           var request = URLRequest(url: (components?.url)!)
//           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//           let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//           request.httpBody = jsonData
//           request.method = .post
//           return request
//       case .sendRequestForgotPassword(_):
//           var components = URLComponents(string: ApiUrl.forgotPassword)
//           components?.queryItems = self.queryItems(from: parameters)
//           var request = URLRequest(url: (components?.url)!)
//           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//           request.method = .get
//           return request
//       case .sendRequesVerifyForgotPassword(_, _, _, _):
//           let components = URLComponents(string: ApiUrl.VerifyforgotPassword)
//           var request = URLRequest(url: (components?.url)!)
//           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//           let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//           request.httpBody = jsonData
//           request.method = .put
//           return request
//       case .sendRequestChangePassword(_, _, _, _):
//           let components = URLComponents(string: ApiUrl.changeUserPassword)
//           var request = URLRequest(url: (components?.url)!)
//           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//           request.addValue("Bearer " + (UserRepository.shared.authToken ?? ""), forHTTPHeaderField: "Authorization")
//           request.addValue(UserRepository.shared.Xtenantid ?? "", forHTTPHeaderField: "x-tenantid")
//           let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//           request.httpBody = jsonData
//           request.method = .post
//           return request
//       case .sendRequestForvacation(_, _, _, _, _, _):
//           let components = URLComponents(string: ApiUrl.vacationSubmit)
//           var request = URLRequest(url: (components?.url)!)
//           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//           request.addValue("Bearer " + (UserRepository.shared.authToken ?? ""), forHTTPHeaderField: "Authorization")
//           request.addValue(UserRepository.shared.Xtenantid ?? "", forHTTPHeaderField: "x-tenantid")
//           let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//           request.httpBody = jsonData
//           request.method = .post
//           return request
//       case .getRequestForUserProfile(let userId):
//           let components = URLComponents(string: ApiUrl.userProfile.appending("\(userId)"))
//           var request = URLRequest(url: (components?.url)!)
//           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//           request.addValue("Bearer " + (UserRepository.shared.authToken ?? ""), forHTTPHeaderField: "Authorization")
//           request.addValue(UserRepository.shared.Xtenantid ?? "", forHTTPHeaderField: "x-tenantid")           
//           request.method = .get
//           return request
//       case .getRequestForAllClinics:
//           let components = URLComponents(string: ApiUrl.allClinics)
//           var request = URLRequest(url: (components?.url)!)
//           request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//           request.addValue("Bearer " + (UserRepository.shared.authToken ?? ""), forHTTPHeaderField: "Authorization")
//           request.addValue(UserRepository.shared.Xtenantid ?? "", forHTTPHeaderField: "x-tenantid")
//           request.method = .get
//           return request
//       case .getRequesServiceCategoriesForSelectedClinics(_ ):
//           var components = URLComponents(string: ApiUrl.serviceCategories)
//           components?.queryItems = parameters.map { element in URLQueryItem(name: element.key, value: element.value as? String) }
//                 var request = URLRequest(url: (components?.url)!)
//                 request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//                 request.addValue("Bearer " + (UserRepository.shared.authToken ?? ""), forHTTPHeaderField: "Authorization")
//                 request.addValue(UserRepository.shared.Xtenantid ?? "", forHTTPHeaderField: "x-tenantid")
//                 request.method = .get
//                 return request
//       case .getRequesServiceSelectedCategories(_):
//             var components = URLComponents(string: ApiUrl.service)
//             components?.queryItems = parameters.map { element in URLQueryItem(name: element.key, value: element.value as? String) }
//                 var request = URLRequest(url: (components?.url)!)
//                 request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
//                 request.addValue("Bearer " + (UserRepository.shared.authToken ?? ""), forHTTPHeaderField: "Authorization")
//                 request.addValue(UserRepository.shared.Xtenantid ?? "", forHTTPHeaderField: "x-tenantid")
//                 request.method = .get
//                 return request
//            }
//      }
//    
//    func numberOfDigits(_ num: Int) -> Int {
//        var number2 = 0
//        var number = num
//        while number > 0 {
//            number2 = number
//            number += number2
//        }
//        return number
//    }
//}
//
//protocol URLRequestConvertible {
//    func queryItems(from params: [String: Any]) -> [URLQueryItem]
//}
//
//extension URLRequestConvertible {
//    func queryItems(from params: [String: Any]) -> [URLQueryItem] {
//        let queryItems: [URLQueryItem] = params.compactMap { parameter -> URLQueryItem? in
//            var result: URLQueryItem?
//            if let intValue = parameter.value as? Int {
//                result = URLQueryItem(name: parameter.key, value: String(intValue))
//            } else if let stringValue = parameter.value as? String {
//                result = URLQueryItem(name: parameter.key, value: stringValue)
//            } else if let boolValue = parameter.value as? Bool {
//                let value = boolValue ? "1" : "0"
//                result = URLQueryItem(name: parameter.key, value: value)
//            } else {
//                return nil
//            }
//            return result
//        }
//        return queryItems
//    }
//}
//
