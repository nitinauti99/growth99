//
//  QuestionnaireSubmissionsViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 08/03/23.
//

import Foundation

protocol QuestionnaireSubmissionsViewModelModelProtocol {
    func getQuestionarieList(pateintId: Int)
    func getQuestionarieDataAtIndex(index: Int) -> QuestionnaireSubmissionsModel?
    func getQuestionarieFilterDataAtIndex(index: Int)-> QuestionnaireSubmissionsModel?
    var getQuestionarieDataList: [QuestionnaireSubmissionsModel] { get }
    var getQuestionarieFilterData: [QuestionnaireSubmissionsModel] { get }
}

class QuestionnaireSubmissionsViewModelModel {
    var delegate: QuestionnaireSubmissionsControllerProtocol?
    var questionarieData: [QuestionnaireSubmissionsModel] = []
    var questionarieFilterData: [QuestionnaireSubmissionsModel] = []
    
    init(delegate: QuestionnaireSubmissionsControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getQuestionarieList(pateintId: Int) {
        let finaleUrl = ApiUrl.questionnaireFormURL + "\(pateintId)" + "/questionnaire-submissions"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[QuestionnaireSubmissionsModel], GrowthNetworkError>) in
            switch result {
            case .success(let questionarieData):
                self.questionarieData = questionarieData
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    func getQuestionarieDataAtIndex(index: Int)-> QuestionnaireSubmissionsModel? {
        return self.questionarieData[index]
    }
    
    func getQuestionarieFilterDataAtIndex(index: Int)-> QuestionnaireSubmissionsModel? {
        return self.questionarieFilterData[index]
    }
}

extension QuestionnaireSubmissionsViewModelModel: QuestionnaireSubmissionsViewModelModelProtocol {
   
    var getQuestionarieDataList: [QuestionnaireSubmissionsModel] {
        return self.questionarieData
    }
    
    var getQuestionarieFilterData: [QuestionnaireSubmissionsModel] {
        return self.questionarieFilterData
    }
}
