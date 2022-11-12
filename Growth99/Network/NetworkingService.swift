//
//  networkingServiceViewContorller.swift
//  Moovet
//
//  Created by Nitin Auti on 04/02/20.
//  Copyright © 2020 Nitin Auti. All rights reserved.
//

import Foundation
import Alamofire
//import JWTDecode

struct requestModel {
	   var RequestUrl: String
	   var method: Alamofire.HTTPMethod
	   var parameters: [String: Any]?
	   var headers: HTTPHeaders
}
class NetworkingService: NSObject {
    
    static let shared = NetworkingService()
    private override init(){}
    
    /// api calling request using alamofire
    func request(requestUrl: String, method: Alamofire.HTTPMethod, parameters: [String: Any]?,  headers: HTTPHeaders,  success: @escaping ((_ responseObject: AnyObject?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
        
        AF.request(requestUrl, method: method, parameters: parameters,encoding:JSONEncoding.default ,headers: headers).response { response in
            
            let statusCode = response.response?.statusCode
            
            print("statusCode: \(statusCode ?? 200)")
            print("API request: \(response.request as Any)")
            print("API params: \(parameters  as AnyObject)")
            print("API response: \(response.value  as AnyObject)")
            
            switch response.result {
            case .success(_ ):
                if (statusCode == 401){
                    // self.requestForRefreshToken(RequestModule:RequestModule, success:success, failure:failure)
                } else {
                    success(response.value as AnyObject?)
                }
                
            case .failure(_):
                if (statusCode == 401){
                    // self.requestForRefreshToken(RequestModule:RequestModule, success:success, failure:failure)
                }
                let userInfo: [AnyHashable : Any] = [ "message" : "There was an error. Please try again later"]
                let error =  NSError(domain:"", code:URLError.notConnectedToInternet.rawValue, userInfo:userInfo as? [String : Any])
                success(error)
            }
        }
    }
    /// sendding common header parameter from here
    func Headers()->HTTPHeaders{
        return ["Authorization" : "Bearer "+(UserRepository.shared.authToken ?? ""),
                "Content-Type": "application/json",
                "x-tenantid": UserRepository.shared.Xtenantid ?? ""
        ] as HTTPHeaders
    }
    
    /// sendding common header parameter from here
    func PublicHeaders()->HTTPHeaders{
        return ["Content-Type": "application/json"
        ] as HTTPHeaders
    }
    
}

// checking internet connectivity 
class Connectivity {
		class var isConnectedToInternet:Bool {
			return NetworkReachabilityManager()!.isReachable
		}
	}

//extension NetworkingService {
//
//	// MARK: - Private - Refresh Tokens
//func requestForRefreshToken(RequestModule:requestModel, success: @escaping ((_ responseObject: AnyObject?) -> Void), failure: @escaping ((_ error: NSError?) -> Void)) {
//
//	let login: LoginModel = LoginModel.sharedInstance
//	let params : [String: Any] = [
//	   "userId" : login.getuserId()
//	 ]
//
//	  AF.request(Constants.url.TokenUrl,method:.post,parameters: params,encoding:JSONEncoding.default ,headers:self.headers()).responseJSON { response in
//
//			let statusCode = response.response?.statusCode
//
//			  print("statusCode: \(statusCode ?? 200)")
//			  print("API request: \(response.request as Any)")
//			  print("API response: \(response.value  as AnyObject)")
//
//			 switch response.result {
//				 case .success(_):
//
//					 let jsonData = response.value  as AnyObject
//					 let response = jsonData.value(forKey: "response") as? NSDictionary
//					 let tokenObject = response?.value(forKey: "tokenObject") as? NSDictionary
//	 // store data into model
//					 let login: LoginModel = LoginModel.sharedInstance
//					 let token  = TokenModel.sharedInstance
//					 token.accessToken = tokenObject?.value(forKey:"accessToken") as? String
//					 token.tokenType = tokenObject?.value(forKey:"tokenType") as? String
//					 token.apiSecretKey = tokenObject?.value(forKey:"apiSecretKey") as? String
//	 // get userid from token
//					 let jwt = try? decode(jwt: token.accessToken ?? "")
//					 let UserInfo = (jwt?.body) as NSDictionary? ?? [:]
//					 login.UserId = UserInfo.value(forKey:"sub") as? String ?? ""
//
//					var request: requestModel = RequestModule
//
//					 request.headers = ["Authorization" : "Bearer "+(TokenModel.sharedInstance.accessToken ?? ""),
//								 "Content-Type": "application/json",
//								 "secretKey": TokenModel.sharedInstance.apiSecretKey ?? "",
//					        ]
//
//				    self.request(RequestModule: request, success: success, failure: failure)
//
//			case .failure(_):
//                          if (statusCode == 401){
//
//						   }else if (!Connectivity.isConnectedToInternet){
//							 let userInfo: [AnyHashable : Any] = [
//									"message" : "Please check your internet connection"
//								 ]
//							 let error =  NSError(domain:"", code:URLError.notConnectedToInternet.rawValue, userInfo:userInfo as? [String : Any])
//							 failure(error)
//						   }else{
//								let userInfo: [AnyHashable : Any] = [
//									   "message" : "There was an error. Please try again later"
//									]
//								let error =  NSError(domain:"", code:URLError.notConnectedToInternet.rawValue, userInfo:userInfo as? [String : Any])
//								failure(error)
//						}
//				  }
//		   }
//	 }
//}
