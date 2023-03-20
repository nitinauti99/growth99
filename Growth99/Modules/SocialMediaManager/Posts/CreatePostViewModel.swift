//
//  CreatePostViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 20/03/23.
//

import Foundation


protocol CreatePostViewModelProtocol {
    ///get all task list
    func getSocialMediaPostLabelsList()
    var getSocialMediaPostLabelsListData: [SocialMediaPostLabelsList] { get }
    
    /// get all patients list
    func getsocialProfilesList()
    var getsocialProfilesListData: [SocialProfilesList] { get }
    
    /// create patients user
    func createPost(name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, workflowTaskPatient: Int, questionnaireSubmissionId: Int, leadOrPatient: String)
      
}

class CreatePostViewModel {
  
    var socialMediaPostLabelsListData: [SocialMediaPostLabelsList] = []
    var socialProfilesListData: [SocialProfilesList] = []

    var delegate: CreatePostViewControllerProtocol?
    
    init(delegate: CreatePostViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getSocialMediaPostLabelsList() {
        self.requestManager.request(forPath: ApiUrl.socialMediaPostLabelsList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[SocialMediaPostLabelsList], GrowthNetworkError>) in
            switch result {
            case .success(let socialMediaPostLabelsList):
                self.socialMediaPostLabelsListData = socialMediaPostLabelsList
                self.delegate?.socialMediaPostLabelsListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getsocialProfilesList() {
        self.requestManager.request(forPath: ApiUrl.socialProfilesList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[SocialProfilesList], GrowthNetworkError>) in
            switch result {
            case .success(let socialProfilesList):
                self.socialProfilesListData = socialProfilesList
                self.delegate?.socialProfilesListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createPost(name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, workflowTaskPatient: Int, questionnaireSubmissionId: Int, leadOrPatient: String){
        var urlParameter: Parameters = [
                "name": name,
                "description": description,
                "workflowTaskStatus": workflowTaskStatus,
                "workflowTaskUser": workflowTaskUser,
                "deadline": deadline,
                "workflowTaskPatient": NSNull(),
                "questionnaireSubmissionId": questionnaireSubmissionId,
                "leadOrPatient": leadOrPatient,
            ]
        
        self.requestManager.request(forPath: ApiUrl.createTaskUser, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.taskUserCreatedSuccessfully(responseMessage: "task User Created Successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }

}

extension CreatePostViewModel: CreatePostViewModelProtocol {
   
    var getSocialMediaPostLabelsListData: [SocialMediaPostLabelsList] {
        return self.socialMediaPostLabelsListData
    }

    var getsocialProfilesListData: [SocialProfilesList] {
        return self.socialProfilesListData
    }

}
