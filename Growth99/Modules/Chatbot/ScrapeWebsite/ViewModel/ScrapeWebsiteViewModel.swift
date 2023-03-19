//
//  ScrapeWebsiteViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation

protocol ScrapeWebsiteViewModelProtocol {
    func updateChatConfigData(url: String)
    
}

class ScrapeWebsiteViewModel {
    var delegate: ScrapeWebsiteViewControllerProtocol?
  
    
    init(delegate: ScrapeWebsiteViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
  
    
    func updateChatConfigData(url: String) {
        let param: [String: Any] = [
            "scrapWebsiteUrl": url
        ]
        self.requestManager.request(forPath: ApiUrl.scrapeURL, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: param, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.delegate?.scrapeWebsiteDataUpdatedSuccessfully()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
         }
     }
    
}

extension ScrapeWebsiteViewModel: ScrapeWebsiteViewModelProtocol {
    

}
