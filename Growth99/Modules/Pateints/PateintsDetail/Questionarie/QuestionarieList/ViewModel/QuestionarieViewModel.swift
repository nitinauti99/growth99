//
//  QuestionarieViewModel.swift
//  Growth99
//
//  Created by nitin auti on 21/01/23.
//

import Foundation

protocol QuestionarieViewModelProtocol {
    func getQuestionarieList(pateintId: Int)
    func getQuestionarieDataAtIndex(index: Int) -> QuestionarieModel?
    func getQuestionarieFilterDataAtIndex(index: Int)-> QuestionarieModel?
    func filterData(searchText: String)
    var getQuestionarieDataList: [QuestionarieModel] { get }
    var getQuestionarieFilterData: [QuestionarieModel] { get }
}

class QuestionarieViewModel {
    var delegate: QuestionarieViewControllerProtocol?
    var questionarieData: [QuestionarieModel] = []
    var questionarieFilterData: [QuestionarieModel] = []
    
    init(delegate: QuestionarieViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getQuestionarieList(pateintId: Int) {
        let finaleUrl = ApiUrl.patientsQuestionnaire + "\(pateintId)" + "/questionnaire"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[QuestionarieModel], GrowthNetworkError>) in
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
    
    func filterData(searchText: String) {
        self.questionarieFilterData = (self.questionarieData.filter { $0.questionnaireName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() || String($0.questionnaireId ?? 0) == searchText })
    }
    
    func getQuestionarieDataAtIndex(index: Int)-> QuestionarieModel? {
        return self.questionarieData[index]
    }
    
    func getQuestionarieFilterDataAtIndex(index: Int)-> QuestionarieModel? {
        return self.questionarieFilterData[index]
    }
}

extension QuestionarieViewModel: QuestionarieViewModelProtocol {
   
    var getQuestionarieDataList: [QuestionarieModel] {
        return self.questionarieData
    }
    
    var getQuestionarieFilterData: [QuestionarieModel] {
        return self.questionarieFilterData
    }
}
