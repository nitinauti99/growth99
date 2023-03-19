//
//  CreateLabelViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 18/03/23.
//

import Foundation

protocol CreateLabelViewModelProtocol {
    func getCreateLabelDetails(labelId: Int)
    func upadteCreateLabelDetails(labelId: Int, name: String)
    func createLabelDetails(name: String)
  
    var  getCreateLabelDetailsData: LabelListModel? { get }
}

class CreateLabelViewModel {
    var delegate: CreateLabelViewControllerProtocol?
  
    var socialProfileDetails: LabelListModel?
    
    init(delegate: CreateLabelViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getCreateLabelDetails(labelId:Int) {
        let finaleUrl = ApiUrl.createMediaPostLabels + "/\(labelId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<LabelListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.socialProfileDetails = pateintsTagDict
                self.delegate?.createCreateLabelListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func upadteCreateLabelDetails(labelId:Int, name: String) {
        let finaleUrl = ApiUrl.createMediaPostLabels + "/\(labelId)"
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result<LabelListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.socialProfileDetails = pateintsTagDict
                self.delegate?.saveCreateSocialList(responseMessage:"Pateints Tags details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createLabelDetails(name: String){
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: ApiUrl.createMediaPostLabels, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result<LabelListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.socialProfileDetails = pateintsTagDict
                self.delegate?.saveCreateSocialList(responseMessage:"Pateints Tags details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension CreateLabelViewModel: CreateLabelViewModelProtocol {

    var getCreateLabelDetailsData: LabelListModel? {
        return self.socialProfileDetails
    }
}
