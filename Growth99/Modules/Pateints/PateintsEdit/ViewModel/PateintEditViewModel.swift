//
//  PateintEditViewModel.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.
//

import Foundation

protocol PateintEditViewModelProtocol {
    func getPateintList(pateintId: Int) 
    func updatePateintsDetail(patientsId: Int, parameters: [String:Any])
    func isFirstName(_ firstName: String) -> Bool
    func isLastName(_ lastName: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func isValidEmail(_ email: String) -> Bool
    func isGender(_ gender: String) -> Bool
    
    var getPateintEditData: PateintsEditDetailModel? { get }
}

class PateintEditViewModel {
    var delegate: PateintEditViewControllerProtocol?
    var pateintsDetailList: PateintsEditDetailModel?

    init(delegate: PateintEditViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getPateintList(pateintId: Int) {
        let finaleUrl = ApiUrl.patientsEditDetail + "\(pateintId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<PateintsEditDetailModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintList):
                self.pateintsDetailList = pateintList
                self.delegate?.recivedPateintDetail()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func updatePateintsDetail(patientsId: Int, parameters: [String:Any]) {
        let finaleUrl = ApiUrl.crearePatients.appending("/\(patientsId)")
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.pateintCreatedSuccessfully(responseMessage: "Pateint created succefully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension PateintEditViewModel: PateintEditViewModelProtocol{
   
    var getPateintEditData: PateintsEditDetailModel? {
        return self.pateintsDetailList
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

