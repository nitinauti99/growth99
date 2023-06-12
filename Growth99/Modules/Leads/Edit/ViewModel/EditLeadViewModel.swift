//
//  EditLeadViewModel.swift
//  Growth99
//
//  Created by nitin auti on 13/12/22.
//

import Foundation

protocol EditLeadViewModelProtocol {
    func updateLead(questionnaireId: Int, name: String, email: String, phoneNumber: String, leadStatus: String)
    func updateLeadAmmount(questionnaireId: Int, ammount: Int)
    func getLeadList(page: Int, size: Int, statusFilter: String, sourceFilter: String, search: String, leadTagFilter: String)
    func leadDataAtIndex(index: Int) -> leadListModel
   
    func isValidFirstName(_ firstName: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func isValidEmail(_ email: String) -> Bool
    func isValidAmmount(_ ammount: String) -> Bool
   
    var leadUserData: [leadListModel]? { get }
}

class EditLeadViewModel {
    var delegate: EditLeadViewControllerProtocol?
    var leadData =  [leadListModel]()
    var leadPeginationListData: [leadListModel]?
    var totalCount: Int = 0

    init(delegate: EditLeadViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func updateLeadAmmount(questionnaireId: Int, ammount: Int) {
//        var ammountValue = Int()
//
//        if ammount == 0 {
//            ammountValue = nil
//        }else{
//            ammountValue = ammount
//        }
        
        let finaleUrl = ApiUrl.updateQuestionnaireSubmissionAmmount + "\(questionnaireId)" + "/amount?amount=" + "\(ammount)"
    
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.updateLeadAmmountSaved()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    func updateLead(questionnaireId: Int, name: String, email: String, phoneNumber: String, leadStatus: String) {
        let finaleUrl = ApiUrl.updateQuestionnaireSubmission + "\(questionnaireId)"
        
        let patientQuestionAnswers: [String: Any] = [
               "name": name,
               "email": email,
               "phoneNumber": phoneNumber,
               "leadStatus": leadStatus
        ]
        
        self.requestManager.request(forPath: finaleUrl, method: .PATCH, headers: self.requestManager.Headers(),task: .requestParameters(parameters: patientQuestionAnswers, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.LeadDataRecived(message: "Lead edited successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getLeadList(page: Int, size: Int, statusFilter: String, sourceFilter: String, search: String, leadTagFilter: String) {
        let urlParameter: Parameters = ["page": page,
                                        "size": size,
                                        "statusFilter": statusFilter,
                                        "sourceFilter": sourceFilter,
                                        "search": search,
                                        "leadTagFilter": leadTagFilter
        ]
        var components = URLComponents(string: ApiUrl.getLeadList)
        components?.queryItems = self.requestManager.queryItems(from: urlParameter)
        let url = (components?.url)!
        
        self.requestManager.request(forPath: url.absoluteString, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[leadListModel], GrowthNetworkError>) in
            
            switch result {
            case .success(let LeadData):
                self.setUpData(leadData: LeadData)
                self.delegate?.updateLeadDadaRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func setUpData(leadData: [leadListModel]) {
         for item in leadData {
            if item.totalCount == nil {
                self.leadPeginationListData?.append(item)
            }else{
                self.totalCount = item.totalCount ?? 0
            }
        }
    }

    func leadDataAtIndex(index: Int)-> leadListModel {
        return self.leadData[index]
    }
    
}

extension EditLeadViewModel: EditLeadViewModelProtocol {

    var leadUserData: [leadListModel]? {
        return self.leadData
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
    
    func isValidFirstName(_ firstName: String) -> Bool {
        let regex = Constant.Regex.nameWithSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: firstName)
    }
    
    func isValidAmmount(_ ammount: String) -> Bool {
        let regex = Constant.Regex.number
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: ammount)
    }

}
