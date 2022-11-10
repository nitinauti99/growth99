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
    var getUserProfileData:UserProfile { get }
}

class HomeViewModel {
    var delegate: HomeViewContollerProtocool?
    var userData: UserProfile?
    
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
    
    var getUserProfileData: UserProfile {
        return self.userData!
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




