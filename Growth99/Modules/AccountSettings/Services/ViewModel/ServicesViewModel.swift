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
}

class ServiceListViewModel {
    var delegate: ServicesListViewContollerProtocol?
   
    var serviceList: [ServiceList] = []
    var serviceFilterData: [ServiceList] = []
    
    init(delegate: ServicesListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getServiceList() {
        self.requestManager.request(forPath: ApiUrl.getAllServices, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ServiceListModel, GrowthNetworkError>) in
            switch result {
            case .success(let serviceData):
                self.serviceList = serviceData.serviceList ?? []
                self.delegate?.serviceListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension ServiceListViewModel: ServiceListViewModelProtocol {

    func getServiceFilterData(searchText: String) {
        self.serviceFilterData = (self.getServiceListData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
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
