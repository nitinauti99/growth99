//
//  TwoWayTextConfigurationViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 19/12/23.
//

import Foundation

protocol TwoWayTextConfigurationViewModelProtocol {
    func getTwoWayConfigurationData()
    var getConfigurationData: ConfigurationDataModel { get }
    func getTwoWayConfigurationforSMandEmail(configurationKey: String, status: Bool)
    func getTwoWayConfiguration(status: Bool)

}

class TwoWayTextConfigurationViewModel {
    var delegate: TwoWayTextConfigurationViewControllerProtocol?
    var configurationData: ConfigurationDataModel?
    
    var headers: HTTPHeaders {
        return ["x-tenantid": UserRepository.shared.Xtenantid ?? String.blank,
                "Authorization": "Bearer "+(UserRepository.shared.authToken ?? String.blank)
        ]
    }
    
    init(delegate: TwoWayTextConfigurationViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getTwoWayConfigurationData() {
        
        let url = "\(ApiUrl.TwoWayConfigurationData)\(UserRepository.shared.Xtenantid ?? String.blank)"
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< ConfigurationDataModel, GrowthNetworkError>) in
            switch result {
            case .success(let twoWayTemplateListData):
                self.configurationData = twoWayTemplateListData
                self.delegate?.twoWayConfigurationDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTwoWayConfigurationforSMandEmail(configurationKey: String, status: Bool){
        let url = "\(ApiUrl.TwoWayConfigurationForSMSandEmail)\(configurationKey)/\(status)"
        self.requestManager.request(forPath: url, method: .PUT, headers: self.requestManager.Headers()) {  (result: Result< ConfigurationDataModel, GrowthNetworkError>) in
            switch result {
            case .success(let twoWayTemplateListData):
                self.configurationData = twoWayTemplateListData
                self.delegate?.twoWayConfigurationDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    
    func getTwoWayConfiguration(status: Bool){
        let parameter: [String : Any] = ["enableTwoWaySMS": status ]
        let url = "\(ApiUrl.TwoWayConfigurationForEnableTwoWaySMS)\(UserRepository.shared.Xtenantid ?? String.blank)/\("notification/sms-forwarding")"
        self.requestManager.request(forPath: url, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) {  (result: Result< ConfigurationDataModel, GrowthNetworkError>) in
            switch result {
            case .success(let twoWayTemplateListData):
                self.configurationData = twoWayTemplateListData
                self.delegate?.twoWayConfigurationDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension TwoWayTextConfigurationViewModel: TwoWayTextConfigurationViewModelProtocol {

    var getConfigurationData: ConfigurationDataModel {
        return self.configurationData!
    }
}
