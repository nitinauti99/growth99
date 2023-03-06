//
//  ChatbotViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import Foundation

protocol ChatConfigurationViewModelProtocol {
    func getChatConfigurationDataList()
   
    var getChatConfigurationData: ChatConfigurationModel { get }
}

class ChatConfigurationViewModel {
    var delegate: ChatConfigurationViewControllerProtocol?
  
    var chatConfigurationData: ChatConfigurationModel?
    
    init(delegate: ChatConfigurationViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getChatConfigurationDataList() {
        self.requestManager.request(forPath: ApiUrl.chatconfigs, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ChatConfigurationModel, GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.chatConfigurationData = userData
                self.delegate?.chatConfigurationDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension ChatConfigurationViewModel: ChatConfigurationViewModelProtocol {
    
    var getChatConfigurationData: ChatConfigurationModel{
        return self.chatConfigurationData!
    }
}
