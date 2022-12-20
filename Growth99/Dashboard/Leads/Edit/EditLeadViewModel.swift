//
//  EditLeadViewModel.swift
//  Growth99
//
//  Created by nitin auti on 13/12/22.
//

import Foundation

protocol EditLeadViewModelProtocol {
    func updateLead(questionnaireId: Int, patientQuestionAnswers: [String: Any])
    func leadDataAtIndex(index: Int) -> leadModel
    var LeadUserData: [leadModel]? { get }
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func isValidFirstName(_ firstName: String) -> Bool
    func isValidLastName(_ lastName: String) -> Bool
    func isValidMessage(_ message: String) -> Bool
}

class EditLeadViewModel {
    var delegate: EditLeadViewControllerProtocol?
    var LeadData =  [leadModel]()
    
    init(delegate: EditLeadViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func updateLead(questionnaireId: Int, patientQuestionAnswers:[String: Any]) {
        let finaleUrl = ApiUrl.createLead + "\(questionnaireId)"
        
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
        return self.LeadData[index]
    }
    
}

extension EditLeadViewModel: EditLeadViewModelProtocol {

    var LeadUserData: [leadModel]? {
        return self.LeadData
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
