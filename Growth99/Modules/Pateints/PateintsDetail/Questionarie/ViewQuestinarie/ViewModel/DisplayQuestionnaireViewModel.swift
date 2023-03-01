//
//  DisplayQuestionnaireViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 01/03/23.
//

import Foundation
protocol DisplayQuestionnaireViewModelProtocol {
    func getDisplayQuestionnaire(patientId: Int,questionnaireId: Int)
    func getQuestionnaireDataAtIndex(index: Int) -> PatientQuestionAnswers?
    var getQuestionnaireData: [PatientQuestionAnswers] { get }
    var getQuestionnaireName: String {get}
}

class DisplayQuestionnaireViewModel {
    var delegate: DisplayQuestionnaireViewContollerProtocol?
    var questionnaireData: [PatientQuestionAnswers] = []
    var questionnaireName: String?
    
    init(delegate: DisplayQuestionnaireViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))

    func getDisplayQuestionnaire(patientId: Int,questionnaireId: Int) {
        let finaleURL = ApiUrl.patientsQuestionnaireDetail.appending("\(patientId)/questionnaire/\(questionnaireId)/questions")
        
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<DisplayQuestionnaireModel, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                self.questionnaireData = data.patientQuestionAnswers ?? []
                self.questionnaireName = data.questionnaireName ?? ""
                self.delegate?.questionnaireDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getQuestionnaireDataAtIndex(index: Int)-> PatientQuestionAnswers? {
        return self.questionnaireData[index]
    }
    
}

extension DisplayQuestionnaireViewModel: DisplayQuestionnaireViewModelProtocol {
    
    var getQuestionnaireData: [PatientQuestionAnswers] {
        return self.questionnaireData
    }
    
    var getQuestionnaireName: String {
        return self.questionnaireName ?? ""
    }

}
