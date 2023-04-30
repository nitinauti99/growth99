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
                self.mediaTagsList = pateintsTagList.reversed()
                self.delegate?.mediaTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeMediaTag(mediaId: Int) {
        self.requestManager.request(forPath: ApiUrl.mediaTagUrl.appending("\(mediaId)"), method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.mediaTagRemovedSuccefully(message: "Tag deleted successfully")
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "The Tag Associated With A Media Cannot Be Deleted. To Delete, Remove This Tag From The Media")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.mediaTagsFilterList = self.mediaTagsList.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
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
