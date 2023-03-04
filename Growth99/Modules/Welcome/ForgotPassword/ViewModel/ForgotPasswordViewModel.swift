//
//  ForgotPasswordViewModel.swift
//  Growth99
//
//  Created by nitin auti on 13/10/22.
//

import Foundation

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
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func sendRequestGetPassword(email: String) {
        let parameter: Parameters = ["email": email,
        ]
        self.requestManager.request(forPath: ApiUrl.forgotPassword, method: .GET,task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.LoaginDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription )
            }
        }
    }
}

extension ForgotPasswordViewModel : ForgotPasswordViewModelProtocol {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}
