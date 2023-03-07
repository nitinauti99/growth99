//
//  ChatbotViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import Foundation

protocol ChatConfigurationViewModelProtocol {
    func getChatConfigurationDataList()
    func updateChatConfigData(param: [String: Any])
   
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
    
    func updateChatConfigData(param: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.updateChatConfig, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: param, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.delegate?.chatConfigurationDataUpdatedSuccessfully()
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
