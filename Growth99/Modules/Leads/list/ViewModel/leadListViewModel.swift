//
//  leadListListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 03/12/22.
//

import Foundation

protocol leadListViewModelProtocol {
    func getleadList(page: Int, size: Int, statusFilter: String, sourceFilter: String, search: String, leadListTagFilter: String)
    func leadListDataAtIndex(index: Int) -> leadListModel?
    func leadPeginationListDataAtIndex(index: Int) -> leadListModel?
    func leadListFilterDataAtIndex(index: Int) -> leadListModel?
    var getleadListData: [leadListModel] { get }
    var getleadPeginationListData: [leadListModel] { get }
    var getleadListFilterData: [leadListModel] { get }
    var leadListTotalCount: Int { get }
}

class leadListViewModel {
    var leadList: [leadListModel] = []
    var leadFilterList: [leadListModel] = []
    
    var leadListPeginationList: [leadListModel]?
    var totalCount: Int = 0
    
    var delegate: leadListViewControllerProtocol?
    
    init(delegate: leadListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getleadList(page: Int, size: Int, statusFilter: String, sourceFilter: String, search: String, leadListTagFilter: String) {
        
        let urlParameter: Parameters = ["page": page,
                                        "size": size,
                                        "statusFilter": statusFilter,
                                        "sourceFilter": sourceFilter,
                                        "search": search,
                                        "leadListTagFilter": leadListTagFilter
        ]
        var components = URLComponents(string: ApiUrl.getLeadList)
        components?.queryItems = self.requestManager.queryItems(from: urlParameter)
        let url = (components?.url)!
        
        self.requestManager.request(forPath: url.absoluteString, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[leadListModel], GrowthNetworkError>) in
            
            switch result {
            case .success(let leadListData):
                if search != "" || page == 0 {
                    self.leadListPeginationList = []
                }
                self.setUpData(leadListData: leadListData)
                self.delegate?.leadListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func setUpData(leadListData: [leadListModel]) {
        for item in leadListData {
            if item.totalCount == nil {
                self.leadListPeginationList?.append(item)
            }else{
                self.totalCount = item.totalCount ?? 0
            }
        }
    }
    
    func leadListDataAtIndex(index: Int)-> leadListModel? {
        return self.leadListPeginationList?[index]
    }
    
    func leadListFilterDataAtIndex(index: Int)-> leadListModel? {
        return self.leadFilterList[index]
    }
    
    func leadPeginationListDataAtIndex(index: Int) -> leadListModel? {
        return self.leadListPeginationList?[index]
    }
    
}

extension leadListViewModel: leadListViewModelProtocol {
    
    var leadListTotalCount: Int {
        return totalCount
    }
    
    var getleadListData : [leadListModel] {
        return self.leadList
    }
    
    var getleadListFilterData : [leadListModel] {
        return self.leadFilterList
    }
    
    var getleadPeginationListData: [leadListModel] {
        return self.leadListPeginationList ?? []
    }
}
