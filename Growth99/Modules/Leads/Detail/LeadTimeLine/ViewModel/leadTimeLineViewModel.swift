//
//  leadTimeLineViewModel.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation

protocol leadTimeLineViewModelProtocol {
    func leadCreation(leadId: Int)
    func getLeadTimeData(leadId: Int)
    func leadTimeLineDataAtIndex(index: Int)-> auditLeadModel?
    func getTimeLineTemplateData(leadId: Int)
    
    var getLeadTimeLineData: [auditLeadModel]? { get }
    var getCreationData: leadCreationModel? { get }

}

class leadTimeLineViewModel {
    var delegate: leadTimeLineViewControllerProtocol?
    
    var leadCreation: leadCreationModel?
    var leadTimeLineList: [auditLeadModel]?

    init(delegate: leadTimeLineViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)

    
    func leadCreation(leadId: Int) {
        let finaleURL = ApiUrl.leadCreation +  "\(leadId)/lead-creation"
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<leadCreationModel, GrowthNetworkError>) in
            switch result {
            case .success(let list):
                self.leadCreation = list
                self.delegate?.recivedLeadCreation()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getLeadTimeData(leadId: Int) {
        let finalURL = ApiUrl.auditleadCreation +  "leadId=\(leadId)"
        self.requestManager.request(forPath: finalURL, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[auditLeadModel], GrowthNetworkError>) in
            switch result {
            case .success(let list):
                self.leadTimeLineList = list
                self.delegate?.recivedAuditLeadList()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTimeLineTemplateData(leadId: Int) {
        let finaleURL = "https://api.growthemr.com/api/v1/audit/lead/content?id=" +  "\(leadId)"
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                print(list)
                //self.pateintsTimeLineData = list
                self.delegate?.recivedLeadTimeLineTemplateData()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    
    func leadTimeLineDataAtIndex(index: Int)-> auditLeadModel? {
        return self.leadTimeLineList?[index]
    }
    
}

extension leadTimeLineViewModel: leadTimeLineViewModelProtocol {
 
    var getCreationData: leadCreationModel? {
        return self.leadCreation
    }
   
    var getLeadTimeLineData: [auditLeadModel]? {
        return self.leadTimeLineList ?? []
    }
}
