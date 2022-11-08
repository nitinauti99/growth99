//
//  HomeViewModel.swift
//  Growth99
//
//  Created by nitin auti on 08/11/22.
//

import Foundation
import Alamofire

protocol HomeViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func loginValidate(email: String, password: String)
}

class HomeViewModel {
    
    var delegate: LogInViewControllerProtocol?
    var LogInData: LoginModel?
    let user = UserRepository.shared
    
    init(delegate: LogInViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
   
    func loginValidate(email: String, password: String) {
        struct Body: Codable {}
       
        ServiceManager.request(httpMethod: .post, request: ApiRouter.getLogin(email, password).urlRequest, responseType: LoginModel.self, body: Body()) { result in
            switch result {
            case .success(let logInData):
                self.LogInData = logInData
                self.user.isUserLoged = true
                self.SetUpUserData()
                self.delegate?.LoaginDataRecived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }

    func SetUpUserData(){
        self.user.firstName = LogInData?.firstName
        self.user.lastName = LogInData?.lastName
        self.user.authToken = LogInData?.accessToken
        self.user.refreshToken = LogInData?.refreshToken
        self.user.profilePictureUrl = LogInData?.logoUrl
        self.user.roles = LogInData?.roles
    }
}

extension HomeViewModel : HomeViewModelProtocol {
    
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




