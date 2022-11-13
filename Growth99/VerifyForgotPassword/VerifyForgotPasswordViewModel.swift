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
    func verifyForgotPasswordRequest(email: String, password: String, confirmPassword: String, confirmationPCode: String)
    func verifyChangePasswordRequest(email: String, oldPassword: String, newPassword: String, verifyNewPassword: String)
    func isValidPasswordAndCoinfirmationPassword(_ password: String, _ confirmPassword: String) -> Bool
    
}

class VerifyForgotPasswordViewModel {
    
    var delegate: VerifyForgotPasswordViewProtocol?
    var LogInData: LoginModel?
    
    init(delegate: VerifyForgotPasswordViewProtocol? = nil) {
        self.delegate = delegate
    }
    
    func verifyChangePasswordRequest(email: String, oldPassword: String, newPassword: String, verifyNewPassword: String) {
        struct responseType: Codable {}
        struct body: Codable {}
        AF.request(ApiRouter.sendRequestChangePassword(email, oldPassword, newPassword, verifyNewPassword).urlRequest).validate(statusCode: 200 ..< 600).responseData { response in
            if response.response?.statusCode == 200 {
                self.delegate?.LoaginDataRecived(responseMessage: "Password changes sucessfully")
            }else {
                self.delegate?.errorReceived(error: response.error?.localizedDescription ?? "")
            }
        }
    }
    
    func verifyForgotPasswordRequest(email: String,  password: String, confirmPassword: String, confirmationPCode: String) {
        struct responseType: Codable {}
        struct body: Codable {}
        AF.request(ApiRouter.sendRequesVerifyForgotPassword(email, password, confirmPassword, confirmationPCode).urlRequest).validate(statusCode: 200 ..< 299).responseData { response in
            if response.response?.statusCode == 200 {
                self.delegate?.LoaginDataRecived(responseMessage: "")
            }else {
                self.delegate?.errorReceived(error: response.error?.localizedDescription ?? "")
            }
        }
    }
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
