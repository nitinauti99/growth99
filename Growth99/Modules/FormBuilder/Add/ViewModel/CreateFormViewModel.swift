//
//  CreateFormViewModel.swift
//  Growth99
//
//  Created by nitin auti on 13/02/23.
//

import Foundation

protocol CreateFormViewModelProtocol {
    var getCreateFormData: [CreateFormModel] { get }
    var getFormFilterListData: [CreateFormModel] { get }
    func getCreateForm()
    func filterData(searchText: String)
    func FormDataAtIndex(index: Int) -> CreateFormModel?
    func FormFilterDataAtIndex(index: Int)-> CreateFormModel?
    func removeConsents(consentsId: Int)
}

class CreateFormViewModel {
    var delegate: CreateFormViewControllerProtocol?
    var CreateFormData: [CreateFormModel] = []
    var FormFilterData: [CreateFormModel] = []
    
    init(delegate: CreateFormViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getCreateForm() {
        self.requestManager.request(forPath: ApiUrl.FormsList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[CreateFormModel], GrowthNetworkError>) in
            switch result {
            case .success(let FormData):
                self.CreateFormData = FormData
                self.delegate?.FormsDataRecived()
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
        self.FormFilterData = (self.CreateFormData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        print(self.FormFilterData)
    }
    
    func FormFilterDataAtIndex(index: Int) -> CreateFormModel? {
        return self.FormFilterData[index]
    }
    
    func FormDataAtIndex(index: Int)-> CreateFormModel? {
        return self.CreateFormData[index]
    }
}

extension CreateFormViewModel: CreateFormViewModelProtocol {
    
    var getFormFilterListData: [CreateFormModel] {
        return self.FormFilterData
    }
    
    var getCreateFormData: [CreateFormModel] {
        return self.CreateFormData
    }
    
}
