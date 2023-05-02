//
//  CreateFormViewModel.swift
//  Growth99
//
//  Created by nitin auti on 13/02/23.
//

import Foundation

protocol CreateFormViewModelProtocol {
    func saveCreateForm(formData:[String: Any])    
}

class CreateFormViewModel {
    var delegate: CreateFormViewControllerProtocol?
    
    init(delegate: CreateFormViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func saveCreateForm(formData:[String: Any]) {
        self.requestManager.request(forPath: ApiUrl.createFrom, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: formData, encoding: .jsonEncoding)) { (result: Result<CreateFormModel, GrowthNetworkError>) in
            switch result {
            case .success(let FormData):
                print(FormData)
                self.delegate?.FormsDataRecived(message: "Form Data Saved Successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension CreateFormViewModel: CreateFormViewModelProtocol {
    
    
    
}
