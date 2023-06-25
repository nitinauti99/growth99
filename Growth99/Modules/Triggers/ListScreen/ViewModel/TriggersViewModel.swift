//
//  TriggersViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

protocol TriggersListViewModelProtocol {
    func getTriggersList()
    func getSwitchOnButton(triggerId: String, triggerStatus: String)
    func getTriggersFilterData(searchText: String)
    func getTriggersDataAtIndex(index: Int)-> TriggersListModel?
    func getTriggersFilterDataAtIndex(index: Int)-> TriggersListModel?
    var  getTriggersData: [TriggersListModel] { get }
    var  getTriggersFilterData: [TriggersListModel] { get }
    func removeSelectedTrigger(selectedId: Int)
}

class TriggersListViewModel {
    var delegate: TriggersListViewContollerProtocol?
    var triggersListData: [TriggersListModel] = []
    var triggersFilterData: [TriggersListModel] = []
    var headers: HTTPHeaders {
        return ["x-tenantid": UserRepository.shared.Xtenantid ?? String.blank,
                "Authorization": "Bearer "+(UserRepository.shared.authToken ?? String.blank)
        ]
    }
    init(delegate: TriggersListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getTriggersList() {
        self.requestManager.request(forPath: ApiUrl.getAllTriggers, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[TriggersListModel], GrowthNetworkError>) in
            switch result {
            case .success(let triggerData):
                self.triggersListData = triggerData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
                self.delegate?.triggersDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getSwitchOnButton(triggerId: String, triggerStatus: String) {
        let url = "\(ApiUrl.getAllTriggers)/status/\(triggerId)"
        guard let requestUrl = URL(string: url) else {
            self.delegate?.errorReceived(error: "Invalid URL")
            return
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        request.httpBody = triggerStatus.data(using: .utf8)
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
                let responseMessage = (triggerStatus == "INACTIVE") ? "Trigger disabled successfully" : "Trigger enabled successfully"
                self.delegate?.triggersSwitchActiveDataRecived(responseMessage: responseMessage)
            }
        }
        task.resume()
    }
    
    func removeSelectedTrigger(selectedId: Int) {
        let finaleUrl = ApiUrl.editTrigger.appending("\(selectedId)")
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.delegate?.triggerRemovedSuccefully(message: "Trigger deleted successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
}

extension TriggersListViewModel: TriggersListViewModelProtocol {
    
    func getTriggersFilterData(searchText: String) {
        self.triggersFilterData = self.getTriggersData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let moduleNameMatch = task.moduleName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || moduleNameMatch || idMatch
        }
    }
    
    func getTriggersDataAtIndex(index: Int)-> TriggersListModel? {
        return self.getTriggersData[index]
    }
    
    func getTriggersFilterDataAtIndex(index: Int)-> TriggersListModel? {
        return self.triggersFilterData[index]
    }
    
    var getTriggersData: [TriggersListModel] {
        return self.triggersListData
    }
    
    var getTriggersFilterData: [TriggersListModel] {
        return self.triggersFilterData
    }
}
