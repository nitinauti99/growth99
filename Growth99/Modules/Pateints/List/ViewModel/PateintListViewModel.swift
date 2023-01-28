//
//  PateintListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation

protocol PateintListViewModelProtocol {
    func getPateintList()
    var PateintData: [PateintListModel] { get }
    func PateintDataAtIndex(index: Int) -> PateintListModel?
    var pateintFilterDataData: [PateintListModel] { get }
    func pateintFilterDataDataAtIndex(index: Int)-> PateintListModel?
    func removePateints(pateintId: Int)
}

class PateintListViewModel {
    var delegate: PateintListViewContollerProtocol?
    var PateintListData: [PateintListModel] = []
    var pateintFilterData: [PateintListModel] = []
    
    init(delegate: PateintListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getPateintList() {
        self.requestManager.request(forPath: ApiUrl.patientsList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PateintListModel], GrowthNetworkError>) in
            switch result {
            case .success(let PateintData):
                self.PateintListData = PateintData
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removePateints(pateintId: Int) {
        let urlParameter: Parameters = [
            "userId": pateintId
        ]
        let finaleUrl = ApiUrl.removePatient + "userId=" + "\(pateintId)"
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.pateintRemovedSuccefully(mrssage: "Pateints removed successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
          }
    }
    
    func PateintDataAtIndex(index: Int)-> PateintListModel? {
        return self.PateintListData[index]
    }
    
    func pateintFilterDataDataAtIndex(index: Int)-> PateintListModel? {
        return self.pateintFilterData[index]
    }
}

extension PateintListViewModel: PateintListViewModelProtocol {
    
    
    var pateintFilterDataData: [PateintListModel] {
        return self.pateintFilterData
    }
    
    var PateintData: [PateintListModel] {
        return self.PateintListData
    }
    
    
}
