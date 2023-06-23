//
//  massEmailandSMSViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

protocol MassEmailandSMSViewModelProtocol {
    func getMassEmailandSMS()
    func getSwitchOnButton(massEmailandSMSId: String, massEmailandSMStatus: String)
    
    func getMassEmailandSMSFilterData(searchText: String)
    
    func getMassEmailandSMSDataAtIndex(index: Int)-> MassEmailandSMSModel?
    func getMassEmailandSMSFilterDataAtIndex(index: Int)-> MassEmailandSMSModel?
    
    var  getMassEmailandSMSData: [MassEmailandSMSModel] { get }
    var  getMassEmailandSMSFilterData: [MassEmailandSMSModel] { get }
    func removeSelectedMassEmail(massEmailId: Int)
}

class MassEmailandSMSViewModel {
    var delegate: MassEmailandSMSViewContollerProtocol?
    var massEmailList: [MassEmailandSMSModel] = []
    var massEmailListFilterData: [MassEmailandSMSModel] = []
    
    init(delegate: MassEmailandSMSViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getMassEmailandSMS() {
        self.requestManager.request(forPath: ApiUrl.getAllEmailandSMS, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[MassEmailandSMSModel], GrowthNetworkError>) in
            switch result {
            case .success(let massEMailandSMSData):
                self.massEmailList = massEMailandSMSData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
                self.delegate?.massEmailandSMSDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getSwitchOnButton(massEmailandSMSId: String, massEmailandSMStatus: String) {
        let parameter: [String: Any] = [massEmailandSMStatus: ""]
        let url = "\(ApiUrl.getAllEmailandSMS)/status\(massEmailandSMSId)"
        self.requestManager.request(forPath: url, method: .PUT,task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<[MassEmailandSMSModel], GrowthNetworkError>) in
            switch result {
            case .success(let massEmailandSMSData):
                self.massEmailList = massEmailandSMSData
                self.delegate?.massEmailandSMSDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeSelectedMassEmail(massEmailId: Int) {
        let finaleUrl = ApiUrl.editTrigger.appending("\(massEmailId)")
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.delegate?.mailSMSDeletedSuccefully(message: "Trigger deleted successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
}

extension MassEmailandSMSViewModel: MassEmailandSMSViewModelProtocol {
   
    func getMassEmailandSMSFilterData(searchText: String) {
        self.massEmailListFilterData = self.getMassEmailandSMSData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let moduleMatch = task.moduleName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let executionStatusMatch = task.executionStatus?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || moduleMatch || executionStatusMatch || idMatch
        }
    }
    
    func getMassEmailandSMSDataAtIndex(index: Int)-> MassEmailandSMSModel? {
        return self.getMassEmailandSMSData[index]
    }
    
    func getMassEmailandSMSFilterDataAtIndex(index: Int)-> MassEmailandSMSModel? {
        return self.massEmailListFilterData[index]
    }
    
    var getMassEmailandSMSData: [MassEmailandSMSModel] {
        return self.massEmailList
    }
    
    var getMassEmailandSMSFilterData: [MassEmailandSMSModel] {
        return self.massEmailListFilterData
    }
}
