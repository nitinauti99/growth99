//
//  UserListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 24/12/22.
//

import Foundation

protocol UserListViewModelProtocol {
    func getUserList()
    var UserData: [UserListModel] { get }
    func userDataAtIndex(index: Int) -> UserListModel?
    var UserFilterDataData: [UserListModel] { get }
    func userFilterDataDataAtIndex(index: Int)-> UserListModel?
}

class UserListViewModel {
    var delegate: UserListViewContollerProtocol?
    var userData: [UserListModel] = []
    var userFilterData: [UserListModel] = []
    
    init(delegate: UserListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getUserList() {
        self.requestManager.request(forPath: ApiUrl.getUserList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[UserListModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.userData = userData.reversed()
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func userDataAtIndex(index: Int)-> UserListModel? {
        return self.userData[index]
    }
    
    func userFilterDataDataAtIndex(index: Int)-> UserListModel? {
        return self.UserFilterDataData[index]
    }
}

extension UserListViewModel: UserListViewModelProtocol {
    
    var UserFilterDataData: [UserListModel] {
        return self.userFilterData
    }
    
    var UserData: [UserListModel] {
        return self.userData
    }
}
