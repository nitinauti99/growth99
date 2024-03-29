//
//  FormListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 13/02/23.
//

import Foundation

protocol FormListViewModelProtocol {
    var getFormListData: [FormListModel] { get }
    var getFormFilterListData: [FormListModel] { get }
    func getFormList()
    func filterData(searchText: String)
    func FormDataAtIndex(index: Int) -> FormListModel?
    func formFilterDataAtIndex(index: Int)-> FormListModel?
    func removeConsents(consentsId: Int)
}

class FormListViewModel {
    var delegate: FormListViewControllerProtocol?
    var FormListData: [FormListModel] = []
    var FormFilterData: [FormListModel] = []
    
    init(delegate: FormListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getFormList() {
        self.requestManager.request(forPath: ApiUrl.FormsList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[FormListModel], GrowthNetworkError>) in
            switch result {
            case .success(let FormData):
                self.FormListData = FormData.reversed()
                self.delegate?.FormsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeConsents(consentsId: Int) {
        let finaleUrl = ApiUrl.removeQuestionnaire + "\(consentsId)"

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
        self.FormFilterData = (self.FormListData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        print(self.FormFilterData)
    }
    
    func formFilterDataAtIndex(index: Int) -> FormListModel? {
        return self.FormFilterData[index]
    }
    
    func FormDataAtIndex(index: Int)-> FormListModel? {
        return self.FormListData[index]
    }
}

extension FormListViewModel: FormListViewModelProtocol {
    
    var getFormFilterListData: [FormListModel] {
        return self.FormFilterData
    }
    
    var getFormListData: [FormListModel] {
        return self.FormListData
    }
    
}
