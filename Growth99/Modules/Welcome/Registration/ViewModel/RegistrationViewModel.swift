//
//  RegistrationViewModel.swift
//  Growth99
//
//  Created by nitin auti on 13/10/22.
//

import Foundation

protocol RegistrationViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func isValidPasswordAndReapeatPassword(_ password: String, _ repeatPassword: String) -> Bool
    func registration(firstName: String, lastName: String, email: String, phoneNumber: String, password: String, repeatPassword: String, businesName: String, agreeTerms: Bool)
}

class RegistrationViewModel {
    
    var delegate: RegistrationViewControllerProtocol?
    
    init(delegate: RegistrationViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func registration(firstName: String, lastName: String, email: String, phoneNumber: String, password: String, repeatPassword: String, businesName: String, agreeTerms: Bool) {
        
        let parameter: Parameters = ["firstName": firstName,
                                     "lastName": lastName,
                                     "email": email,
                                     "phone": phoneNumber,
                                     "password": password,
                                     "confirmPassword": repeatPassword,
                                     "businessName": businesName,
                                     "agreeTerms": agreeTerms
        ]
        
        self.requestManager.request(forPath: ApiUrl.register, method: .POST,task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 400 {
                    self.delegate?.errorReceived(error: "There is some error creating account")
                } else {
                    self.delegate?.LoaginDataRecived()
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension RegistrationViewModel : RegistrationViewModelProtocol {
   
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phone = NSPredicate(format:"SELF MATCHES %@", Constant.Regex.phone)
        return phone.evaluate(with: phoneNumber)
    }
    
    func isValidPasswordAndReapeatPassword(_ password: String, _ repeatPassword: String) -> Bool {
        if password == repeatPassword {
            return true
        }
        return false
    }
   
    func isValidEmail(_ email: String) -> Bool {
        let emailPred = NSPredicate(format:"SELF MATCHES %@", Constant.Regex.email)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", Constant.Regex.password)
        if passwordPred.evaluate(with: password) && password.count >= 8 {
            return true
        }
        return false
    }
    
}
