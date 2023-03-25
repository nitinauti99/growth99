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
    
    /// get PostImage From lbrariesList
    func getSocialPostImageFromLbrariesList(page: Int,size: Int, search: String, tags: Int)
    var getSocialPostImageList: [Content] { get }
    func getSocialPostImageListDataAtIndex(index: Int)-> Content?

    
    /// create patients user
    func createPost(name: String, description: String, workflowTaskStatus: String, workflowTaskUser: Int, deadline: String, workflowTaskPatient: Int, questionnaireSubmissionId: Int, leadOrPatient: String)
      
}

class CreatePostViewModel {
  
    var socialMediaPostLabelsListData: [SocialMediaPostLabelsList] = []
    var socialProfilesListData: [SocialProfilesList] = []
    var socialPostData: PostsListModel?
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
        self.requestManager.request(forPath: ApiUrl.createSocialMediaPost.appending("/\(postId)"), method: .GET, headers: self.requestManager.Headers()) {  (result: Result< PostsListModel, GrowthNetworkError>) in
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
    
    /// get image from imageLibrary
    func getSocialPostImageFromLbrariesList(page: Int,size: Int, search: String, tags: Int) {
        let url = "page=\(page)&size=\(size)&search=\(search)&tags="
      
        self.requestManager.request(forPath: ApiUrl.socialMediaLibraries.appending(url), method: .GET, headers: self.requestManager.Headers()) {  (result: Result< MediaLibraryListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.socialPostImageList = pateintsTagList.content ?? []
                self.delegate?.socialPostImageListRecived()
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
    
    func getSocialPostImageListDataAtIndex(index: Int)-> Content? {
        return self.socialPostImageList[index]
    }


}

extension CreatePostViewModel: CreatePostViewModelProtocol {
    
   
    var getSocialMediaPostLabelsListData: [SocialMediaPostLabelsList] {
        return self.socialMediaPostLabelsListData
    }

    var getSocialProfilesListData: [SocialProfilesList] {
        return self.socialProfilesListData
    }

    var getSocialPostImageList: [Content] {
        return self.getSocialPostImageList
    }
        
}
