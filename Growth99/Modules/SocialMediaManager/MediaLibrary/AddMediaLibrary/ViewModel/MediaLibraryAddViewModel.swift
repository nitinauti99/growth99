//
//  CreateMediaLibraryViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import Foundation

protocol MediaLibraryAddViewModelProtocol {
    func getSocialMediaTagList()
    func getMediaLibraryDetails(mediaTagId: Int)
    func saveMediaLibraryDetails(mediaTagId:Int, name: String)
    func createMediaLibraryDetails(tageId: [Int], image: UIImage)
    
    var getSocialMediaTagListData: [MediaTagListModel]? { get }
    var getSocialMediaInfoDtails: Content? { get }
    var mediaMediaLibraryDetailsData: MediaTagListModel? { get }

}

class MediaLibraryAddViewModel {
    var delegate: MediaLibraryAddViewControllerProtocol?
  
    var socialMediaTagListData: [MediaTagListModel]?
    var socialMediaInfoDtails : Content?
    var mediaLibraryDetailsDict: MediaTagListModel?

    
    init(delegate: MediaLibraryAddViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    /// ge tag list for media
    func getSocialMediaTagList() {
        self.requestManager.request(forPath: ApiUrl.socialMediaTagList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< [MediaTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let socialMediaTagList):
                self.socialMediaTagListData = socialMediaTagList
                self.delegate?.socialMediaTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    // get edit media info details based media id
    func getMediaLibraryDetails(mediaTagId: Int) {
        let finaleUrl = ApiUrl.editSocialMediaLibrary + "/\(mediaTagId)"
        
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< Content, GrowthNetworkError>) in
            switch result {
            case .success(let mediaTagDict):
                self.socialMediaInfoDtails = mediaTagDict
                self.delegate?.mediaLibraryDetailsRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func saveMediaLibraryDetails(mediaTagId:Int, name: String){
        let finaleUrl = ApiUrl.mediaTagUrl + "\(mediaTagId)"
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< MediaTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let mediaMediaLibraryDetails):
                self.mediaLibraryDetailsDict = mediaMediaLibraryDetails
                self.delegate?.saveMediaTagList(responseMessage:"Media MediaLibrary details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createMediaLibraryDetails(tageId: [Int], image: UIImage) {
        let tagIds = tageId.map { String($0) }.joined(separator: ",")
        
        self.requestManager.request(requestable: MediaImage.upload(image: image.pngData() ?? Data(), str: tageId)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.saveMediaTagList(responseMessage:"Media MediaLibrary details Saved")
                } else {
                    self.delegate?.errorReceived(error: "error")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    
    }
}

extension MediaLibraryAddViewModel: MediaLibraryAddViewModelProtocol {
  
    var getSocialMediaTagListData: [MediaTagListModel]? {
        return self.socialMediaTagListData
    }
    
    var getSocialMediaInfoDtails: Content? {
        return self.socialMediaInfoDtails
    }
  
    var mediaMediaLibraryDetailsData: MediaTagListModel? {
        return self.mediaLibraryDetailsDict
    }
}
