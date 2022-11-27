//
//  LogInViewModel.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import Foundation
import Alamofire

protocol LogInViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func loginValidate(email: String, password: String)
}

class LogInViewModel {
    
    var delegate: LogInViewControllerProtocol?
    var LogInData: LoginModel?
    let user = UserRepository.shared
    
    init(delegate: LogInViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func loginValidate(email: String, password: String) {
        let parameter: Parameters = ["email": email,
                                     "password": password]
        
        self.requestManager.request(forPath: ApiUrl.auth, method: .POST,task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) {  (result: Result<LoginModel, GrowthNetworkError>) in
            
            switch result {
            case .success(let logInData):
                self.LogInData = logInData
                self.user.isUserLoged = true
                self.SetUpUserData()
                self.delegate?.LoaginDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func SetUpUserData(){
        self.user.firstName = LogInData?.firstName
        self.user.lastName = LogInData?.lastName
        self.user.authToken = LogInData?.idToken
        self.user.refreshToken = LogInData?.refreshToken
        self.user.profilePictureUrl = LogInData?.logoUrl
        self.user.roles = LogInData?.roles
        self.user.Xtenantid = LogInData?.businessId
        self.user.userId = LogInData?.id
    }
}

extension LogInViewModel : LogInViewModelProtocol {
    
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

//requet using normal url session
//NetworkManager.connect(httpMethod: .post, request: ApiRouter.getLogin("yogesh123@growth99.com", "Password1@!").urlRequest, responseType: LoginModel.self) { result in
//    switch result {
//    case .success(let loginData):
//        print(loginData)
//        self.delegate?.LoaginDataRecived()
//    case .failure(let error):
//        print(error.localizedDescription)
//    }
//}
