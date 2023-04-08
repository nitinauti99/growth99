//
//  ConsentsViewModel.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import Foundation

protocol AddNewConsentsViewModelProtocol {
    func getConsentsList()
    func getConsentsDataAtIndex(index: Int) -> AddNewConsentsModel?
    func getConsentsFilterDataAtIndex(index: Int)-> AddNewConsentsModel?
    func sendConsentsListToPateint(patient:Int, consentsIds:[AddNewConsentsModel])
    func filterData(searchText: String)
    var  getConsentsDataList: [AddNewConsentsModel] { get }
    var  getConsentsFilterData: [AddNewConsentsModel] { get }
}

class AddNewConsentsViewModel {
    var delegate: AddNewConsentsViewControllerProtocol?
    var consentsData: [AddNewConsentsModel] = []
    var consentsFilterData: [AddNewConsentsModel] = []
    
    init(delegate: AddNewConsentsViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getConsentsList() {
        self.requestManager.request(forPath: ApiUrl.patientsConsentsList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[AddNewConsentsModel], GrowthNetworkError>) in
            switch result {
            case .success(let ConsentsList):
                self.consentsData = ConsentsList
                self.delegate?.ConsentsListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func sendConsentsListToPateint(patient:Int, consentsIds:[AddNewConsentsModel]) {
        let str = ApiUrl.createConsentPatients.appending("\(patient)/consents/assign?consentIds=")
        
        let finaleUrl = str + consentsIds.map { String($0.id ?? 0) }.joined(separator: ",")
        
        let urlParameter: [String: Any] = [
            "consentIds": consentsIds.map { String($0.id ?? 0) }.joined(separator: ","),
        ]
        self.requestManager.request(forPath: finaleUrl, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.consnetSendToPateintSuccessfully()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "Unable to assign consents to patient.")
                } else{
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func filterData(searchText: String) {
        self.consentsFilterData = self.consentsData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func getConsentsDataAtIndex(index: Int)-> AddNewConsentsModel? {
        return self.consentsData[index]
    }
    
    func getConsentsFilterDataAtIndex(index: Int)-> AddNewConsentsModel? {
        return self.consentsFilterData[index]
    }
}

extension AddNewConsentsViewModel: AddNewConsentsViewModelProtocol {
    
    var getConsentsDataList: [AddNewConsentsModel] {
        return self.consentsData
    }
    
    var getConsentsFilterData: [AddNewConsentsModel] {
        return self.consentsFilterData
    }
}
