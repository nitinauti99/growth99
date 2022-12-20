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
    func leadDataAtIndex(index: Int) -> leadModel
    var leadUserData: [leadModel]? { get }
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func isValidFirstName(_ firstName: String) -> Bool
    func isValidLastName(_ lastName: String) -> Bool
    func isValidMessage(_ message: String) -> Bool
    var leadUserQuestionnaireList: [PatientQuestionAnswersList]? { get }
    func leadUserQuestionnaireListAtIndex(index: Int)-> PatientQuestionAnswersList?
//    var leadUserQuestionnairefinalList: [PatientQuestionAnswersList]? { get }

}

class CreateLeadViewModel {
    var delegate: CreateLeadViewControllerProtocol?
    var leadData =  [leadModel]()
    var questionnaireId = QuestionnaireId()
    var questionnaireList = [PatientQuestionAnswersList]()
    var questionnaireFilterList = [PatientQuestionAnswersList]()

    init(delegate: CreateLeadViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionnaireId() {
        self.requestManager.request(forPath: ApiUrl.getQuestionnaireId, method: .GET, headers: self.requestManager.Headers()) { (result: Result<QuestionnaireId, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                print(data)
                self.questionnaireId = data
                self.delegate?.QuestionnaireIdRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    func getQuestionnaireList() {
        let finaleUrl = ApiUrl.getQuestionnaireList + "\(self.questionnaireId.id ?? 0)"
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) { (result: Result<QuestionnaireList, GrowthNetworkError>) in
            switch result {
            case .success(let list):
                print(list)
                self.questionnaireList = list.patientQuestionAnswers ?? []
                self.questionnaireFilterListArray()
                self.delegate?.QuestionnaireListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createLead(patientQuestionAnswers:[String: Any]) {
        let finaleUrl = ApiUrl.createLead + "\(String(describing: self.questionnaireId.id))"

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
    
    func leadDataAtIndex(index: Int)-> leadModel {
        return self.leadData[index]
    }
    
    func questionnaireFilterListArray() {
        for item in self.questionnaireList {
            if item.hidden == false {
                self.questionnaireFilterList.append(item)
            }
        }
    }
    
    func leadUserQuestionnaireListAtIndex(index: Int)-> PatientQuestionAnswersList? {
        return self.leadUserQuestionnaireList?[index]
    }
}

extension CreateLeadViewModel: CreateLeadViewModelProtocol {
   
//    var leadUserQuestionnairefinalList: [PatientQuestionAnswersList]? {
//        return self.questionnaireFilterList
//    }
    
   
    var leadUserQuestionnaireList: [PatientQuestionAnswersList]? {
        return self.questionnaireFilterList
    }

    var leadUserData: [leadModel]? {
        return self.leadData
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
