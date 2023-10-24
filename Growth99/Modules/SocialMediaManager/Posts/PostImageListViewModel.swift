//
//  PostImageListViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 27/03/23.
//

import Foundation

protocol PostImageListViewModelProtocol {
    
    /// get PostImage From lbrariesList
    func getSocialPostImageFromLbrariesList(page: Int,size: Int, search: String, tags: Int)
    var getSocialPostImageList: [Content] { get }
    func getSocialPostImageListDataAtIndex(index: Int)-> Content?
      
}

class PostImageListViewModel {

    var socialPostImageList: [Content] = []
    
    var delegate: PostImageListViewControllerProtocol?
    
    init(delegate: PostImageListViewControllerProtocol?) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    
    
    /// get image from imageLibrary
    func getSocialPostImageFromLbrariesList(page: Int,size: Int, search: String, tags: Int) {
        let url = "page=\(page)&size=\(size)&search=\(search)&tags="
      
        self.requestManager.request(forPath: ApiUrl.socialMediaLibraries.appending(url), method: .GET, headers: self.requestManager.Headers()) {  (result: Result< MediaLibraryListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.socialPostImageList = pateintsTagList.content ?? []
                self.delegate?.socialPostImageFromLbrariesListRecived()
            case .failure(let error):
                self.socialPostImageList = []
                self.delegate?.errorReceived(error: "")
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getSocialPostImageListDataAtIndex(index: Int)-> Content? {
        return self.socialPostImageList[index]
    }

}

extension PostImageListViewModel: PostImageListViewModelProtocol {

    var getSocialPostImageList: [Content] {
        return self.socialPostImageList
    }
        
}
