//
//  leadDetailViewModel.swift
//  Growth99
//
//  Created by nitin auti on 21/12/22.
//

import Foundation

protocol FillQuestionarieViewModelProtocol {
    func getQuestionnaireData(pateintId: Int,  questionnaireId: Int)
    func getQuestionnaireListAtIndex(index: Int)-> PatientQuestionAnswersList?
    func createQuestionnaireForPateint(patientQuestionAnswers: [String: Any])
    func isValidTextFieldData(_ textField: String, regex: String) -> Bool
   
    var getQuestionnaireData: [PatientQuestionAnswersList]? { get }
    var getQuestionnaireDetailInfo: QuestionnaireList? { get }
}

class FillQuestionarieViewModel {
    var leadData =  [leadListModel]()
    
    var getQuestionnaireList = [PatientQuestionAnswersList]()
    var getQuestionnairePatientQuestionChoicesList: [PatientQuestionChoices]?
    var questionnaireDetailInfo: QuestionnaireList?
    
    var delegate: FillQuestionarieViewControllerProtocol?
    
    init(delegate: FillQuestionarieViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getQuestionnaireData(pateintId: Int,  questionnaireId: Int) {
        let finaleUrl = ApiUrl.getPatientsQuestionnaire + "\(pateintId)" + "/questionnaire/" + "\(questionnaireId)" + "/questions"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) { (result: Result<QuestionnaireList, GrowthNetworkError>) in
            switch result {
            case .success(let list):
                self.getQuestionnaireList = list.patientQuestionAnswers ?? []
                self.delegate?.questionnaireListRecived()
                self.questionnaireDetailInfo = list
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getQuestionnaireListAtIndex(index: Int)-> PatientQuestionAnswersList? {
        return self.getQuestionnaireList[index]
    }
    
    func createQuestionnaireForPateint(patientQuestionAnswers:[String: Any]) {
        self.requestManager.request(forPath: ApiUrl.submitPatientQuestionnnaire, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: patientQuestionAnswers, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.questionareAdddedSuccessfully()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
}

extension FillQuestionarieViewModel: FillQuestionarieViewModelProtocol {
   
    var getQuestionnaireDetailInfo: QuestionnaireList? {
        return self.questionnaireDetailInfo!
    }

    var getQuestionnaireData: [PatientQuestionAnswersList]? {
        return self.getQuestionnaireList
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
