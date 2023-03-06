//
//  LeadTagsViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

protocol LeadTagsListViewModelProtocol {
    func getLeadTagsList()
    func leadTagsListDataAtIndex(index: Int) -> PateintsTagListModel?
    func leadTagsFilterListDataAtIndex(index: Int)-> PateintsTagListModel?
    func removeLeadTag(leadId: Int)
    func filterData(searchText: String)
    var getLeadTagsData: [PateintsTagListModel] { get }
    var getLeadTagsFilterData: [PateintsTagListModel] { get }
}

class LeadTagsListViewModel {
    var delegate: LeadTagsListViewControllerProtocol?
    var leadTagsList: [PateintsTagListModel] = []
    var leadTagsFilterList: [PateintsTagListModel] = []
    
    init(delegate: LeadTagsListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getLeadTagsList() {
        self.requestManager.request(forPath: ApiUrl.leadTagList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PateintsTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.leadTagsList = pateintsTagList
                self.delegate?.leadTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeLeadTag(leadId: Int) {
        self.requestManager.request(forPath: ApiUrl.removeLeadTags.appending("\(leadId)"), method: .DELETE, headers: self.requestManager.Headers()) { (result: Result< PateintsTagRemove, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.leadTagRemovedSuccefully(message: data.success ?? String.blank)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
       self.leadTagsFilterList = (self.leadTagsList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func leadTagsListDataAtIndex(index: Int)-> PateintsTagListModel? {
        return self.leadTagsList[index]
    }
    
    func leadTagsFilterListDataAtIndex(index: Int)-> PateintsTagListModel? {
        return self.leadTagsFilterList[index]
    }
}

extension LeadTagsListViewModel: LeadTagsListViewModelProtocol {
   
    var getLeadTagsData: [PateintsTagListModel] {
        return self.leadTagsList
    }
    
    var getLeadTagsFilterData: [PateintsTagListModel] {
        return self.leadTagsFilterList
    }
}
