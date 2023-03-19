//
//  HomeViewModel.swift
//  Growth99
//
//  Created by nitin auti on 08/11/22.
//

import Foundation

protocol HomeViewModelProtocol {
    func isValidFirstName(_ firstName: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func getUserData(userId: Int)
    var getUserProfileData: UserProfile { get }
    func getallClinics()
    var getAllClinicsData: [Clinics] { get }
    
    func getallServiceCategories(SelectedClinics: [Int])
    var getAllServiceCategories: [Clinics] { get }
   
    func getallService(SelectedCategories: [Int])
    var getAllService: [Clinics] { get }
    func updateProfileInfo(firstName: String, lastName:String, email: String, phone: String, roleId: Int, designation: String, clinicIds: Array<Int>, serviceCategoryIds: Array<Int>, serviceIds: Array<Int>, isProvider: Bool, description: String)
}

class HomeViewModel {
    var delegate: HomeViewContollerProtocol?
    var userData: UserProfile?
    var allClinics: [Clinics]?
    var allserviceCategories: [Clinics]?
    var allServices: [Clinics]?
    
    init(delegate: HomeViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
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
        
    func getallServiceCategories(SelectedClinics: [Int]){
        let finaleUrl = ApiUrl.serviceCategories + SelectedClinics.map { String($0) }.joined(separator: ",")
        self.requestManager.request(forPath: finaleUrl, method: .GET,headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allserviceCategories):
                self.allserviceCategories = allserviceCategories
                self.delegate?.serviceCategoriesRecived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    
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
        let url = "https://api.growthemr.com/api/users/".appending("\(UserRepository.shared.userVariableId ?? 0)")
        
        self.requestManager.request(forPath: url, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<UpdateUserProfile, GrowthNetworkError>) in
          
            switch result {
            case .success(let userData):
                self.delegate?.profileDataUpdated()
                print("Successful Response", userData)
            case .failure(_ ):
                self.delegate?.errorReceived(error: GrowthNetworkError.invalidResponse.localizedDescription)
            }
        }
    }
    
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
    
}

extension HomeViewModel : HomeViewModelProtocol {
    
    func isValidFirstName(_ firstName: String) -> Bool {
        if firstName.count > 0 {
            return true
        }
        return false
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.count == 10 {
            return true
        }
        return false
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
