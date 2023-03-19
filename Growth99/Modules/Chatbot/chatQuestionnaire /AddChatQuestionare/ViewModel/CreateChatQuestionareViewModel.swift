//
//  CreateChatQuestionareViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 07/03/23.
//

import Foundation

protocol CreateChatQuestionareViewModelProtocol {
    func createchatQuestionnaire(name: String)
    func updateChatQuestionnaire(chatquestionnaireId: Int, name: String)

    /// for edit flow
    func getChatquestionnaire(questionnaireId: Int)
    func getChatQuestionnaireQuestionList(QuestionId:Int)
    func removeChatQuestionnaireQuestionList(questionnaireId: Int ,questionId: Int)

    func chatQuestionnaireQuestionDataAtIndex(index: Int) -> ChatQuestionareListModel?
    func chatQuestionnaireQuestionFilterDataAtIndex(index: Int)-> ChatQuestionareListModel?
    func filterData(searchText: String)

    var getChatquestionnaireData: ChatQuestionareModel? { get }
    var getChatQuestionnaireQuestion: [ChatQuestionareListModel]? { get }
    var getChatQuestionnaireQuestionFilter: [ChatQuestionareListModel]? { get }

}

class CreateChatQuestionareViewModel {
    var delegate: CreateChatQuestionareViewControllerProtocol?
    
    var chatquestionnaireData: ChatQuestionareModel?
    var chatQuestionnaireQuestionData: [ChatQuestionareListModel]?
    var chatQuestionnaireQuestionfilterData: [ChatQuestionareListModel]?
    
    init(delegate: CreateChatQuestionareViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    /// api is used for create chat Questionnaire
    func createchatQuestionnaire(name: String){
        let parameters: Parameters = [
            "name": name,
        ]
        self.requestManager.request(forPath: ApiUrl.createChatQuestionnaire, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.saveChatQuestionaire(message:"chat Questionaire details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    /// api is used for update chat Questionnaire
    func updateChatQuestionnaire(chatquestionnaireId: Int, name: String){
        let parameters: Parameters = [
            "name": name,
        ]
        self.requestManager.request(forPath: ApiUrl.createChatQuestionnaire.appending("\(chatquestionnaireId)"), method: .PUT, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.saveChatQuestionaire(message:"chat Questionaire details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    /// Foe Edit  get  Chat Questionnaire
    func getChatquestionnaire(questionnaireId: Int){
        let finaleUrl = ApiUrl.getChatquestionnaire + "\(questionnaireId)"
        
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< ChatQuestionareModel, GrowthNetworkError>) in
            switch result {
            case .success(let chatquestionnaireData):
                self.chatquestionnaireData = chatquestionnaireData
                self.delegate?.chatquestionnaireDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getChatQuestionnaireQuestionList(QuestionId: Int){
        let finaleUrl = ApiUrl.getChatQuestionnaireQuestion.appending("\(QuestionId)/chatquestions")
        
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< [ChatQuestionareListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.chatQuestionnaireQuestionData = pateintsTagDict
                self.delegate?.chatQuestionnaireQuestionListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeChatQuestionnaireQuestionList(questionnaireId: Int ,questionId: Int){
        let finaleUrl = ApiUrl.removeChatQuestionnaireQuestion.appending("\(questionnaireId)/chatquestions/\(questionId)")
        
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.removedChatquestionnaireQuestionsuccessfully()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.chatQuestionnaireQuestionfilterData = (self.chatQuestionnaireQuestionData?.filter { $0.question?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func chatQuestionnaireQuestionFilterDataAtIndex(index: Int) -> ChatQuestionareListModel? {
        return self.getChatQuestionnaireQuestionFilter?[index]
    }
    
    func chatQuestionnaireQuestionDataAtIndex(index: Int)-> ChatQuestionareListModel? {
        return self.chatQuestionnaireQuestionData?[index]
    }
    
}

extension CreateChatQuestionareViewModel: CreateChatQuestionareViewModelProtocol {
   
    var getChatQuestionnaireQuestion: [ChatQuestionareListModel]? {
        return self.chatQuestionnaireQuestionData
    }
    
    var getChatQuestionnaireQuestionFilter: [ChatQuestionareListModel]? {
        return self.chatQuestionnaireQuestionfilterData
    }
   
    var getChatquestionnaireData: ChatQuestionareModel? {
        return chatquestionnaireData
    }
    
}
