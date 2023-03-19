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
    var  getPostsListData: [PostsListModel] { get }
}

class PostsListViewModel {
    var delegate: PostsListViewContollerProtocol?
    var postsListData: [PostsListModel] = []
    
    init(delegate: PostsListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getPostsList() {
        
        self.requestManager.request(forPath: ApiUrl.socialMediaPosts, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PostsListModel], GrowthNetworkError>) in
            switch result {
            case .success(let postsListData):
                self.postsListData = postsListData
                self.delegate?.postListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removePostss(pateintId: Int) {
//        let urlParameter: Parameters = [
//            "userId": pateintId
//        ]
//        let finaleUrl = ApiUrl.removePatient + "userId=" + "\(pateintId)"
//        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) {  [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let data):
//                print(data)
//                self.delegate?.pateintRemovedSuccefully(mrssage: "Postss removed successfully")
//            case .failure(let error):
//                self.delegate?.errorReceived(error: error.localizedDescription)
//                print("Error while performing request \(error)")
//            }
//          }
    }
    
    func postsListDataAtIndex(index: Int)-> PostsListModel? {
        return self.postsListData[index]
    }
}

extension PostsListViewModel: PostsListViewModelProtocol {
  
    
    var getPostsListData: [PostsListModel] {
        return self.postsListData
    }
    
}
