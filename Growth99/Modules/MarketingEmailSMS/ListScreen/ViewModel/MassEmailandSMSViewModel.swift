//
//  massEmailandSMSViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

protocol MassEmailandSMSViewModelProtocol {
    func getMassEmailandSMS()
    func getSwitchOnButton(massEmailandSMSId: String, massEmailandSMStatus: String)
    
    func getMassEmailandSMSFilterData(searchText: String)
    
    func getMassEmailandSMSDataAtIndex(index: Int)-> MassEmailandSMSModel?
    func getMassEmailandSMSFilterDataAtIndex(index: Int)-> MassEmailandSMSModel?
    
    var  getMassEmailandSMSData: [MassEmailandSMSModel] { get }
    var  getMassEmailandSMSFilterData: [MassEmailandSMSModel] { get }
    func removeSelectedMassEmail(massEmailId: Int)
}

class MassEmailandSMSViewModel {
    var delegate: MassEmailandSMSViewContollerProtocol?
    var massEmailList: [MassEmailandSMSModel] = []
    var massEmailListFilterData: [MassEmailandSMSModel] = []
    
    init(delegate: MassEmailandSMSViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getMassEmailandSMS() {
        self.requestManager.request(forPath: ApiUrl.getAllEmailandSMS, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[MassEmailandSMSModel], GrowthNetworkError>) in
            switch result {
            case .success(let massEMailandSMSData):
                self.massEmailList = massEMailandSMSData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
                self.delegate?.massEmailandSMSDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getSwitchOnButton(massEmailandSMSId: String, massEmailandSMStatus: String) {
        let url = "\(ApiUrl.getAllTriggers)/status/\(massEmailandSMSId)"
        guard let requestUrl = URL(string: url) else {
            self.delegate?.errorReceived(error: "Invalid URL")
            return
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        request.httpBody = massEmailandSMStatus.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserRepository.shared.Xtenantid ?? "", forHTTPHeaderField: "x-tenantid")
        request.addValue("Bearer \(UserRepository.shared.authToken ?? "")", forHTTPHeaderField: "Authorization")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 15 // Adjust timeout interval as needed
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async { // Switch to the main thread
                if let error = error {
                    self.delegate?.errorReceived(error: error.localizedDescription)
                    print("Error while performing request: \(error)")
                    return
                }
                
                if let data = data {
                    // Process the response data if needed
                    print("Response: \(String(data: data, encoding: .utf8) ?? "")")
                }
                // Handle successful response
                let responseMessage = (massEmailandSMStatus == "INACTIVE") ? "Trigger disabled successfully" : "Trigger enabled successfully"
                self.delegate?.massEmailSwitchActiveDataRecived(responseMessage: responseMessage)
            }
        }
        task.resume()
    }
    
    func removeSelectedMassEmail(massEmailId: Int) {
        let finaleUrl = ApiUrl.editTrigger.appending("\(massEmailId)")
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.delegate?.mailSMSDeletedSuccefully(message: "Trigger deleted successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
}

extension MassEmailandSMSViewModel: MassEmailandSMSViewModelProtocol {
    
    func getMassEmailandSMSFilterData(searchText: String) {
        self.massEmailListFilterData = self.getMassEmailandSMSData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let moduleMatch = task.moduleName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let executionStatusMatch = task.executionStatus?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || moduleMatch || executionStatusMatch || idMatch
        }
    }
    
    func getMassEmailandSMSDataAtIndex(index: Int)-> MassEmailandSMSModel? {
        return self.getMassEmailandSMSData[index]
    }
    
    func getMassEmailandSMSFilterDataAtIndex(index: Int)-> MassEmailandSMSModel? {
        return self.massEmailListFilterData[index]
    }
    
    var getMassEmailandSMSData: [MassEmailandSMSModel] {
        return self.massEmailList
    }
    
    var getMassEmailandSMSFilterData: [MassEmailandSMSModel] {
        return self.massEmailListFilterData
    }
}
