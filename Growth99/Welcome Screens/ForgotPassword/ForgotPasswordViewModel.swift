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
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
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

struct EmptyEntity: Codable, EmptyResponse {
    static func emptyValue() -> EmptyEntity {
        return EmptyEntity.init()
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
