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
    func createMediaLibraryDetails(tageId: [Int], imageData: String)
    
    var getSocialMediaTagListData: [MediaTagListModel]? { get }
    var mediaMediaLibraryDetailsData: MediaTagListModel? { get }
}

class MediaLibraryAddViewModel {
    var delegate: MediaLibraryAddViewControllerProtocol?
    var mediaMediaLibraryDetailsDict: MediaTagListModel?
    var socialMediaTagListData: [MediaTagListModel]?
    
    init(delegate: MediaLibraryAddViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
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
    
    func getMediaLibraryDetails(mediaTagId: Int) {
        let finaleUrl = ApiUrl.mediaTagUrl + "\(mediaTagId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< MediaTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let mediaTagDict):
                self.mediaMediaLibraryDetailsDict = mediaTagDict
                self.delegate?.socialMediaTagListRecived()
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
                self.mediaMediaLibraryDetailsDict = mediaMediaLibraryDetails
                self.delegate?.saveMediaTagList(responseMessage:"Media MediaLibrary details Saved")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createMediaLibraryDetails(tageId: [Int], imageData: String) {
        let parameters: Parameters = [
            "tags": tageId.map { String($0) }.joined(separator: ","),
            "file": imageData
        ]
        self.requestManager.request(forPath: ApiUrl.socialMediaLibrary, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< MediaTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let mediaMediaLibraryDetails):
                self.mediaMediaLibraryDetailsDict = mediaMediaLibraryDetails
                self.delegate?.saveMediaTagList(responseMessage:"Media MediaLibrary details Saved")
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

    var mediaMediaLibraryDetailsData: MediaTagListModel? {
        return self.mediaMediaLibraryDetailsDict
    }
}
