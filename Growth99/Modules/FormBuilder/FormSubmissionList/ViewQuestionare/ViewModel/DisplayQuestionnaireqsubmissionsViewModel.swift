//
//  DisplayQuestionnaireqsubmissionsViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 08/03/23.
//

import Foundation

protocol DisplayQuestionnaireqsubmissionsViewModelProtocol {
    func getDisplayFormQuestionnaire(questionnaireId: Int)
    func getQuestionnaireDataAtIndex(index: Int) -> QuestionAnswersModel?
    var getQuestionnaireData: [QuestionAnswersModel] { get }
    var getQuestionnaireName: String {get}
}

class DisplayQuestionnaireqsubmissionsViewModel {
    var delegate: DisplayQuestionnaireqsubmissionsViewContollerProtocol?
   
    var questionnaireData: [QuestionAnswersModel] = []
    var questionnaireName: String?
    
    init(delegate: DisplayQuestionnaireqsubmissionsViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getDisplayFormQuestionnaire(questionnaireId: Int) {
        let finaleURL = ApiUrl.questionnaireSubmissions.appending("\(questionnaireId)")
        
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<DisplayQuestionnaireqsubmissionsModel, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                self.questionnaireData = data.questionAnswers ?? []
                self.questionnaireName = data.questionnaireName ?? ""
                self.delegate?.questionnaireDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getQuestionnaireDataAtIndex(index: Int)-> QuestionAnswersModel? {
        return self.questionnaireData[index]
    }
    
}

extension DisplayQuestionnaireqsubmissionsViewModel: DisplayQuestionnaireqsubmissionsViewModelProtocol {
    
    var getQuestionnaireData: [QuestionAnswersModel] {
        return self.questionnaireData
    }
    
    var getQuestionnaireName: String {
        return self.questionnaireName ?? ""
    }

}
