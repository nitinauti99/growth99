//
//  PateintListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation

protocol PateintListViewModelProtocol {
    func getUserList()
    var UserData: [PateintListModel] { get }
    func userDataAtIndex(index: Int) -> PateintListModel?
    var UserFilterDataData: [PateintListModel] { get }
    func userFilterDataDataAtIndex(index: Int)-> PateintListModel?
}

class PateintListViewModel {
    var delegate: PateintListViewContollerProtocol?
    var PateintListData: [PateintListModel] = []
    var PateintFilterData: [PateintListModel] = []

    init(delegate: PateintListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getUserList() {
        self.requestManager.request(forPath: ApiUrl.patientsList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PateintListModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.PateintListData = userData
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
 
    func userDataAtIndex(index: Int)-> PateintListModel? {
        return self.PateintListData[index]
    }
    
    func userFilterDataDataAtIndex(index: Int)-> PateintListModel? {
        return self.PateintFilterData[index]
    }
}

extension PateintListViewModel: PateintListViewModelProtocol {
    
    
    var UserFilterDataData: [PateintListModel] {
        return self.PateintFilterData
    }
   
    var UserData: [PateintListModel] {
        return self.PateintListData
    }

 
}
