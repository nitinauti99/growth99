//
//  QuestionnaireTemplatesViewModel.swift
//  Growth99
//
//  Created by nitin auti on 10/02/23.
//

import Foundation

protocol QuestionnaireTemplateListViewModelProtocol {
    var getQuestionnaireTemplateListData: [QuestionnaireTemplatesModel] { get }
    var questionnaireTemplateFilterListData: [QuestionnaireTemplatesModel] { get }
    
    func getQuestionnaireTemplateList()
    func questionnaireTemplateDataAtIndex(index: Int) -> QuestionnaireTemplatesModel?
}

class QuestionnaireTemplateListViewModel {
    var delegate: QuestionnaireTemplateListViewControllerProtocol?
    var questionnaireTemplateListData: [QuestionnaireTemplatesModel] = []
    var questionnaireTemplateFilterData: [QuestionnaireTemplatesModel] = []
    
    init(delegate: QuestionnaireTemplateListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionnaireTemplateList() {
        self.requestManager.request(forPath: ApiUrl.questionnaireTemplatesList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[QuestionnaireTemplatesModel], GrowthNetworkError>) in
            switch result {
            case .success(let QuestionnaireTemplateData):
                self.questionnaireTemplateListData = QuestionnaireTemplateData
                self.delegate?.questionnaireTemplatesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func questionnaireTemplateDataAtIndex(index: Int)-> QuestionnaireTemplatesModel? {
        return self.questionnaireTemplateListData[index]
    }
}

extension QuestionnaireTemplateListViewModel: QuestionnaireTemplateListViewModelProtocol {
    
    var questionnaireTemplateFilterListData: [QuestionnaireTemplatesModel] {
        return self.questionnaireTemplateListData
    }
    
    var getQuestionnaireTemplateListData: [QuestionnaireTemplatesModel] {
        return self.questionnaireTemplateListData
    }
    
    
}
