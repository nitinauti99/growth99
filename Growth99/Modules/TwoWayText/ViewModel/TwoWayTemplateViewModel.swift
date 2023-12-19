//
//  TwoWayTemplateViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 17/12/23.
//

import Foundation

protocol TwoWayTemplateViewModelProtocol {
    func getTwoWayTemplateList(sourceType: String, soureFrom: String, sourceId: Int)
    func getTwoWayTemplateFilterData(searchText: String)
    func getTwoWayTemplateDataAtIndex(index: Int)-> TwoWayTemplateListModel?
    func getTwoWayTemplateFilterDataAtIndex(index: Int)-> TwoWayTemplateListModel?
    var  getTwoWayTemplateData: [TwoWayTemplateListModel] { get }
    var  getTwoWayTemplateFilterData: [TwoWayTemplateListModel] { get }
}

class TwoWayTemplateListViewModel {
    var delegate: TwoWayTemplateListViewContollerProtocol?
    var twoWayTemplateListData: [TwoWayTemplateListModel] = []
    var twoWayTemplateFilterData: [TwoWayTemplateListModel] = []
    
    var headers: HTTPHeaders {
        return ["x-tenantid": UserRepository.shared.Xtenantid ?? String.blank,
                "Authorization": "Bearer "+(UserRepository.shared.authToken ?? String.blank)
        ]
    }
    init(delegate: TwoWayTemplateListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getTwoWayTemplateList(sourceType: String, soureFrom: String, sourceId: Int) {
        let url = "\(ApiUrl.smsTemplate)\(sourceType)/\(soureFrom)/\(sourceId)"
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[TwoWayTemplateListModel], GrowthNetworkError>) in
            switch result {
            case .success(let twoWayTemplateListData):
                self.twoWayTemplateListData = twoWayTemplateListData
                self.delegate?.twoWayTemplateListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension TwoWayTemplateListViewModel: TwoWayTemplateViewModelProtocol {

    func getTwoWayTemplateFilterData(searchText: String) {
        self.twoWayTemplateFilterData = self.getTwoWayTemplateData.filter { (task: TwoWayTemplateListModel) -> Bool in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func getTwoWayTemplateDataAtIndex(index: Int)-> TwoWayTemplateListModel? {
        return self.getTwoWayTemplateData[index]
    }
    
    func getTwoWayTemplateFilterDataAtIndex(index: Int)-> TwoWayTemplateListModel? {
        return self.twoWayTemplateFilterData[index]
    }
    var getTwoWayTemplateFilterData: [TwoWayTemplateListModel] {
        return self.twoWayTemplateFilterData
    }
    
    var getTwoWayTemplateData: [TwoWayTemplateListModel] {
        return twoWayTemplateListData
    }
}
