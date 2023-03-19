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
}

class TriggersListViewModel {
    var delegate: TriggersListViewContollerProtocol?
    var triggersListData: [TriggersListModel] = []
    var triggersFilterData: [TriggersListModel] = []
    
    init(delegate: TriggersListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getTriggersList() {
        self.requestManager.request(forPath: ApiUrl.getAllTriggers, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[TriggersListModel], GrowthNetworkError>) in
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
    
    func getSwitchOnButton(triggerId: String, triggerStatus: String) {
        let parameter: [String: Any] = [triggerStatus: ""]
        let url = "\(ApiUrl.getAllTriggers)/status\(triggerId)"
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
}

extension TriggersListViewModel: TriggersListViewModelProtocol {
    func removeSelectedMassEmail(MassEmailId: Int) {
        
    }

    func getTriggersFilterData(searchText: String) {
        self.triggersFilterData = (self.getTriggersData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
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
