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
    func isURLValid(url: String) -> Bool
    func getDefaultClincsData()

    var getChatConfigurationData: ChatConfigurationModel { get }
    var getDefaulrClincData: DefaultClinicModel { get }

}

class ChatConfigurationViewModel {
    var delegate: ChatConfigurationViewControllerProtocol?
  
    var chatConfigurationData: ChatConfigurationModel?
    var defaultClinicsData: DefaultClinicModel?
    
    init(delegate: ChatConfigurationViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getDefaultClincsData() {
        self.requestManager.request(forPath: ApiUrl.clinicsDefault, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<DefaultClinicModel, GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.defaultClinicsData = userData
                self.delegate?.chatDefaultClincsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
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
    
    var getDefaulrClincData: DefaultClinicModel{
        return self.defaultClinicsData!
    }
    
    func isURLValid(url: String) -> Bool {
        let regex = Constant.Regex.urlValidation
        let isURL = NSPredicate(format:"SELF MATCHES %@", regex)
        return isURL.evaluate(with: url)
    }

}
