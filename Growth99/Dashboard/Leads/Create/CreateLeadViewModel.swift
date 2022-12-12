//
//  CreateLeadViewModel.swift
//  Growth99
//
//  Created by nitin auti on 04/12/22.
//

import Foundation

protocol CreateLeadViewModelProtocol {
    func createLead(questionnaireId: Int, patientQuestionAnswers: [String: Any])
    var LeadUserData: [leadModel]? { get }
    func leadDataAtIndex(index: Int) -> leadModel

}

class CreateLeadViewModel {
    var delegate: leadViewControllerProtocol?
    var LeadData =  [leadModel]()
    
    init(delegate: leadViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func createLead(questionnaireId: Int, patientQuestionAnswers:[String: Any]) {
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

extension CreateLeadViewModel: CreateLeadViewModelProtocol {

    var LeadUserData: [leadModel]? {
        return self.LeadData
    }
}
