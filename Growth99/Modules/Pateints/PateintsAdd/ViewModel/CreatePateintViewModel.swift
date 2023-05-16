//
//  CreatePateintViewModel.swift
//  Growth99
//
//  Created by nitin auti on 03/01/23.
//

import Foundation

protocol CreatePateintViewModelProtocol {
    func cratePateint(parameters: [String:Any])
    func isFirstName(_ firstName: String) -> Bool
    func isLastName(_ lastName: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func isValidEmail(_ email: String) -> Bool
    func isGender(_ gender: String) -> Bool
}

class CreatePateintViewModel {
    var delegate: CreatePateintViewContollerProtocol?

    init(delegate: CreatePateintViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func cratePateint(parameters: [String:Any]) {
        self.requestManager.request(forPath: ApiUrl.crearePatients, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.pateintCreatedSuccessfully(responseMessage: "Patient created successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
 
}

extension CreatePateintViewModel: CreatePateintViewModelProtocol {

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
    
    func isFirstName(_ firstName: String) -> Bool {
        let regex = Constant.Regex.nameWithoutSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: firstName)
    }
    
    func isLastName(_ lastName: String) -> Bool {
        let regex = Constant.Regex.nameWithoutSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: lastName)
    }
    
    func isGender(_ gender: String) -> Bool {
        let regex = Constant.Regex.nameWithoutSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: gender)
    }
}
