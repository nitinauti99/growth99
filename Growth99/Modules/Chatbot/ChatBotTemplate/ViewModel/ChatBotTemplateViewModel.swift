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
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
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
}

extension ChatBotTemplateViewModel: ChatBotTemplateViewModelProtocol {
  
    var getChatBotTemplateListData: [ChatBotTemplateModel] {
        return self.chatBotTemplateData
    }
    
    var getChatDefaultBotTemplateData: ChatBotTemplateModel? {
        return self.chatDefaultBotTemplateData
    }
    
}
