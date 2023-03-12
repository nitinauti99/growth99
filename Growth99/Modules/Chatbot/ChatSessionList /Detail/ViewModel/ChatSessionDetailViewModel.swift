//
//  ChatSessionDetailViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation

protocol ChatSessionDetailViewModelProtocol {
    func getChatSessionDetail(chatSessionId: Int)
    func getChatSessionDetailDataAtIndex(index: Int) -> ChatSessionDetailModel?
    
    var getChatSessionDetailData: [ChatSessionDetailModel] { get }
}

class ChatSessionDetailViewModel {
    var delegate: ChatSessionDetailViewControllerProtocol?
    
    var chatSessionDetailData: [ChatSessionDetailModel] = []
    
    init(delegate: ChatSessionDetailViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getChatSessionDetail(chatSessionId: Int) {
        self.requestManager.request(forPath: ApiUrl.chatsessionsDetail.appending("\(chatSessionId)/messages"), method: .GET, headers: self.requestManager.Headers()) { (result: Result<[ChatSessionDetailModel], GrowthNetworkError>) in
            switch result {
            case .success(let chatSessionDetailData):
                self.chatSessionDetailData = chatSessionDetailData
                self.delegate?.chatSessionDetailReceivedSuccefully()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getChatSessionDetailDataAtIndex(index: Int)-> ChatSessionDetailModel? {
        return self.chatSessionDetailData[index]
    }
    
}

extension ChatSessionDetailViewModel: ChatSessionDetailViewModelProtocol {
    
    var getChatSessionDetailData: [ChatSessionDetailModel] {
        return self.chatSessionDetailData
    }
    
}
