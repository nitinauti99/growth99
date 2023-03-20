//
//  MediaLibraryViewModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

protocol MediaLibraryListViewModelProtocol {
    func getSocialMediaLibrariesList(page: Int,size: Int, search: String, tags: Int)
    func socialMediaLibrariesListDataAtIndex(index: Int) -> Content?
    func removeSocialMediaLibraries(socialMediaLibrariesId: Int)
   
    var getSocialMediaLibrariesData: [Content] { get }
}

class MediaLibraryListViewModel {
    var delegate: MediaLibraryListViewControllerProtocol?
    
    var socialMediaLibrariesList: [Content] = []
    var socialMediaLibrariesFilterList: [MediaLibraryListModel] = []
    
    init(delegate: MediaLibraryListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getSocialMediaLibrariesList(page: Int,size: Int, search: String, tags: Int) {
        let url = "page=\(page)&size=\(size)&search=\(search)&tags="
      
        self.requestManager.request(forPath: ApiUrl.socialMediaLibraries.appending(url), method: .GET, headers: self.requestManager.Headers()) {  (result: Result<MediaLibraryListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.socialMediaLibrariesList = pateintsTagList.content ?? []
                self.delegate?.socialMediaLibrariesListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeSocialMediaLibraries(socialMediaLibrariesId: Int) {
        self.requestManager.request(forPath: ApiUrl.socialMediaPostLabels.appending("/\(socialMediaLibrariesId)"), method: .DELETE, headers: self.requestManager.Headers()) { (result: Result< PateintsTagRemove, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.socialMediaLibrariesRemovedSuccefully(message: data.success ?? String.blank)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func socialMediaLibrariesListDataAtIndex(index: Int)-> Content? {
        return self.socialMediaLibrariesList[index]
    }
}

extension MediaLibraryListViewModel: MediaLibraryListViewModelProtocol {
    
    var getSocialMediaLibrariesData: [Content] {
        return self.socialMediaLibrariesList
    }

}
