//
//  leadDetailViewModel.swift
//  Growth99
//
//  Created by nitin auti on 21/12/22.
//

import Foundation

protocol FillQuestionarieViewModelProtocol {
    func getQuestionnaireId(pateintId: Int,  questionnaireId: Int)
    func createLead(patientQuestionAnswers: [String: Any])
    func leadDataAtIndex(index: Int) -> leadModel
    var leadUserData: [leadModel]? { get }
    var getQuestionnaireDataInfo: QuestionnaireList? { get }
    var leadUserQuestionnaireList: [PatientQuestionAnswersList]? { get }
    func leadUserQuestionnaireListAtIndex(index: Int)-> PatientQuestionAnswersList?
    func isValidTextFieldData(_ textField: String, regex: String) -> Bool
}

class FillQuestionarieViewModel {
    var delegate: FillQuestionarieViewControllerProtocol?
    var leadData =  [leadModel]()
    var questionnaireId = QuestionnaireId()
    var questionnaireList = [PatientQuestionAnswersList]()
    var questionnaireFilterList = [PatientQuestionAnswersList]()
    var getQuestionnaireData: QuestionnaireList?
    
    init(delegate: FillQuestionarieViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionnaireId(pateintId: Int,  questionnaireId: Int) {
        let finaleUrl = ApiUrl.getPatientsQuestionnaire + "\(pateintId)" + "/questionnaire/" + "\(questionnaireId)" + "/questions"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) { (result: Result<QuestionnaireList, GrowthNetworkError>) in
            switch result {
            case .success(let list):
                print(list)
                self.getQuestionnaireData = list
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

        self.requestManager.request(forPath: ApiUrl.submitPatientQuestionnnaire, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: patientQuestionAnswers, encoding: .jsonEncoding)) {  [weak self] result in
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
            self.questionnaireFilterList.append(item)
//            if item.hidden as? NSObject == NSNull() {
//
//            }
        }
    }
    
    func leadUserQuestionnaireListAtIndex(index: Int)-> PatientQuestionAnswersList? {
        return self.leadUserQuestionnaireList?[index]
    }
}

extension FillQuestionarieViewModel: FillQuestionarieViewModelProtocol {
  
    var getQuestionnaireDataInfo: QuestionnaireList? {
        return self.getQuestionnaireData
    }
    
    func isValidTextFieldData(_ textField: String, regex: String) -> Bool {
        if regex == "", textField.count > 0 {
           return true
        }
        let textFieldValidation = NSPredicate(format:"SELF MATCHES %@", regex)
        return textFieldValidation.evaluate(with: textField)
    }
   
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
