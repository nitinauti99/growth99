//
//  PateintsTagsAddViewModel.swift
//  Growth99
//
//  Created by nitin auti on 29/01/23.
//

import Foundation

protocol PateintsTagsAddViewModelProtocol {
    func pateintsTagsDetails(pateintsTagId:Int)
    var pateintsTagsDetailsData: PateintsTagListModel? { get }
}

class PateintsTagsAddViewModel {
    var delegate: PateintsTagsAddViewControllerProtocol?
    var pateintsTagsDetailsDict: PateintsTagListModel?
    
    init(delegate: PateintsTagsAddViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
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
}

extension PateintsTagsAddViewModel: PateintsTagsAddViewModelProtocol {

    var pateintsTagsDetailsData: PateintsTagListModel? {
        return self.pateintsTagsDetailsDict
    }
}
