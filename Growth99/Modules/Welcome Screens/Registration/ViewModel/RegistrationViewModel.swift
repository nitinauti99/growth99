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
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
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
                }else{
                    self.delegate?.LoaginDataRecived()
                }
                print("Successful Response", response)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension RegistrationViewModel : RegistrationViewModelProtocol {
   
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.count == 10 {
            return true
        }
        return false
    }
    
    func isValidPasswordAndReapeatPassword(_ password: String, _ repeatPassword: String) -> Bool {
        if password == repeatPassword {
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
