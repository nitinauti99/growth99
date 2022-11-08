//
//  VerifyForgotPasswordViewModel.swift
//  Growth99
//
//  Created by nitin auti on 04/11/22.
//

import Foundation
import Alamofire

protocol VerifyForgotPasswordViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func verifyForgotPasswordRequest(email: String,  password: String, confirmPassword: String, confirmationPCode: String)
    func isValidPasswordAndCoinfirmationPassword(_ password: String, _ confirmPassword: String) -> Bool

}

class VerifyForgotPasswordViewModel {
        
    var delegate: VerifyForgotPasswordViewProtocol?
    var LogInData: LoginModel?
    
    init(delegate: VerifyForgotPasswordViewProtocol? = nil) {
        self.delegate = delegate
    }
       
   func verifyForgotPasswordRequest(email: String,  password: String, confirmPassword: String, confirmationPCode: String) {
        struct responseType: Codable {}
        struct body: Codable {}
        AF.request(ApiRouter.sendRequesVerifyForgotPassword(email, password, confirmPassword, confirmationPCode).urlRequest).validate(statusCode: 200 ..< 299).responseData { response in
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

extension VerifyForgotPasswordViewModel : VerifyForgotPasswordViewModelProtocol {
    
    func isValidPasswordAndCoinfirmationPassword(_ password: String, _ confirmPassword: String) -> Bool {
        if password == confirmPassword {
            return true
        }
        return false
    }
   
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^.*(?=.{8,})(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\\d)|(?=.*[!#$%&?]).*$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)

        if passwordPred.evaluate(with: password) && password.count >= 8 {
            return true
        }
        return false
    }
}

