//
//  PateintListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation

protocol PateintListViewModelProtocol {
    func getPateintList()
    func pateintDataAtIndex(index: Int) -> PateintListModel?
    func pateintFilterDataAtIndex(index: Int)-> PateintListModel?
    func removePateints(pateintId: Int)
    func filterData(searchText: String)
    var  getPateintData: [PateintListModel] { get }
    var  getPateintFilterData: [PateintListModel] { get }
}

class PateintListViewModel {
    var delegate: PateintListViewContollerProtocol?
    var pateintListData: [PateintListModel] = []
    var pateintFilterData: [PateintListModel] = []
    
    init(delegate: PateintListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getPateintList() {
        self.requestManager.request(forPath: ApiUrl.patientsList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PateintListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintData):
                self.pateintListData = pateintData
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
                self.delegate?.pateintRemovedSuccefully(mrssage: "Pateints deleted successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
          }
    }
    
    func pateintDataAtIndex(index: Int)-> PateintListModel? {
        return self.pateintListData[index]
    }
    
    func filterData(searchText: String) {
        self.pateintFilterData = self.pateintListData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func pateintFilterDataAtIndex(index: Int)-> PateintListModel? {
        return self.pateintFilterData[index]
    }
}

extension PateintListViewModel: PateintListViewModelProtocol {
    
    var getPateintFilterData: [PateintListModel] {
        return self.pateintFilterData
    }
    
    var getPateintData: [PateintListModel] {
        return self.pateintListData
    }
    
}
