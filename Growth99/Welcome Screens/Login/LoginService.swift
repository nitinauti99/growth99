//
//  LoginService.swift
//  Growth99
//
//  Created by nitin auti on 09/11/22.
//

import Foundation

//protocol LoginServiceProtocol {
//    func sendLoginRequest(email:String, password:String, completionHandler: @escaping (NSDictionary, Error?) -> ())
//
//}

//class LoginService : LoginServiceProtocol {
//    let networkingService = NetworkingService.shared
//
//    func sendLoginRequest(email: String, password: String, completionHandler: @escaping (NSDictionary, Error?) -> ()) {
//        /// network implementation
//        let params: [String: Any] = [
//            "email": email,
//            "password": password
//        ]
//
//        let request: requestModel = requestModel(RequestUrl: ApiUrl.auth,
//                                                 method: .post,
//                                                 parameters:params,
//                                                 headers:networkingService.PublicHeaders()
//        )
//
//        networkingService.request(RequestModule: request,success: ({ ( JSON) in
//            var responseDict = Dictionary<String,Any>()
//            responseDict["status"] = (JSON as? Dictionary<String,Any> ?? [:])["status"] ?? Constant.status.OK
//            responseDict["data"] = JSON as Any
//            let userInfo: [AnyHashable : Any] =
//            [
//                "messageDescription" :  NSLocalizedString((JSON as? Dictionary<String,Any> ?? [:])["messageDescription"] as? String ?? "", value: (JSON as? Dictionary<String,Any> ?? [:])["messageDescription"] as? String ?? "" , comment: ""),
//                "message" :NSLocalizedString((JSON as? Dictionary<String,Any> ?? [:])["message"] as? String ?? "", value: (JSON as? Dictionary<String,Any> ?? [:])["message"] as? String ?? "", comment: "")
//            ]
//            let error = NSError(domain: "", code: 0, userInfo:userInfo as? [String : Any])
//            completionHandler(responseDict as NSDictionary, error)
//
//        }), failure: ({ ( error ) in
//            if let err = error as? URLError, err.code == .notConnectedToInternet {
//                // no internet connection
//                print(err)
//                var responseDict = Dictionary<String,Any>()
//                responseDict["status"] = Constant.status.NETWORK_UNAVAILABLE
//                responseDict["data"] = NSNull()
//                completionHandler(responseDict as NSDictionary, error)
//            } else {
//                // other failures
//                var responseDict = Dictionary<String,Any>()
//                responseDict["status"] = Constant.status.REQUEST_FAIL
//                responseDict["data"] = NSNull()
//                completionHandler(responseDict as NSDictionary, error)
//            }
//        }))
//    }
//}
