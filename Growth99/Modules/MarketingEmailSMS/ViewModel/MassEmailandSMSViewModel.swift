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
    
    func removeSelectedMassEmail(MassEmailId: Int)
}

class MassEmailandSMSViewModel {
    var delegate: MassEmailandSMSViewContollerProtocol?
    var massEmailList: [MassEmailandSMSModel] = []
    var massEmailListFilterData: [MassEmailandSMSModel] = []
    
    init(delegate: MassEmailandSMSViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getMassEmailandSMS() {
        self.requestManager.request(forPath: ApiUrl.getAllEmailandSMS, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[MassEmailandSMSModel], GrowthNetworkError>) in
            switch result {
            case .success(let massEMailandSMSData):
                self.massEmailList = massEMailandSMSData
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
}

extension MassEmailandSMSViewModel: MassEmailandSMSViewModelProtocol {
    func removeSelectedMassEmail(MassEmailId: Int) {
        
    }
    
    func getMassEmailandSMSFilterData(searchText: String) {
        self.massEmailListFilterData = (self.getMassEmailandSMSData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
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
