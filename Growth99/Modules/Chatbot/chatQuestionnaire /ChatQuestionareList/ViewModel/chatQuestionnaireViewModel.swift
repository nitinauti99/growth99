//
//  chatQuestionnaireViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

protocol chatQuestionnaireViewModelProtocol {
    func getchatQuestionnaire()
    func chatQuestionnaireDataAtIndex(index: Int) -> chatQuestionnaireModel?
    func chatQuestionnaireFilterDataAtIndex(index: Int)-> chatQuestionnaireModel?
    func filterData(searchText: String)
    func removeChatQuestionnaire(chatQuestionnaireId: Int)
    
    var getChatQuestionnaireData: [chatQuestionnaireModel] { get }
    var getChatQuestionnaireFilterListData: [chatQuestionnaireModel] { get }
}

class chatQuestionnaireViewModel {
    var delegate: chatQuestionnaireViewContollerProtocol?
    var chatQuestionnaireData: [chatQuestionnaireModel] = []
    var chatQuestionnaireFilterListData: [chatQuestionnaireModel] = []
    
    init(delegate: chatQuestionnaireViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getchatQuestionnaire() {
        self.requestManager.request(forPath: ApiUrl.chatQuestionare, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[chatQuestionnaireModel], GrowthNetworkError>) in
            switch result {
            case .success(let chatQuestionnaireData):
                self.chatQuestionnaireData = chatQuestionnaireData
                self.delegate?.ConsentsTemplatesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeChatQuestionnaire(chatQuestionnaireId: Int) {
        let finaleUrl = ApiUrl.removeConsents + "\(chatQuestionnaireId)"

        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.consentsRemovedSuccefully(mrssage: "chatQuestionnaire removed successfully")
                }else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "To Delete These chatQuestionnaire Form, Please remove it for the service attched")
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
        self.chatQuestionnaireFilterListData = (self.chatQuestionnaireData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func chatQuestionnaireFilterDataAtIndex(index: Int) -> chatQuestionnaireModel? {
        return self.chatQuestionnaireFilterListData[index]
    }
    
    func chatQuestionnaireDataAtIndex(index: Int)-> chatQuestionnaireModel? {
        return self.chatQuestionnaireData[index]
    }
}

extension chatQuestionnaireViewModel: chatQuestionnaireViewModelProtocol {
    
    var getChatQuestionnaireFilterListData: [chatQuestionnaireModel] {
        return self.chatQuestionnaireFilterListData
    }
    
    var getChatQuestionnaireData: [chatQuestionnaireModel] {
        return self.chatQuestionnaireData
    }
    
}
