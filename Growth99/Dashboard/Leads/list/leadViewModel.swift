//
//  leadViewModel.swift
//  Growth99
//
//  Created by nitin auti on 03/12/22.
//

import Foundation

protocol leadViewModelProtocol {
    func getLeadList(page: Int, size: Int, statusFilter: String, sourceFilter: String, search: String, leadTagFilter: String)
    var leadUserData: [leadModel] { get }
    func leadDataAtIndex(index: Int) -> leadModel

}

class leadViewModel {
    var delegate: leadViewControllerProtocol?
    var leadData: [leadModel] = []
    var leadPeginationListData: [leadModel] = []
    
    init(delegate: leadViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getLeadList(page: Int, size: Int, statusFilter: String, sourceFilter: String, search: String, leadTagFilter: String) {
        let urlParameter: Parameters = ["page": page,
                                        "size": size,
                                        "statusFilter": statusFilter,
                                        "sourceFilter": sourceFilter,
                                        "search": search,
                                        "leadTagFilter": leadTagFilter
        ]
        var components = URLComponents(string: ApiUrl.getLeadList)
        components?.queryItems = self.requestManager.queryItems(from: urlParameter)
        let url = (components?.url)!
        
        self.requestManager.request(forPath: url.absoluteString, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[leadModel], GrowthNetworkError>) in
            
            switch result {
            case .success(let LeadData):
                self.leadData = LeadData
                self.setPaginationData()
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func setPaginationData(){
        if self.leadPeginationListData.count == 0 {
            self.leadPeginationListData = self.leadData
        } else {
            self.leadPeginationListData.append(contentsOf: leadData)
        }
    }
    
    func leadDataAtIndex(index: Int)-> leadModel {
        return self.leadPeginationListData[index]
    }
    
}

extension leadViewModel: leadViewModelProtocol {
    var leadUserData: [leadModel] {
        return self.leadPeginationListData
    }
}
