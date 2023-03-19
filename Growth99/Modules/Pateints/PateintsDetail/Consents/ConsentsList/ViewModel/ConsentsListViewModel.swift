//
//  ConsentsListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import Foundation

protocol ConsentsListViewModelProtocol {
    func getConsentsList(pateintId: Int)
    func consentsListAtIndex(index: Int) -> ConsentsListModel?
    func consentsFilterListAtIndex(index: Int)-> ConsentsListModel?
    func filterData(searchText: String)
    var consentsFilterDataList: [ConsentsListModel] { get }
    var consentsDataList: [ConsentsListModel] { get }
}

class ConsentsListViewModel {
    var delegate: ConsentsListViewControllerProtocol?
    var consentsList: [ConsentsListModel] = []
    var consentsFilterList: [ConsentsListModel] = []
    
    init(delegate: ConsentsListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getConsentsList(pateintId: Int) {
        let finaleUrl = ApiUrl.consentsList + "\(pateintId)" + "/consents"
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers:self.requestManager.Headers()) {(result: Result<[ConsentsListModel], GrowthNetworkError>) in
            switch result {
            case .success(let consentsList):
                self.consentsList = consentsList
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
       self.consentsFilterList = (self.consentsList.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func consentsListAtIndex(index: Int)-> ConsentsListModel? {
        return self.consentsList[index]
    }
    
    func consentsFilterListAtIndex(index: Int)-> ConsentsListModel? {
        return self.consentsFilterList[index]
    }
}

extension ConsentsListViewModel: ConsentsListViewModelProtocol {
    
    var consentsDataList: [ConsentsListModel] {
        return self.consentsList
    }
    
    var consentsFilterDataList: [ConsentsListModel] {
        return self.consentsFilterList
    }
}
