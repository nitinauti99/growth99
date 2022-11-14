//
//  HomeViewModel.swift
//  Growth99
//
//  Created by nitin auti on 08/11/22.
//

import Foundation
import Alamofire

protocol HomeViewModelProtocol {
    func isValidFirstName(_ firstName: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func getUserData(userId: Int)
    var getUserProfileData: UserProfile { get }
    func getallClinics()
    var getAllClinicsData: [Clinics] { get }
    
    func getallServiceCategories(SelectedClinics: [Any])
    var getAllServiceCategories: [Clinics] { get }
   
    func getallService(SelectedCategories: [Any])
    var getAllService: [Clinics] { get }
}

class HomeViewModel {
    var delegate: HomeViewContollerProtocool?
    var userData: UserProfile?
    let service = NetworkingService.shared
    var allClinics: [Clinics]?
    var allserviceCategories: [Clinics]?
    var allServices: [Clinics]?

    init(delegate: HomeViewContollerProtocool? = nil) {
        self.delegate = delegate
    }
   
    func getUserData(userId: Int) {
        ServiceManager.request(request: ApiRouter.getRequestForUserProfile(userId).urlRequest, responseType: UserProfile.self) { result in
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
        ServiceManager.request(request: ApiRouter.getRequestForAllClinics.urlRequest, responseType: [Clinics].self) { result in
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
    
    func getallServiceCategories(SelectedClinics: [Any]){
        ServiceManager.request(request: ApiRouter.getRequesServiceCategoriesForSelectedClinics(SelectedClinics).urlRequest, responseType: [Clinics].self) { result in
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
    
    func getallService(SelectedCategories: [Any]) {
        ServiceManager.request(request: ApiRouter.getRequesServiceSelectedCategories(SelectedCategories).urlRequest, responseType: [Clinics].self) { result in
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
        if phoneNumber.count < 10 {
            return false
        }
        return true
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


struct parameters: Encodable {
    let email: String
    let password: String
}

