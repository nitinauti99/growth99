//
//  ChatBotTemplateViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 11/03/23.
//

import Foundation

protocol ChatBotTemplateViewModelProtocol {
    func getChatBotTemplateList()
    func getChatBotTemplateListDataAtIndex(index: Int) -> ChatBotTemplateModel?
    func setChatBotTemplateDeault(templateId: Int, param: [String: Any])

    var getChatBotTemplateListData: [ChatBotTemplateModel] { get }
    var getChatDefaultBotTemplateData: ChatBotTemplateModel? { get }
}

class ChatBotTemplateViewModel {
    var delegate: ChatBotTemplateViewControllerProtocol?
    
    var chatBotTemplateData: [ChatBotTemplateModel] = []
    var chatDefaultBotTemplateData: ChatBotTemplateModel?

    init(delegate: ChatBotTemplateViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getChatBotTemplateList() {
        self.requestManager.request(forPath: ApiUrl.chatBotTemplates, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[ChatBotTemplateModel], GrowthNetworkError>) in
            switch result {
            case .success(let chatBotTemplateData):
                self.chatBotTemplateData = chatBotTemplateData
                self.getDefaultChatBotTemplate()
                self.delegate?.chatBotTemplateListReceivedSuccefully()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    

    func getChatBotTemplateListDataAtIndex(index: Int)-> ChatBotTemplateModel? {
        return self.chatBotTemplateData[index]
    }
    
    func getDefaultChatBotTemplate(){
        for item in self.chatBotTemplateData {
            if item.defaultTemplate == true {
                self.chatDefaultBotTemplateData = item
            }
        }
    }
    
    func setChatBotTemplateDeault(templateId: Int, param: [String: Any]) {
        let finaleURL = ApiUrl.chatBotTsSetDefaultemplates.appending("\(templateId)/default")
        self.requestManager.request(forPath: finaleURL, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: param, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.setChatBotTemplateSuccefully()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

}

extension ChatBotTemplateViewModel: ChatBotTemplateViewModelProtocol {
  
    var getChatBotTemplateListData: [ChatBotTemplateModel] {
        return self.chatBotTemplateData
    }
    
    var getChatDefaultBotTemplateData: ChatBotTemplateModel? {
        return self.chatDefaultBotTemplateData
    }
    
}
