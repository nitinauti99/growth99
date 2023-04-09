//
//  ServicesViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation


protocol ServiceListViewModelProtocol {
    func getServiceList()
    
    func getServiceFilterData(searchText: String)
    
    func getServiceDataAtIndex(index: Int)-> ServiceList?
    func getServiceFilterDataAtIndex(index: Int)-> ServiceList?
    
    var  getServiceListData: [ServiceList] { get }
    var  getServiceFilterListData: [ServiceList] { get }
    func removeSelectedCService(serviceId: Int)
}

class ServiceListViewModel {
    var delegate: ServicesListViewContollerProtocol?
   
    var serviceList: [ServiceList] = []
    var serviceFilterData: [ServiceList] = []
    
    init(delegate: ServicesListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getServiceList() {
        self.requestManager.request(forPath: ApiUrl.getAllServices, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ServiceListModel, GrowthNetworkError>) in
            switch result {
            case .success(let serviceData):
                self.serviceList = serviceData.serviceList?.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)}) ?? []
                self.delegate?.serviceListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeSelectedCService(serviceId: Int) {
        self.requestManager.request(forPath: ApiUrl.editService.appending("\(serviceId)"), method: .DELETE, headers: self.requestManager.Headers()) { (result: Result< PateintsTagRemove, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.serviceRemovedSuccefully(message: data.success ?? String.blank)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension ServiceListViewModel: ServiceListViewModelProtocol {

    func getServiceFilterData(searchText: String) {
        self.serviceFilterData = self.getServiceListData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func getServiceDataAtIndex(index: Int)-> ServiceList? {
        return self.getServiceListData[index]
    }
    
    func getServiceFilterDataAtIndex(index: Int)-> ServiceList? {
        return self.serviceFilterData[index]
    }
    
    var getServiceListData: [ServiceList] {
        return self.serviceList
    }
   
    var getServiceFilterListData: [ServiceList] {
         return self.serviceFilterData
    }
}
