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
    var  triggersData: [TriggersListModel] { get }
    func triggersDataAtIndex(index: Int) -> TriggersListModel?
    var  triggersFilterDataData: [TriggersListModel] { get }
    func triggersFilterDataAtIndex(index: Int)-> TriggersListModel?
}

class TriggersListViewModel {
    var delegate: TriggersListViewContollerProtocol?
    var triggersListData: [TriggersListModel] = []
    var triggersFilterData: [TriggersListModel] = []
    
    init(delegate: TriggersListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
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
        self.requestManager.request(forPath: "\(ApiUrl.getAllTriggers)/status\(triggerId)", method: .PUT,task: .requestParameters(parameters: parameter, encoding: )) { (result: Result<[TriggersListModel], GrowthNetworkError>) in
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
    
    func triggersDataAtIndex(index: Int)-> TriggersListModel? {
        return self.triggersListData[index]
    }
    
    func triggersFilterDataAtIndex(index: Int)-> TriggersListModel? {
        return self.triggersListData[index]
    }
}

extension TriggersListViewModel: TriggersListViewModelProtocol {
   
    var triggersFilterDataData: [TriggersListModel] {
        return self.triggersFilterData
    }
    
    var triggersData: [TriggersListModel] {
        return self.triggersListData
    }
}
