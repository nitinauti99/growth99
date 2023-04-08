//
//  DeletedDeletedLeadListViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

protocol DeletedLeadListViewModelProtocol {
    func getDeletedLeadList(page: Int, size: Int, statusFilter: String, sourceFilter: String, search: String, leadTagFilter: String)
    func deletedLeadListDataAtIndex(index: Int) -> DeletedLeadListModel?
    func deletedLeadListFilterDataAtIndex(index: Int) -> DeletedLeadListModel?
    func filterData(searchText: String)
    
    var getDeletedLeadListData: [DeletedLeadListModel] { get }
    var getDeletedLeadListFilterData: [DeletedLeadListModel] { get }
}

class DeletedLeadListViewModel {
    var deletedLeadList: [DeletedLeadListModel] = []
    var deletedFilterLeadList: [DeletedLeadListModel] = []
    
    var delegate: DeletedLeadListViewControllerProtocol?
    
    init(delegate: DeletedLeadListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getDeletedLeadList(page: Int, size: Int, statusFilter: String, sourceFilter: String, search: String, leadTagFilter: String) {
        
        self.requestManager.request(forPath: ApiUrl.getDeletedLeadList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[DeletedLeadListModel], GrowthNetworkError>) in
            switch result {
            case .success(let LeadData):
                self.setUpData(leadListData: LeadData)
                self.delegate?.DeletedLeadListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func setUpData(leadListData: [DeletedLeadListModel]) {
        for item in leadListData {
            if item.totalCount == nil {
                self.deletedLeadList.append(item)
            }
        }
    }
    
    
    func filterData(searchText: String) {
        self.deletedFilterLeadList = self.deletedLeadList.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.email?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func deletedLeadListDataAtIndex(index: Int)-> DeletedLeadListModel? {
        return self.deletedLeadList[index]
    }
    
    func deletedLeadListFilterDataAtIndex(index: Int)-> DeletedLeadListModel? {
        return self.deletedFilterLeadList[index]
    }
}

extension DeletedLeadListViewModel: DeletedLeadListViewModelProtocol {
    
    var getDeletedLeadListData : [DeletedLeadListModel] {
        return self.deletedLeadList
    }
    
    var getDeletedLeadListFilterData : [DeletedLeadListModel] {
        return self.deletedFilterLeadList
    }
}
