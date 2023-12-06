//
//  TwoWayViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 06/12/23.
//

import Foundation

protocol TwoWayListViewModelProtocol {
    func getTwoWayList(pageNo: Int, pageSize: Int)
    func getTwoWayFilterData(searchText: String)
    func getTwoWayDataAtIndex(index: Int)-> AuditLogsList?
    func getTwoWayFilterDataAtIndex(index: Int)-> AuditLogsList?
    var  getTwoWayData: [AuditLogsList] { get }
    var  getTwoWayFilterData: [AuditLogsList] { get }
}

class TwoWayListViewModel {
    var delegate: TwoWayListViewContollerProtocol?
    var twoWayListData: [AuditLogsList] = []
    var twoWayFilterData: [AuditLogsList] = []
    var headers: HTTPHeaders {
        return ["x-tenantid": UserRepository.shared.Xtenantid ?? String.blank,
                "Authorization": "Bearer "+(UserRepository.shared.authToken ?? String.blank)
        ]
    }
    init(delegate: TwoWayListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getTwoWayList(pageNo: Int, pageSize: Int) {
        let url = "\(ApiUrl.twoWayText)\(pageNo)&pageSize=\(pageSize)&searchText="
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<TwoWayModel, GrowthNetworkError>) in
            switch result {
            case .success(let twoWayListData):
                self.twoWayListData = twoWayListData.auditLogsList ?? []
                print( self.twoWayListData)
                self.delegate?.twoWayListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension TwoWayListViewModel: TwoWayListViewModelProtocol {

    func getTwoWayFilterData(searchText: String) {
        self.twoWayFilterData = self.getTwoWayData.filter { (task: AuditLogsList) -> Bool in
            let searchText = searchText.lowercased()
            let nameMatch = task.leadFullName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.sourceId ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }

    }
    
    func getTwoWayDataAtIndex(index: Int)-> AuditLogsList? {
        return self.getTwoWayData[index]
    }
    
    func getTwoWayFilterDataAtIndex(index: Int)-> AuditLogsList? {
        return self.twoWayFilterData[index]
    }
    
    var getTwoWayData: [AuditLogsList] {
        return self.twoWayListData
    }
    
    var getTwoWayFilterData: [AuditLogsList] {
        return self.twoWayFilterData
    }
}
