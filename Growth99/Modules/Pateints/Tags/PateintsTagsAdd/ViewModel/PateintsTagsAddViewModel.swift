//
//  PateintsTagsAddViewModel.swift
//  Growth99
//
//  Created by nitin auti on 29/01/23.
//

import Foundation

protocol PateintsTagsAddViewModelProtocol {
    func pateintsTagsDetails(pateintsTagId:Int)
    func savePateintsTagsDetails(pateintsTagId:Int, name: String)
    func createPateintsTagsDetails(name: String)
    var pateintsTagsDetailsData: PateintsTagListModel? { get }
}

class PateintsTagsAddViewModel {
    var delegate: PateintsTagsAddViewControllerProtocol?
    var pateintsTagsDetailsDict: PateintsTagListModel?
    
    init(delegate: PateintsTagsAddViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func pateintsTagsDetails(pateintsTagId: Int) {
        let finaleUrl = ApiUrl.patientAddTags + "\(pateintsTagId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< PateintsTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.pateintsTagsDetailsDict = pateintsTagDict
                self.delegate?.pateintsTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func savePateintsTagsDetails(pateintsTagId:Int, name: String){
        let finaleUrl = ApiUrl.patientAddTags + "\(pateintsTagId)"
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< PateintsTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.pateintsTagsDetailsDict = pateintsTagDict
                self.delegate?.savePateintsTagList(responseMessage:"Pateints Tags details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createPateintsTagsDetails(name: String){
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: ApiUrl.patientCreateTags, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< PateintsTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.pateintsTagsDetailsDict = pateintsTagDict
                self.delegate?.savePateintsTagList(responseMessage:"Pateints Tags details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension PateintsTagsAddViewModel: PateintsTagsAddViewModelProtocol {

    var pateintsTagsDetailsData: PateintsTagListModel? {
        return self.pateintsTagsDetailsDict
    }
}
