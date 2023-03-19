//
//  CreateLeadViewModel.swift
//  Growth99
//
//  Created by nitin auti on 04/12/22.
//

import Foundation

protocol CreateLeadViewModelProtocol {
    func getQuestionnaireId()
    func getQuestionnaireList()
    func createLead(patientQuestionAnswers: [String: Any])

    //    func leadDataAtIndex(index: Int) -> leadListModel
    func getLeadQuestionnaireListAtIndex(index: Int)-> PatientQuestionAnswersList?
    func isValidTextFieldData(_ textField: String, regex: String) -> Bool
    
    var getQuestionnaireListInfo: QuestionnaireList? { get }
    var getLeadUserQuestionnaireList: [PatientQuestionAnswersList]? { get }
}

class CreateLeadViewModel {
    var delegate: CreateLeadViewControllerProtocol?
  
    var questionnaireId: Int?
    var questionnaireListInfo:  QuestionnaireList?
    var questionnaireList = [PatientQuestionAnswersList]()
    var questionnaireFilterList = [PatientQuestionAnswersList]()

    init(delegate: CreateLeadViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    /// For get questionnaireId
    func getQuestionnaireId() {
        self.requestManager.request(forPath: ApiUrl.getQuestionnaireId, method: .GET, headers: self.requestManager.Headers()) { (result: Result<QuestionnaireId, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                print(data)
                self.questionnaireId = data.id ?? 0
                self.delegate?.QuestionnaireIdRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    /// get QuestionnaireList
    func getQuestionnaireList() {
        let finaleUrl = ApiUrl.getQuestionnaireList + "\(self.questionnaireId ?? 0)"
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) { (result: Result<QuestionnaireList, GrowthNetworkError>) in
            switch result {
            case .success(let list):
                print(list)
                self.questionnaireListInfo = list
                self.questionnaireList = list.patientQuestionAnswers ?? []
                self.questionnaireFilterListArray()
                self.delegate?.QuestionnaireListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    /// create lead
    func createLead(patientQuestionAnswers:[String: Any]) {
        let finaleUrl = ApiUrl.createLead + "\(String(describing: self.questionnaireId))"

        self.requestManager.request(forPath: finaleUrl, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: patientQuestionAnswers, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
//    func leadDataAtIndex(index: Int)-> leadListModel {
//        return self.leadData[index]
//    }
    
    func questionnaireFilterListArray() {
        for item in self.questionnaireList {
            if item.hidden == false {
                self.questionnaireFilterList.append(item)
            }
        }
    }
    
    func getLeadQuestionnaireListAtIndex(index: Int)-> PatientQuestionAnswersList? {
        return self.questionnaireFilterList[index]
    }
}

extension CreateLeadViewModel: CreateLeadViewModelProtocol {

    var getLeadUserQuestionnaireList: [PatientQuestionAnswersList]? {
        return self.questionnaireFilterList
    }

    var getQuestionnaireListInfo: QuestionnaireList? {
        return self.questionnaireListInfo
    }
    
    func isValidTextFieldData(_ textField: String, regex: String) -> Bool {
        if regex == "", textField.count > 0 {
           return true
        }
        let textFieldValidation = NSPredicate(format:"SELF MATCHES %@", regex)
        return textFieldValidation.evaluate(with: textField)
    }
    
    func isValidFirstName(_ firstName: String) -> Bool {
        if firstName.count > 0 {
            return true
        }
        return false
    }
    
    func isValidLastName(_ lastName: String) -> Bool {
        if lastName.count > 0 {
            return true
        }
        return false
    }
    
    func isValidMessage(_ message: String) -> Bool {
        if message.count > 0 {
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}
