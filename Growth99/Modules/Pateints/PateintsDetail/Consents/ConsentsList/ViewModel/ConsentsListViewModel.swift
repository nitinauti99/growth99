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
                self.consentsList = consentsList.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.consentsFilterList = self.consentsList.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
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
