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
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getFormList() {
        self.requestManager.request(forPath: ApiUrl.FormsList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[FormListModel], GrowthNetworkError>) in
            switch result {
            case .success(let FormData):
                self.FormListData = FormData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
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
                    self.delegate?.consentsRemovedSuccefully(message: "The Questionnaire has been deleted.")
                }else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "Internal server error")
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
        self.FormFilterData = self.FormListData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
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
