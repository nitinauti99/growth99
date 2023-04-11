//
//  LeadTagsViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

protocol LeadTagsListViewModelProtocol {
    func getLeadTagsList()
    func leadTagsListDataAtIndex(index: Int) -> LeadTagListModel?
    func leadTagsFilterListDataAtIndex(index: Int)-> LeadTagListModel?
    func removeLeadTag(leadId: Int)
    func filterData(searchText: String)
    var getLeadTagsData: [LeadTagListModel] { get }
    var getLeadTagsFilterData: [LeadTagListModel] { get }
}

class LeadTagsListViewModel {
    var delegate: LeadTagsListViewControllerProtocol?
    var leadTagsList: [LeadTagListModel] = []
    var leadTagsFilterList: [LeadTagListModel] = []
    
    init(delegate: LeadTagsListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getLeadTagsList() {
        self.requestManager.request(forPath: ApiUrl.leadTagList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[LeadTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.leadTagsList = pateintsTagList.reversed()
                self.delegate?.leadTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: "Error while performing request \(error)")
            }
        }
    }
    
    func removeLeadTag(leadId: Int) {
        self.requestManager.request(forPath: ApiUrl.removeLeadTags.appending("\(leadId)"), method: .DELETE, headers: self.requestManager.Headers()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.leadTagRemovedSuccefully(message: "Tag deleted successfully")
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "The Tag Associated With A Lead Cannot Be Deleted. To Delete, Remove This Tag From The Leads.")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.leadTagsFilterList = self.leadTagsList.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func leadTagsListDataAtIndex(index: Int)-> LeadTagListModel? {
        return self.leadTagsList[index]
    }
    
    func leadTagsFilterListDataAtIndex(index: Int)-> LeadTagListModel? {
        return self.leadTagsFilterList[index]
    }
}

extension LeadTagsListViewModel: LeadTagsListViewModelProtocol {
    
    var getLeadTagsData: [LeadTagListModel] {
        return self.leadTagsList
    }
    
    var getLeadTagsFilterData: [LeadTagListModel] {
        return self.leadTagsFilterList
    }
}
