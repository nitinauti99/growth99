//
//  QuestionnaireTemplatesViewModel.swift
//  Growth99
//
//  Created by nitin auti on 10/02/23.
//

import Foundation

protocol QuestionnaireTemplateListViewModelProtocol {
    var getQuestionnaireTemplateListData: [QuestionnaireTemplatesModel] { get }
    var getQuestionnaireTemplateFilterListData: [QuestionnaireTemplatesModel] { get }
    
    func getQuestionnaireTemplateList()
    func filterData(searchText: String)
    func removeQuestionnaire(questionnaireId: Int)
    func getqQuestionnaireTemplateDataAtIndex(index: Int) -> QuestionnaireTemplatesModel?
    func getQuestionnaireTemplateFilterDataAtIndex(index: Int) -> QuestionnaireTemplatesModel?
}

class QuestionnaireTemplateListViewModel {
    var delegate: QuestionnaireTemplateListViewControllerProtocol?
    var questionnaireTemplateListData: [QuestionnaireTemplatesModel] = []
    var questionnaireTemplateFilterListData: [QuestionnaireTemplatesModel] = []
    
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
    
    func removeQuestionnaire(questionnaireId: Int){
        let finaleUrl = ApiUrl.removeQuestionnaire + "\(questionnaireId)"

        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.questionnaireRemovedSuccefully(mrssage: "Consents removed successfully")
                }else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "To Delete These Consents Form, Please remove it for the service attched")
                }else{
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    func filterData(searchText: String) {
        self.questionnaireTemplateFilterListData = (self.questionnaireTemplateListData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        print(self.questionnaireTemplateFilterListData)
    }
    
    func getqQuestionnaireTemplateDataAtIndex(index: Int)-> QuestionnaireTemplatesModel? {
        return self.questionnaireTemplateListData[index]
    }
    
    func getQuestionnaireTemplateFilterDataAtIndex(index: Int)-> QuestionnaireTemplatesModel? {
        return self.questionnaireTemplateFilterListData[index]
    }
}

extension QuestionnaireTemplateListViewModel: QuestionnaireTemplateListViewModelProtocol {
    
    var getQuestionnaireTemplateFilterListData: [QuestionnaireTemplatesModel] {
        return self.questionnaireTemplateFilterListData
    }
    
    var getQuestionnaireTemplateListData: [QuestionnaireTemplatesModel] {
        return self.questionnaireTemplateListData
    }
}
