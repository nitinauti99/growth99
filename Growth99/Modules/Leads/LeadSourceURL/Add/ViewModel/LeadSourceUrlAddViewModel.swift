//
//  AddLeadSourceUrlListViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

protocol LeadSourceUrlAddViewModelProtocol {
    func LeadSourceUrlDetails(leadTagId:Int)
    func updateLeadSourceUrlDetails(leadTagId:Int, name: String)
    func createLeadSourceUrlDetails(name: String)
    var LeadSourceUrlDetailsData: LeadSourceUrlListModel? { get }
}

class LeadSourceUrlAddViewModel {
    var delegate: LeadSourceUrlAddViewControllerProtocol?
    var LeadSourceUrlDetailsDict: LeadSourceUrlListModel?
    
    init(delegate: LeadSourceUrlAddViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func LeadSourceUrlDetails(leadTagId: Int) {
        let finaleUrl = ApiUrl.getLeadSourceUrl + "\(leadTagId)"
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< LeadSourceUrlListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.LeadSourceUrlDetailsDict = pateintsTagDict
                self.delegate?.leadSourceUrlListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func updateLeadSourceUrlDetails(leadTagId:Int, name: String){
        let finaleUrl = ApiUrl.updateLeadSourceUrl + "\(leadTagId)"
        let parameters: Parameters = [
            "sourceUrl": name,
        ]
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.delegate?.updateLeadSourceUrlList(message:"Lead Source URL updated successfully.")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createLeadSourceUrlDetails(name: String){
        let parameters: Parameters = [
            "sourceUrl": name,
        ]
        self.requestManager.request(forPath: ApiUrl.creatLeadSourceUrl, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< LeadSourceUrlListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.LeadSourceUrlDetailsDict = pateintsTagDict
                self.delegate?.createdLeadSourceUrlList(message:"Lead Source URL created successfully.")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension LeadSourceUrlAddViewModel: LeadSourceUrlAddViewModelProtocol {
    
    var LeadSourceUrlDetailsData: LeadSourceUrlListModel? {
        return self.LeadSourceUrlDetailsDict
    }
}
