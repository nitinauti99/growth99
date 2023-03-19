//
//  ConsentsViewModel.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//


import Foundation

protocol ConsentsTemplateListViewModelProtocol {
    var getConsentsTemplateListData: [ConsentsTemplateListModel] { get }
    var getConsentsTemplateFilterListData: [ConsentsTemplateListModel] { get }
    func getConsentsTemplateList()
    func filterData(searchText: String)
    func consentsTemplateDataAtIndex(index: Int) -> ConsentsTemplateListModel?
    func consentsTemplateFilterDataAtIndex(index: Int)-> ConsentsTemplateListModel?
    func removeConsents(consentsId: Int)
}

class ConsentsTemplateListViewModel {
    var delegate: ConsentsTemplateListViewControllerProtocol?
    var consentsTemplateListData: [ConsentsTemplateListModel] = []
    var consentsTemplateFilterData: [ConsentsTemplateListModel] = []
    
    init(delegate: ConsentsTemplateListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getConsentsTemplateList() {
        self.requestManager.request(forPath: ApiUrl.consentsTemplatesList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[ConsentsTemplateListModel], GrowthNetworkError>) in
            switch result {
            case .success(let ConsentsTemplateData):
                self.consentsTemplateListData = ConsentsTemplateData
                self.delegate?.ConsentsTemplatesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeConsents(consentsId: Int) {
        let finaleUrl = ApiUrl.removeConsents + "\(consentsId)"

        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.consentsRemovedSuccefully(mrssage: "Consents removed successfully")
                }else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "To Delete These Consents Form, Please remove it for the service attched")
                }else{
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.consentsTemplateFilterData = (self.consentsTemplateListData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        print(self.consentsTemplateFilterData)
    }
    
    func consentsTemplateFilterDataAtIndex(index: Int) -> ConsentsTemplateListModel? {
        return self.consentsTemplateFilterData[index]
    }
    
    func consentsTemplateDataAtIndex(index: Int)-> ConsentsTemplateListModel? {
        return self.consentsTemplateListData[index]
    }
}

extension ConsentsTemplateListViewModel: ConsentsTemplateListViewModelProtocol {
    
    var getConsentsTemplateFilterListData: [ConsentsTemplateListModel] {
        return self.consentsTemplateFilterData
    }
    
    var getConsentsTemplateListData: [ConsentsTemplateListModel] {
        return self.consentsTemplateListData
    }
    
}
