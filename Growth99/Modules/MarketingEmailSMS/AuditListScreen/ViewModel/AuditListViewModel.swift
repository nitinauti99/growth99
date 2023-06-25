//
//  massEmailandSMSViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

protocol AuditListViewModelProtocol {
    func getAuditInformation(auditId: Int, communicationType: String, triggerModule: String)
    func getAuditListFilterData(searchText: String)
    func getAuditDetailInformation(auditContentId: Int) 
    func getAuditListDataAtIndex(index: Int)-> AuditListModel?
    func getAuditListFilterDataAtIndex(index: Int)-> AuditListModel?
    var  getAuditListData: [AuditListModel] { get }
    var  getAuditListFilterData: [AuditListModel] { get }
}

class AuditListViewModel {
    var delegate: AuditListViewControllerProtocol?
    var auditList: [AuditListModel] = []
    var auditListFilterData: [AuditListModel] = []
    
    init(delegate: AuditListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    func getAuditInformation(auditId: Int, communicationType: String, triggerModule: String) {
        let url = "\(ApiUrl.auditInformation)\(auditId)?communicationType=\(communicationType)&triggerModule=\(triggerModule)"
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[AuditListModel], GrowthNetworkError>) in
            switch result {
            case .success(let auditListData):
                self.auditList = auditListData
                self.delegate?.auditListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getAuditDetailInformation(auditContentId: Int) {
        let url = "\(ApiUrl.auditDetailInformation)\(auditContentId)"
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<String, GrowthNetworkError>) in
            switch result {
            case .success(let auditListData):
                self.delegate?.auditListDetailInfoDataRecived(htmlContent: auditListData)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension AuditListViewModel: AuditListViewModelProtocol {
    func getAuditListFilterData(searchText: String) {
        self.auditListFilterData = self.getAuditListData.filter { task in
            let searchText = searchText.lowercased()
            let leadIdMatch = String(task.leadId ?? 0).prefix(searchText.count).elementsEqual(searchText)
            let patientIdMatch = String(task.patientId ?? 0).prefix(searchText.count).elementsEqual(searchText)
            let emailMatch = task.email?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let templateNameMatch = task.templateName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            return leadIdMatch || patientIdMatch || emailMatch || templateNameMatch
        }
    }
    
    func getAuditListDataAtIndex(index: Int)-> AuditListModel? {
        return self.getAuditListData[index]
    }
    
    func getAuditListFilterDataAtIndex(index: Int)-> AuditListModel? {
        return self.auditListFilterData[index]
    }
    
    var getAuditListData: [AuditListModel] {
        return self.auditList
    }
    
    var getAuditListFilterData: [AuditListModel] {
        return self.auditListFilterData
    }
}
