//
//  CreateSocialProfileViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 18/03/23.
//

import Foundation

protocol SocialProfileViewModelProtocol {
    func getSocialProfileDetails(socialProfileId:Int)
    func upadteSocialProfileDetails(socialProfileId:Int, name: String)
    func createSocialProfileDetails(name: String)
  
    var  getSocialProfileDetailsData: SocialProfilesListModel? { get }
}

class SocialProfileViewModel {
    var delegate: CreateSocialProfileViewControllerProtocol?
  
    var socialProfileDetails: SocialProfilesListModel?
    
    init(delegate: CreateSocialProfileViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getSocialProfileDetails(socialProfileId:Int) {
        let finaleUrl = ApiUrl.socialProfileList + "/\(socialProfileId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< SocialProfilesListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.socialProfileDetails = pateintsTagDict
                self.delegate?.createSocialProfileListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func upadteSocialProfileDetails(socialProfileId:Int, name: String) {
        let finaleUrl = ApiUrl.socialProfileList + "/\(socialProfileId)"
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< SocialProfilesListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.socialProfileDetails = pateintsTagDict
                self.delegate?.saveCreateSocialList(responseMessage:"Social profile channel updated successfully.")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createSocialProfileDetails(name: String){
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: ApiUrl.creatLeadTags, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< SocialProfilesListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagDict):
                self.socialProfileDetails = pateintsTagDict
                self.delegate?.saveCreateSocialList(responseMessage:"Social profile channel created successfully.")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension SocialProfileViewModel: SocialProfileViewModelProtocol {

    var getSocialProfileDetailsData: SocialProfilesListModel? {
        return self.socialProfileDetails
    }
}
