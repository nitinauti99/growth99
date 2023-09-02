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
        let urlString = url.removeWhitespace()
      
        self.requestManager.request(forPath: ApiUrl.socialMediaLibraries.appending(urlString), method: .GET, headers: self.requestManager.Headers()) {  (result: Result<MediaLibraryListModel, GrowthNetworkError>) in
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
        self.requestManager.request(forPath: ApiUrl.socialMediaLibrary.appending("/\(socialMediaLibrariesId)"), method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.socialMediaLibrariesRemovedSuccefully(message: "Image deleted successfully")
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "service failed")
                } else{
                    self.delegate?.errorReceived(error: "responce failed")
                }
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
