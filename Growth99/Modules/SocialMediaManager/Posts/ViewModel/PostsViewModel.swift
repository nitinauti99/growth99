//
//  PostsViewModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

protocol PostsListViewModelProtocol {
    func getPostsList()
    func pateintDataAtIndex(index: Int) -> PostsListModel?
    func pateintFilterDataAtIndex(index: Int)-> PostsListModel?
    func removePostss(pateintId: Int)
    func filterData(searchText: String)
    var  getPostsData: [PostsListModel] { get }
    var  getPostsFilterData: [PostsListModel] { get }
}

class PostsListViewModel {
    var delegate: PostsListViewContollerProtocol?
    var pateintListData: [PostsListModel] = []
    var pateintFilterData: [PostsListModel] = []
    
    init(delegate: PostsListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getPostsList() {
        self.requestManager.request(forPath: ApiUrl.patientsList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PostsListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintData):
                self.pateintListData = pateintData
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removePostss(pateintId: Int) {
        let urlParameter: Parameters = [
            "userId": pateintId
        ]
        let finaleUrl = ApiUrl.removePatient + "userId=" + "\(pateintId)"
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.pateintRemovedSuccefully(mrssage: "Postss removed successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
          }
    }
    
    func pateintDataAtIndex(index: Int)-> PostsListModel? {
        return self.pateintListData[index]
    }
    
    func filterData(searchText: String) {
       self.pateintFilterData = (self.pateintListData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func pateintFilterDataAtIndex(index: Int)-> PostsListModel? {
        return self.pateintFilterData[index]
    }
}

extension PostsListViewModel: PostsListViewModelProtocol {
    
    var getPostsFilterData: [PostsListModel] {
        return self.pateintFilterData
    }
    
    var getPostsData: [PostsListModel] {
        return self.pateintListData
    }
    
}
