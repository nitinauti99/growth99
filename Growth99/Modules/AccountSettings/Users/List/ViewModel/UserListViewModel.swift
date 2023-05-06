//
//  UserListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 24/12/22.
//

import Foundation

protocol UserListViewModelProtocol {
    func getUserList()
    func removeUser(userId: Int)
    func userDataAtIndex(index: Int) -> UserListModel?
    func userFilterDataDataAtIndex(index: Int)-> UserListModel?
    func filterData(searchText: String)
   
    var UserData: [UserListModel] { get }
    var UserFilterDataData: [UserListModel] { get }
}

class UserListViewModel {
    var delegate: UserListViewContollerProtocol?
    var userData: [UserListModel] = []
    var userFilterData: [UserListModel] = []
    
    init(delegate: UserListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getUserList() {
        self.requestManager.request(forPath: ApiUrl.getUserList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[UserListModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.userData = userData.reversed()
                self.delegate?.userListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeUser(userId: Int){
        let finaleUrl = ApiUrl.deleteUser.appending("\(userId)")
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.userRemovedSuccefully(message: "User deleted successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.userFilterData = self.userData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.firstName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let lastNameMatch = task.lastName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let emailMatch = task.email?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || lastNameMatch || idMatch || emailMatch
        }
    }
    
    func userDataAtIndex(index: Int)-> UserListModel? {
        return self.userData[index]
    }
    
    func userFilterDataDataAtIndex(index: Int)-> UserListModel? {
        return self.userFilterData[index]
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
