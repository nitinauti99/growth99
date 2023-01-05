//
//  leadTimeLineViewModel.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation

protocol leadTimeLineViewModelProtocol {
    func leadCreation(leadId: Int)
    func auditLeadList(leadId: Int)
    var leadCreatiionData: [auditLeadModel]? { get }
    var leadCreationData: leadCreationModel? { get }

}

class leadTimeLineViewModel {
    var delegate: leadTimeLineViewControllerProtocol?
    
    var leadCreation: leadCreationModel?
    var auditLead: [auditLeadModel]?

    init(delegate: leadTimeLineViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))

    
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
    
    func auditLeadList(leadId: Int) {
        let finalURL = ApiUrl.auditleadCreation +  "leadId=\(leadId)"
        self.requestManager.request(forPath: finalURL, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[auditLeadModel], GrowthNetworkError>) in
            switch result {
            case .success(let list):
                self.auditLead = list
                self.delegate?.recivedAuditLeadList()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

}

extension leadTimeLineViewModel: leadTimeLineViewModelProtocol {
 
    var leadCreationData: leadCreationModel? {
        return self.leadCreation
    }
   
    var leadCreatiionData: [auditLeadModel]? {
        return self.auditLead ?? []
    }
    
   
}
