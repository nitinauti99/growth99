//
//  LeadTagsAddViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

protocol LeadTagsAddViewModelProtocol {
    func LeadTagsDetails(leadTagId:Int)
    func saveLeadTagsDetails(leadTagId:Int, name: String)
    func createLeadTagsDetails(name: String)
    var LeadTagsDetailsData: PateintsTagListModel? { get }
}

class LeadTagsAddViewModel {
    var delegate: LeadTagsAddViewControllerProtocol?
    var LeadTagsDetailsDict: PateintsTagListModel?
    
    init(delegate: LeadTagsAddViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func LeadTagsDetails(leadTagId: Int) {
        let finaleUrl = ApiUrl.getLeadTagDetail + "\(leadTagId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< PateintsTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.LeadTagsDetailsDict = pateintsTagDict
                self.delegate?.pateintsTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func saveLeadTagsDetails(leadTagId:Int, name: String){
        let finaleUrl = ApiUrl.updateLeadTags + "\(leadTagId)"
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< PateintsTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.LeadTagsDetailsDict = pateintsTagDict
                self.delegate?.savePateintsTagList(responseMessage:"Pateints Tags details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createLeadTagsDetails(name: String){
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: ApiUrl.creatLeadTags, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< PateintsTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.LeadTagsDetailsDict = pateintsTagDict
                self.delegate?.savePateintsTagList(responseMessage:"Pateints Tags details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension LeadTagsAddViewModel: LeadTagsAddViewModelProtocol {

    var LeadTagsDetailsData: PateintsTagListModel? {
        return self.LeadTagsDetailsDict
    }
}
