//
//  UserCreateViewModel.swift
//  Growth99
//
//  Created by nitin auti on 28/12/22.
//

import Foundation

protocol UserCreateViewModelProtocol {
    func isValidFirstName(_ firstName: String) -> Bool
    func isValidLastName(_ lastName: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func isValidEmail(_ email: String) -> Bool
    func getUserData(userId: Int)
    var  getUserProfileData: UserProfile { get }
    func getallClinics()
    var  getAllClinicsData: [Clinics] { get }
    
    func getallServiceCategories(SelectedClinics: [Int])
    var  getAllServiceCategories: [Clinics] { get }
    
    func getallService(SelectedCategories: [Int])
    var  getAllService: [Clinics] { get }
    func updateProfileInfo(firstName: String, lastName:String, email: String, phone: String, roleId: Int, designation: String, clinicIds: Array<Int>, serviceCategoryIds: Array<Int>, serviceIds: Array<Int>, isProvider: Bool, description: String)
}

class UserCreateViewModel {
    var delegate: UserCreateViewControllerProtocool?
    var userData: UserProfile?
    var allClinics: [Clinics]?
    var allserviceCategories: [Clinics]?
    var allServices: [Clinics]?
    
    init(delegate: UserCreateViewControllerProtocool? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    /// get user Role
    func getUserData(userId: Int) {
        let url = ApiUrl.userProfile.appending("\(userId)")
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) { (result: Result<UserProfile, GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.userData = userData
                self.delegate?.userDataRecived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    /// get all clinics
    func getallClinics(){
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allClinics):
                self.allClinics = allClinics
                self.delegate?.clinicsRecived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    /// get call ServiceCategories for selected clinics
    func getallServiceCategories(SelectedClinics: [Int]){
        let finaleUrl = ApiUrl.serviceCategories + SelectedClinics.map { String($0) }.joined(separator: ",")
        self.requestManager.request(forPath: finaleUrl, method: .GET,headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allserviceCategories):
                self.allserviceCategories = allserviceCategories
                self.delegate?.serviceCategoriesRecived()
            case .failure(let error):
                if error.response?.statusCode == 500 {
                    self.delegate?.errorReceived(error: "Unable to load service category for selected clinic")
                }else{
                    self.delegate?.errorReceived(error: "Internal server error")
                }
            }
        }
    }
    
    /// get all Service from selected ServiceCategories ids
    func getallService(SelectedCategories: [Int]) {
        let finaleUrl = ApiUrl.service + SelectedCategories.map { String($0) }.joined(separator: ",")
        
        self.requestManager.request(forPath: finaleUrl, method: .GET,headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let categories):
                self.allServices = categories
                self.delegate?.serviceRecived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func updateProfileInfo(firstName: String, lastName: String, email: String, phone: String, roleId: Int, designation: String, clinicIds: Array<Int>, serviceCategoryIds: Array<Int>, serviceIds: Array<Int>, isProvider: Bool, description: String) {
        
        let parameter: [String : Any] = ["firstName": firstName,
                                         "lastName": lastName,
                                         "email": email,
                                         "phone": phone,
                                         "roleId": roleId,
                                         "clinicIds": clinicIds,
                                         "serviceCategoryIds": serviceCategoryIds,
                                         "serviceIds": serviceIds,
                                         "isProvider": isProvider,
                                         "description": description,
                                         "designation": designation
        ]
        let url = "https://api.growthemr.com/api/users"
        self.requestManager.request(forPath: url, method: .POST,headers: requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<UpdateUserProfile, GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                if userData.email == nil {
                    self.delegate?.errorReceived(error: "email already exists")
                }else{
                    self.delegate?.profileDataUpdated()
                }
                print("Successful Response", userData)
            case .failure(_):
                self.delegate?.profileDataUpdated()
            }
        }
    }
    
    
}

extension UserCreateViewModel : UserCreateViewModelProtocol {
    
    var getAllService: [Clinics] {
        return self.allServices ?? []
    }
    
    var getAllServiceCategories: [Clinics] {
        return self.allserviceCategories ?? []
    }
    
    var getUserProfileData: UserProfile {
        return self.userData!
    }
    
    var getAllClinicsData: [Clinics] {
        return self.allClinics ?? []
    }
    
    func isValidFirstName(_ firstName: String) -> Bool {
        let regex = Constant.Regex.nameWithoutSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: firstName)
    }
    
    func isValidLastName(_ lastName: String) -> Bool {
        let regex = Constant.Regex.nameWithoutSpace
        let isLastName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isLastName.evaluate(with: lastName)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let regex = Constant.Regex.phone
        let isPhoneNo = NSPredicate(format:"SELF MATCHES %@", regex)
        return isPhoneNo.evaluate(with: phoneNumber)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = Constant.Regex.email
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
