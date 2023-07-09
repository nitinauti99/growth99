//
//  PostsViewModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

protocol PostsListViewModelProtocol {
    func getPostsList()
    func postsListDataAtIndex(index: Int) -> PostsListModel?
    func postsFilterListDataAtIndex(index: Int) -> PostsListModel?
    var  getPostsListData: [PostsListModel] { get }
    var  getPostsFilterListData: [PostsListModel] { get }
    func filterData(searchText: String)
    func removePost(postId: Int)
    func approvePost(postId: Int)
}

class PostsListViewModel {
    var delegate: PostsListViewContollerProtocol?
    var postsListData: [PostsListModel] = []
    var postsFilterListData: [PostsListModel] = []
    var postPeginationList:  [PostsListModel] = []
    var totalCount: Int? = 0
    
    init(delegate: PostsListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getPostsList() {
        self.requestManager.request(forPath: ApiUrl.socialMediaPosts, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PostsListModel], GrowthNetworkError>) in
            switch result {
            case .success(let postsListData):
                self.postPeginationList = []
                
                self.setUpData(postListData: postsListData)
                self.delegate?.postListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func setUpData(postListData: [PostsListModel]) {
        for item in postListData {
            if item.totalCount == nil {
                self.postPeginationList.append(item)
            }else{
                self.totalCount = item.totalCount ?? 0
            }
        }
    }
    
    func removePost(postId: Int) {
        self.requestManager.request(forPath: ApiUrl.deletePost.appending("\(postId)"), method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.removePost(message: "post deleted successfully")
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "error while deleting template")
                } else{
                    self.delegate?.errorReceived(error: "responce failed")
              }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func approvePost(postId: Int){
        self.requestManager.request(forPath: ApiUrl.deletePost.appending("\(postId)/approve"), method: .PUT, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.removePost(message: "Post approved successfully")
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "error while approving template")
                } else{
                    self.delegate?.errorReceived(error: "responce failed")
              }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    
    func postsListDataAtIndex(index: Int)-> PostsListModel? {
        return self.postPeginationList[index]
    }
    
    func postsFilterListDataAtIndex(index: Int)-> PostsListModel? {
        return self.postsFilterListData[index]
    }
    
    func filterData(searchText: String) {
        self.postsFilterListData = self.postPeginationList.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.post?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
}

extension PostsListViewModel: PostsListViewModelProtocol {
   
    var getPostsFilterListData: [PostsListModel] {
        return self.postsFilterListData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
    }
    
    var getPostsListData: [PostsListModel] {
        return self.postPeginationList.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
    }
    
}
