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
    
    init(delegate: TriggersListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getTriggersList() {
        self.requestManager.request(forPath: ApiUrl.getAllTriggers, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[TriggersListModel], GrowthNetworkError>) in
            switch result {
            case .success(let triggerData):
                self.triggersListData = triggerData.sorted(by: { ($0.updatedAt ?? String.blank) > ($1.updatedAt ?? String.blank)})
                self.delegate?.TriggersDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getSwitchOnButton(triggerId: String, triggerStatus: String) {
        let parameter: [String: Any] = [triggerStatus: ""]
        let url = "\(ApiUrl.getAllTriggers)/status/\(triggerId)"
        self.requestManager.request(forPath: url, method: .PUT,task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<[TriggersListModel], GrowthNetworkError>) in
            switch result {
            case .success(let triggerData):
                self.triggersListData = triggerData
                self.delegate?.TriggersDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
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
    func removeSelectedMassEmail(MassEmailId: Int) {
        
    }
    
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
