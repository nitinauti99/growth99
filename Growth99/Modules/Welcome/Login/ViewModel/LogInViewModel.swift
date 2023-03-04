//
//  LogInViewModel.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import Foundation

protocol LogInViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func loginValidate(email: String, password: String)
    func getBusinessInfo(Xtenantid: Int)
    func getBussinessSelection(email: String)
    var getBussinessSelcetionData: [BussinessSelectionModel] { get}
}

class LogInViewModel {
    
    var delegate: LogInViewControllerProtocol?
    var LogInData: LoginModel?
    let user = UserRepository.shared
    var bussinessData: bussinessDetailInfoModel?
    var bussinessSelcetionData: [BussinessSelectionModel] = []

    init(delegate: LogInViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    
    func getBussinessSelection(email: String) {
        let finaleURL = ApiUrl.getBussinessSelection.appending("byemail?email=\(email)")
        
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.publicHeader()) {  (result: Result<[BussinessSelectionModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.bussinessSelcetionData = userData
                self.delegate?.bussinessSelectionDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getBusinessInfo(Xtenantid: Int) {
        let finaleUrl = ApiUrl.getBussinessInfo + "\(Xtenantid)"
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.publicHeader()) {  (result: Result<bussinessDetailInfoModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.bussinessData = response
                self.user.bussinessLogo = response.logoUrl
                self.user.bussinessName = response.name
                self.user.bussinessId = response.id
                self.user.subDomainName = response.subDomainName
                self.delegate?.businessDetailReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    func loginValidate(email: String, password: String) {
        let parameter: Parameters = ["email": email,
                                     "password": password,
                                     "businessId": self.user.bussinessId ?? 0
        ]
        
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
    
    
    func SetUpUserData() {
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

extension LogInViewModel: LogInViewModelProtocol {
    
    var getBussinessSelcetionData: [BussinessSelectionModel] {
        return self.bussinessSelcetionData
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
