//
//  ServicesViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation


protocol ServiceListViewModelProtocol {
    func getServiceList()
    var  serviceData: [ServiceList] { get }
    func serviceDataAtIndex(index: Int) -> ServiceList?
    var  serviceFilterDataData: [ServiceList] { get }
    func serviceFilterDataAtIndex(index: Int)-> ServiceList?
}

class ServiceListViewModel {
    var delegate: ServicesListViewContollerProtocol?
    var serviceListData: [ServiceList] = []
    var serviceFilterData: [ServiceList] = []
    
    init(delegate: ServicesListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getServiceList() {
        self.requestManager.request(forPath: ApiUrl.getAllServices, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ServiceListModel, GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.serviceListData = userData.serviceList ?? []
                self.delegate?.serviceListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func serviceDataAtIndex(index: Int)-> ServiceList? {
        return self.serviceListData[index]
    }
    
    func serviceFilterDataAtIndex(index: Int)-> ServiceList? {
        return self.serviceListData[index]
    }
}

extension ServiceListViewModel: ServiceListViewModelProtocol {
    
    var serviceFilterDataData: [ServiceList] {
        return self.serviceFilterData
    }
    
    var serviceData: [ServiceList] {
        return self.serviceListData
    }
}
