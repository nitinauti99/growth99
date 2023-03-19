//
//  CombineTimeLineViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation

protocol CombineTimeLineViewModelProtocol {
    func leadCreation(leadId: Int)
    func getLeadTimeData(leadId: Int)
    func leadTimeLineDataAtIndex(index: Int)-> CombineTimeLineModel?

    var getLeadTimeLineData: [CombineTimeLineModel]? { get }
    var getCreationData: leadCreationModel? { get }

}

class CombineTimeLineViewModel {
    var delegate: CombineTimeLineViewControllerProtocol?
    
    var leadCreation: leadCreationModel?
    var leadTimeLineList: [CombineTimeLineModel]?
    let user = UserRepository.shared

    init(delegate: CombineTimeLineViewControllerProtocol? = nil) {
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
        let finalURL = ApiUrl.combineLeadTimeLine.appending("\(self.user.primaryEmailId ?? "")") +  "&leadId=\(leadId)"
        self.requestManager.request(forPath: finalURL, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[CombineTimeLineModel], GrowthNetworkError>) in
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
    
    func leadTimeLineDataAtIndex(index: Int)-> CombineTimeLineModel? {
        return self.leadTimeLineList?[index]
    }
    
}

extension CombineTimeLineViewModel: CombineTimeLineViewModelProtocol {
 
    var getCreationData: leadCreationModel? {
        return self.leadCreation
    }
   
    var getLeadTimeLineData: [CombineTimeLineModel]? {
        return self.leadTimeLineList ?? []
    }
}
