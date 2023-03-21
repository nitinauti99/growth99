//
//  MediaTagsListViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import Foundation

protocol MediaTagsListViewModelProtocol {
    func getMediaTagsList()
    func leadTagsListDataAtIndex(index: Int) -> MediaTagListModel?
    func leadTagsFilterListDataAtIndex(index: Int)-> MediaTagListModel?
    func removeMediaTag(leadId: Int)
    func filterData(searchText: String)
    var getMediaTagsData: [MediaTagListModel] { get }
    var getMediaTagsFilterData: [MediaTagListModel] { get }
}

class MediaTagsListViewModel {
    var delegate: MediaTagsListViewControllerProtocol?
    var leadTagsList: [MediaTagListModel] = []
    var leadTagsFilterList: [MediaTagListModel] = []
    
    init(delegate: MediaTagsListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getMediaTagsList() {
        self.requestManager.request(forPath: ApiUrl.socialMediaTaglist, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[MediaTagListModel], GrowthNetworkError>) in
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
    
    func removeMediaTag(leadId: Int) {
        self.requestManager.request(forPath: ApiUrl.leadTaskList.appending("\(leadId)"), method: .DELETE, headers: self.requestManager.Headers()) { (result: Result< PateintsTagRemove, GrowthNetworkError>) in
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
    
    func leadTagsListDataAtIndex(index: Int)-> MediaTagListModel? {
        return self.leadTagsList[index]
    }
    
    func leadTagsFilterListDataAtIndex(index: Int)-> MediaTagListModel? {
        return self.leadTagsFilterList[index]
    }
}

extension MediaTagsListViewModel: MediaTagsListViewModelProtocol {
   
    var getMediaTagsData: [MediaTagListModel] {
        return self.leadTagsList
    }
    
    var getMediaTagsFilterData: [MediaTagListModel] {
        return self.leadTagsFilterList
    }
}
