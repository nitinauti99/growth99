//
//  LeadHistoryViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation

protocol LeadHistoryViewModelProtocol {
    func getLeadHistory()
    func leadHistoryDataAtIndex(index: Int) -> leadListModel?
    func leadHistoryFilterDataAtIndex(index: Int)-> leadListModel?
    func filterData(searchText: String)
    func removeLeadFromHistry(id: Int)
    var  getLeadHistroyData: [leadListModel] { get }
    var  getLeadHistroyFilterData: [leadListModel] { get }
}

class LeadHistoryViewModel {
    var delegate: LeadHistoryViewControllerProtocol?
    var leadHistroyData: [leadListModel] = []
    var leadHistroyFilterData: [leadListModel] = []
    let user = UserRepository.shared
    
    init(delegate: LeadHistoryViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getLeadHistory() {
        let finaleURL = ApiUrl.getLeadHistory.appending("\(self.user.primaryEmailId ?? "")")
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[leadListModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.leadHistroyData = userData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
                self.delegate?.LeadHistoryDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.leadHistroyFilterData = self.leadHistroyData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.firstName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let lastNameMatch = task.lastName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || lastNameMatch || idMatch
        }
    }
    
    func removeLeadFromHistry(id: Int) {
        let finaleUrl = ApiUrl.deletHistryLead.appending("\(id)")
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.leadRemovedSuccefully(message: "Lead deleted Successfully")
                }else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while deleting lead")
                }else{
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    func leadHistoryDataAtIndex(index: Int)-> leadListModel? {
        return self.leadHistroyData[index]
    }
    
    func leadHistoryFilterDataAtIndex(index: Int)-> leadListModel? {
        return self.leadHistroyFilterData[index]
    }
    
}

extension LeadHistoryViewModel: LeadHistoryViewModelProtocol {
    
    var getLeadHistroyFilterData: [leadListModel] {
        return self.leadHistroyFilterData
    }
    
    var getLeadHistroyData: [leadListModel] {
        return self.leadHistroyData
    }
}
