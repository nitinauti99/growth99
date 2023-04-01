//
//  ChatSessionListViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 10/03/23.
//

import Foundation

protocol ChatSessionListViewModelProtocol {
    func getChatSessionList()
    func getChatSessionListDataAtIndex(index: Int) -> ChatSessionListModel?
    func getChatSessionListFilterDataAtIndex(index: Int)-> ChatSessionListModel?
    func filterData(searchText: String)
    
    var getChatSessionListData: [ChatSessionListModel] { get }
    var getChatSessionListFilterListData: [ChatSessionListModel] { get }
}

class ChatSessionListViewModel {
    var delegate: ChatSessionListViewControllerProtocol?
    
    var chatSessionListData: [ChatSessionListModel] = []
    var chatSessionListFilterListData: [ChatSessionListModel] = []
    
    init(delegate: ChatSessionListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getChatSessionList() {
        self.requestManager.request(forPath: ApiUrl.chatSessions, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[ChatSessionListModel], GrowthNetworkError>) in
            switch result {
            case .success(let chatSessionList):
                self.chatSessionListData = chatSessionList
                self.delegate?.chatSessionListReceivedSuccefully()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.chatSessionListFilterListData = (self.chatSessionListData.filter { $0.email?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() || String($0.id ?? 0) == searchText })
    }
    
    func getChatSessionListFilterDataAtIndex(index: Int) -> ChatSessionListModel? {
        return self.chatSessionListFilterListData[index]
    }
    
    func getChatSessionListDataAtIndex(index: Int)-> ChatSessionListModel? {
        return self.chatSessionListData[index]
    }
}

extension ChatSessionListViewModel: ChatSessionListViewModelProtocol {
    
    var getChatSessionListFilterListData: [ChatSessionListModel] {
        return self.chatSessionListFilterListData
    }
    
    var getChatSessionListData: [ChatSessionListModel] {
        return self.chatSessionListData
    }
    
}
