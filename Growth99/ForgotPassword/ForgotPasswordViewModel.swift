//
//  ForgotPasswordViewModel.swift
//  Growth99
//
//  Created by nitin auti on 13/10/22.
//

import Foundation
import Alamofire

protocol ForgotPasswordViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func sendRequestGetPassword(email: String)
}

class ForgotPasswordViewModel {
    
    var delegate: ForgotPasswordViewControllerProtocol?
    var LogInData: LoginModel?
    
    init(delegate: ForgotPasswordViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
   
    func sendRequestGetPassword(email: String) {
        struct responseType: Codable {}
        struct body: Codable {}
        AF.request(ApiRouter.sendRequestForgotPassword(email).urlRequest).validate(statusCode: 200 ..< 299).responseData { response in
                if response.response?.statusCode == 200 {
                    self.delegate?.LoaginDataRecived()
                }else {
                    self.delegate?.errorReceived(error: response.error?.localizedDescription ?? "")
                }
            }
        }
        
        
//        ServiceManager.request(httpMethod: .get, request: ApiRouter.sendRequestForgotPassword("nitinauti99@gmail.com").urlRequest, responseType: EmptyEntity.self, body: body()) { result in
//            switch result {
//            case .success(let loginData):
//                print(loginData)
//                self.delegate?.LoaginDataRecived()
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }

        
//        /// request with alamofire
//        struct Body: Codable {}
//        ServiceManager.request(httpMethod: .post, request: ApiRouter.getNewsList(email, password).urlRequest, responseType: LoginModel.self, body: Body()) { result in
//            switch result {
//            case .success(let logInData):
//                self.LogInData = logInData
//                self.delegate?.LoaginDataRecived()
//            case .failure(let error):
//                print(error)
//                self.delegate?.errorReceived(error: error.localizedDescription)
//            }
//        }
    }



extension ForgotPasswordViewModel : ForgotPasswordViewModelProtocol {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

struct EmptyEntity: Codable, EmptyResponse {
    static func emptyValue() -> EmptyEntity {
        return EmptyEntity.init()
    }
}


