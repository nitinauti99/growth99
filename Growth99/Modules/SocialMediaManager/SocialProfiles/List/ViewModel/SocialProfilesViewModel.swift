//
//  SocialProfilesViewModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

protocol SocialProfilesListViewModelProtocol {
    func getSocialProfilesList()
    func socialProfilesListDataAtIndex(index: Int) -> SocialProfilesListModel?
    func socialProfilesFilterListDataAtIndex(index: Int)-> SocialProfilesListModel?
    func removeSocialProfiles(socialProfilesId: Int)
    func filterData(searchText: String)
    
    var getSocialProfilesData: [SocialProfilesListModel] { get }
    var getSocialProfilesFilterData: [SocialProfilesListModel] { get }
}

class SocialProfilesListViewModel {
    var delegate: SocialProfilesListViewControllerProtocol?
    
    var socialProfilesList: [SocialProfilesListModel] = []
    var socialProfilesFilterList: [SocialProfilesListModel] = []
    
    init(delegate: SocialProfilesListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getSocialProfilesList() {
        self.requestManager.request(forPath: ApiUrl.socialProfileList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[SocialProfilesListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.socialProfilesList = pateintsTagList.
                self.delegate?.socialProfilesListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeSocialProfiles(socialProfilesId: Int) {
        self.requestManager.request(forPath: ApiUrl.socialProfileList.appending("/\(socialProfilesId)"), method: .DELETE, headers: self.requestManager.Headers())  {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.socialProfilesRemovedSuccefully(message: "Social profile deleted successfully")
                }else{
                    self.delegate?.errorReceived(error: "internal server error")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.socialProfilesFilterList = self.socialProfilesList.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func socialProfilesListDataAtIndex(index: Int)-> SocialProfilesListModel? {
        return self.socialProfilesList[index]
    }
    
    func socialProfilesFilterListDataAtIndex(index: Int)-> SocialProfilesListModel? {
        return self.socialProfilesFilterList[index]
    }
}

extension SocialProfilesListViewModel: SocialProfilesListViewModelProtocol {
    
    var getSocialProfilesData: [SocialProfilesListModel] {
        return self.socialProfilesList
    }
    
    var getSocialProfilesFilterData: [SocialProfilesListModel] {
        return self.socialProfilesFilterList
    }
}
