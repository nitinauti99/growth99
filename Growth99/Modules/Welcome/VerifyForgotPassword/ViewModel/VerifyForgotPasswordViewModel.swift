//
//  VerifyForgotPasswordViewModel.swift
//  Growth99
//
//  Created by nitin auti on 04/11/22.
//

import Foundation

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
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func verifyChangePasswordRequest(email: String, oldPassword: String, newPassword: String, verifyNewPassword: String) {
        
        let parameter: Parameters = [
            "userName": email,
            "oldPassword": oldPassword,
            "newPassword": newPassword,
            "confirmPassword": verifyNewPassword
        ]
        
        self.requestManager.request(forPath: ApiUrl.changeUserPassword, method: .POST, task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.delegate?.LoaginDataRecived(responseMessage: "Password changes sucessfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    
    
    func verifyForgotPasswordRequest(email: String,  password: String, confirmPassword: String, confirmationPCode: String) {
        let parameter: Parameters = [
            "username": email,
            "password": password,
            "confirmPassword": confirmPassword,
            "confirmationCode": confirmationPCode
           ]
       
        self.requestManager.request(forPath: ApiUrl.VerifyforgotPassword, method: .PUT,task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.LoaginDataRecived(responseMessage: "Password changed successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription )
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
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@\\$]).{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        if passwordPred.evaluate(with: password) && password.count >= 8 {
            return true
        }
        return false
    }
}
