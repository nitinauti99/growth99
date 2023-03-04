//
//  PateintsTagsListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 29/01/23.
//

import Foundation

protocol PateintsTagsListViewModelProtocol {
    func getPateintsTagsList()
    func pateintsTagsListDataAtIndex(index: Int) -> PateintsTagListModel?
    func pateintsTagsFilterListDataAtIndex(index: Int)-> PateintsTagListModel?
    func removePateintsTag(pateintsTagid: Int)
    func filterData(searchText: String)
    var getPateintsTagsData: [PateintsTagListModel] { get }
    var getPateintsTagsFilterData: [PateintsTagListModel] { get }
}

class PateintsTagsListViewModel {
    var delegate: PateintsTagsListViewControllerProtocol?
    var pateintsTagsList: [PateintsTagListModel] = []
    var pateintsTagsFilterList: [PateintsTagListModel] = []
    
    init(delegate: PateintsTagsListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getPateintsTagsList() {
        self.requestManager.request(forPath: ApiUrl.patientTagList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PateintsTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.pateintsTagsList = pateintsTagList
                self.delegate?.pateintsTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removePateintsTag(pateintsTagid: Int) {
        self.requestManager.request(forPath: ApiUrl.removePatientsTags.appending("\(pateintsTagid)"), method: .DELETE, headers: self.requestManager.Headers()) { (result: Result< PateintsTagRemove, GrowthNetworkError>) in
            
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.pateintTagRemovedSuccefully(mrssage: data.success ?? String.blank)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
       self.pateintsTagsFilterList = (self.pateintsTagsList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func pateintsTagsListDataAtIndex(index: Int)-> PateintsTagListModel? {
        return self.pateintsTagsList[index]
    }
    
    func pateintsTagsFilterListDataAtIndex(index: Int)-> PateintsTagListModel? {
        return self.pateintsTagsFilterList[index]
    }
}

extension PateintsTagsListViewModel: PateintsTagsListViewModelProtocol {
   
    var getPateintsTagsData: [PateintsTagListModel] {
        return self.pateintsTagsList
    }
    
    var getPateintsTagsFilterData: [PateintsTagListModel] {
        return self.pateintsTagsFilterList
    }
}
