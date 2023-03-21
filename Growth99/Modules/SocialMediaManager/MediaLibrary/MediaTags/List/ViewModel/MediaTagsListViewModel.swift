//
//  MediaTagsListViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import Foundation

protocol MediaTagsListViewModelProtocol {
    func getMediaTagsList()
    func mediaTagsListDataAtIndex(index: Int) -> MediaTagListModel?
    func mediaTagsFilterListDataAtIndex(index: Int)-> MediaTagListModel?
    func removeMediaTag(mediaId: Int)
    func filterData(searchText: String)
    var getMediaTagsData: [MediaTagListModel] { get }
    var getMediaTagsFilterData: [MediaTagListModel] { get }
}

class MediaTagsListViewModel {
    var delegate: MediaTagsListViewControllerProtocol?
    var mediaTagsList: [MediaTagListModel] = []
    var mediaTagsFilterList: [MediaTagListModel] = []
    
    init(delegate: MediaTagsListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getMediaTagsList() {
        self.requestManager.request(forPath: ApiUrl.socialMediaTaglist, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[MediaTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.mediaTagsList = pateintsTagList
                self.delegate?.mediaTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeMediaTag(mediaId: Int) {
        self.requestManager.request(forPath: ApiUrl.mediaTagUrl.appending("\(mediaId)"), method: .DELETE, headers: self.requestManager.Headers()) { (result: Result< MediaTagRemove, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.mediaTagRemovedSuccefully(message: data.success ?? String.blank)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
       self.mediaTagsFilterList = (self.mediaTagsList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func mediaTagsListDataAtIndex(index: Int)-> MediaTagListModel? {
        return self.mediaTagsList[index]
    }
    
    func mediaTagsFilterListDataAtIndex(index: Int)-> MediaTagListModel? {
        return self.mediaTagsFilterList[index]
    }
}

extension MediaTagsListViewModel: MediaTagsListViewModelProtocol {
   
    var getMediaTagsData: [MediaTagListModel] {
        return self.mediaTagsList
    }
    
    var getMediaTagsFilterData: [MediaTagListModel] {
        return self.mediaTagsFilterList
    }
}
