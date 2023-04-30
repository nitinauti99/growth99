//
//  MediaTagsAddViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import Foundation

protocol MediaTagsAddViewModelProtocol {
    func getMediaTagsDetails(mediaTagId: Int)
    func saveMediaTagsDetails(mediaTagId:Int, name: String)
    func createMediaTagsDetails(name: String)
    
    var mediaTagsDetailsData: MediaTagListModel? { get }
}

class MediaTagsAddViewModel {
    var delegate: MediaTagsAddViewControllerProtocol?
    var mediaTagsDetailsDict: MediaTagListModel?
    
    init(delegate: MediaTagsAddViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getMediaTagsDetails(mediaTagId: Int) {
        let finaleUrl = ApiUrl.mediaTagUrl + "\(mediaTagId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result< MediaTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let mediaTagDict):
                self.mediaTagsDetailsDict = mediaTagDict
                self.delegate?.mediaTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func saveMediaTagsDetails(mediaTagId:Int, name: String){
        let finaleUrl = ApiUrl.mediaTagUrl + "\(mediaTagId)"
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< MediaTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let mediaTagsDetails):
                self.mediaTagsDetailsDict = mediaTagsDetails
                self.delegate?.saveMediaTagList(responseMessage:"Tag updated successfully.")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createMediaTagsDetails(name: String){
        let parameters: Parameters = [
            "name": name,
            "isDefault":false
        ]
        self.requestManager.request(forPath: ApiUrl.mediaTagUrl, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  (result: Result< MediaTagListModel, GrowthNetworkError>) in
            switch result {
            case .success(let mediaTagsDetails):
                self.mediaTagsDetailsDict = mediaTagsDetails
                self.delegate?.saveMediaTagList(responseMessage:"Tag created successfully.")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension MediaTagsAddViewModel: MediaTagsAddViewModelProtocol {

    var mediaTagsDetailsData: MediaTagListModel? {
        return self.mediaTagsDetailsDict
    }
}
