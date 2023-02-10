//
//  ConsentsViewModel.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//


import Foundation

protocol ConsentsTemplateListViewModelProtocol {
    var getConsentsTemplateListData: [ConsentsTemplateListModel] { get }
    var consentsTemplateFilterListData: [ConsentsTemplateListModel] { get }

    func getConsentsTemplateList()
    func consentsTemplateDataAtIndex(index: Int) -> ConsentsTemplateListModel?
}

class ConsentsTemplateListViewModel {
    var delegate: ConsentsTemplateListViewControllerProtocol?
    var consentsTemplateListData: [ConsentsTemplateListModel] = []
    var ConsentsTemplateFilterData: [ConsentsTemplateListModel] = []
        
    init(delegate: ConsentsTemplateListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
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
    
    func consentsTemplateDataAtIndex(index: Int)-> ConsentsTemplateListModel? {
        return self.consentsTemplateListData[index]
    }
}

extension ConsentsTemplateListViewModel: ConsentsTemplateListViewModelProtocol {

    var consentsTemplateFilterListData: [ConsentsTemplateListModel] {
        return self.consentsTemplateListData
    }
    
    var getConsentsTemplateListData: [ConsentsTemplateListModel] {
        return self.consentsTemplateListData
    }
    
    
}
