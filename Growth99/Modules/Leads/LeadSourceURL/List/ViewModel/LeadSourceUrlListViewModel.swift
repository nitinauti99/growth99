//
//  LeadSourceUrlListViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

protocol LeadSourceUrlListViewModelProtocol {
    func getLeadSourceUrlList()
    func leadTagsListDataAtIndex(index: Int) -> LeadSourceUrlListModel?
    func leadTagsFilterListDataAtIndex(index: Int)-> LeadSourceUrlListModel?
    func removeLeadTag(leadId: Int)
    func filterData(searchText: String)
    var getLeadSourceUrlData: [LeadSourceUrlListModel] { get }
    var getLeadSourceUrlFilterData: [LeadSourceUrlListModel] { get }
}

class LeadSourceUrlListViewModel {
    var delegate: LeadSourceUrlListViewControllerProtocol?
    var leadTagsList: [LeadSourceUrlListModel] = []
    var leadTagsFilterList: [LeadSourceUrlListModel] = []
    
    init(delegate: LeadSourceUrlListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getLeadSourceUrlList() {
        self.requestManager.request(forPath: ApiUrl.getLeadsourceurls, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[LeadSourceUrlListModel], GrowthNetworkError>) in
            switch result {
            case .success(let leadSourceUrlList):
                self.leadTagsList = leadSourceUrlList
                self.delegate?.leadTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeLeadTag(leadId: Int) {
        self.requestManager.request(forPath: ApiUrl.removeLeadsourceurls.appending("\(leadId)"), method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.leadSoureceUrlRemovedSuccefully(message:"lead Sourece url removed successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
       self.leadTagsFilterList = (self.leadTagsList.filter { $0.sourceUrl?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func leadTagsListDataAtIndex(index: Int)-> LeadSourceUrlListModel? {
        return self.leadTagsList[index]
    }
    
    func leadTagsFilterListDataAtIndex(index: Int)-> LeadSourceUrlListModel? {
        return self.leadTagsFilterList[index]
    }
}

extension LeadSourceUrlListViewModel: LeadSourceUrlListViewModelProtocol {
   
    var getLeadSourceUrlData: [LeadSourceUrlListModel] {
        return self.leadTagsList
    }
    
    var getLeadSourceUrlFilterData: [LeadSourceUrlListModel] {
        return self.leadTagsFilterList
    }
}
