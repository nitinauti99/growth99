//
//  CreatePostViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 20/03/23.
//

import Foundation

protocol CreatePostViewModelProtocol {
    ///get all  SocialMediaPost list
    func getSocialMediaPostLabelsList()
    var getSocialMediaPostLabelsListData: [SocialMediaPostLabelsList] { get }
    
    /// get all SocialProfiles
    func getSocialProfilesList()
    var getSocialProfilesListData: [SocialProfilesList] { get }
    
    /// get social post
     func getSocialPost(postId: Int)
     var getSocailPostData: socialMediaPostModel? { get }
     
    /// create patients user
    func createPost(name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, workflowTaskPatient: Int, questionnaireSubmissionId: Int, leadOrPatient: String)
    
    func isValidHashTag(_ text: String)-> Bool
      
}

class CreatePostViewModel {
  
    var socialMediaPostLabelsListData: [SocialMediaPostLabelsList] = []
    var socialProfilesListData: [SocialProfilesList] = []
    var socialPostData: socialMediaPostModel?
    var socialPostImageList: [Content] = []
    
    var delegate: CreatePostViewControllerProtocol?
    var addImageDelegate: PostImageListViewControllerProtocol?
    
    init(delegate: CreatePostViewControllerProtocol? = nil, addImageDelegate : PostImageListViewControllerProtocol? = nil) {
        self.delegate = delegate
        self.addImageDelegate = addImageDelegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    // to get Social Media PostLabel list
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
    
    // to get social media social-profiles list
    func getSocialProfilesList() {
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
    
    // to get social post from list based selected id
    func getSocialPost(postId: Int) {
        self.requestManager.request(forPath: ApiUrl.createSocialMediaPost.appending("/\(postId)"), method: .GET, headers: self.requestManager.Headers()) {  (result: Result< socialMediaPostModel, GrowthNetworkError>) in
            switch result {
            case .success(let postsData):
                self.socialPostData = postsData
                self.delegate?.socialPostRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createPost(name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, workflowTaskPatient: Int, questionnaireSubmissionId: Int, leadOrPatient: String){
        let urlParameter: Parameters = [
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

    var getSocialProfilesListData: [SocialProfilesList] {
        return self.socialProfilesListData
    }
    
    var getSocailPostData: socialMediaPostModel? {
        return self.socialPostData
    }
    
    func isValidHashTag(_ text: String) -> Bool {
        let pattern = "^#[a-zA-Z0-9_]+$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = regex.matches(in: text, range: range)
        return !matches.isEmpty
    }
}
