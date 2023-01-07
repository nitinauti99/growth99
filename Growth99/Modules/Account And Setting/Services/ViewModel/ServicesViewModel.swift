//
//  ServicesViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

protocol ServicesListViewModelProtocol {
    func getUserList()
    var  userData: [ServiceList] { get }
    func userDataAtIndex(index: Int) -> ServiceList?
    var  userFilterDataData: [ServiceList] { get }
    func userFilterDataDataAtIndex(index: Int)-> ServiceList?
}

class ServicesListViewModel {
    var delegate: ServicesListViewContollerProtocol?
    var servicesListData: [ServiceList] = []
    var servicesFilterData: [ServiceList] = []
    var allServices: [ServiceList]?
    
    init(delegate: ServicesListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getUserList() {
        self.requestManager.request(forPath: ApiUrl.getAllServices, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[ServiceList], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.servicesListData = userData
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func userDataAtIndex(index: Int)-> ServiceList? {
        return self.servicesListData[index]
    }
    
    func userFilterDataDataAtIndex(index: Int)-> ServiceList? {
        return self.servicesListData[index]
    }
}

extension ServicesListViewModel: ServicesListViewModelProtocol {
    
    var userFilterDataData: [ServiceList] {
        return self.servicesFilterData
    }
    
    var userData: [ServiceList] {
        return self.servicesListData
    }
}
