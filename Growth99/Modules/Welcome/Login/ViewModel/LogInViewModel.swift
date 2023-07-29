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
    func getImageData(url: String)
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
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getBussinessSelection(email: String) {
        let finaleURL = ApiUrl.getBussinessSelection.appending("byemail?email=\(email)")
        
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.publicHeader()) {  (result: Result<[BussinessSelectionModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.bussinessSelcetionData = userData
                self.delegate?.bussinessSelectionDataRecived()
            case .failure(let error):
                if error.response?.statusCode == 404 {
                    self.delegate?.errorReceived(error: "Internal server error")
                }else{
                    self.delegate?.errorReceived(error: GrowthNetworkError.errorDomain)
                }
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
        self.requestManager.request(forPath: ApiUrl.auth, method: .POST, task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) {  (result: Result<LoginModel, GrowthNetworkError>) in
            
            switch result {
            case .success(let logInData):
                self.LogInData = logInData
                self.user.isUserLoged = true
                self.setUpUserData()
                self.delegate?.LoaginDataRecived()
            case .failure(let error):
                if error.response?.statusCode == 401 {
                    self.delegate?.errorReceived(error: "Entered email or password is incorrect please enter your valid credentials.")
                } else {
                    self.delegate?.errorReceived(error: error.localizedDescription)
                }
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getImageData(url: String) {
        self.requestManager.request(forPath: url, method: .GET) { [weak self] result in
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
    
    func setUpUserData() {
        self.user.firstName = LogInData?.firstName
        self.user.lastName = LogInData?.lastName
        self.user.authToken = LogInData?.idToken
        self.user.refreshToken = LogInData?.refreshToken
        self.user.profilePictureUrl = LogInData?.logoUrl
        self.user.roles = LogInData?.roles
        self.user.Xtenantid = LogInData?.businessId
        self.user.userId = LogInData?.id
        self.user.userVariableId = UserRepository.shared.userId ?? 0
    }
}

extension LogInViewModel: LogInViewModelProtocol {
    
    var getBussinessSelcetionData: [BussinessSelectionModel] {
        return self.bussinessSelcetionData
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
