//
//  CreateCreateSMSTemplateViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation

protocol CreateSMSTemplateViewModelProtocol {
    func getCreateSMSTemplateList()
    func getCreateSMSTemplateistData(index: Int)-> CreateSMSTemplateModel

    var getSMSVariableListData: [CreateSMSTemplateModel] { get }
}

class CreateSMSTemplateViewModel {
   
    var delegate: CreateSMSTemplateViewControllerProtocol?
    var smsVariableListData: [CreateSMSTemplateModel] = []

    init(delegate: CreateSMSTemplateViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getCreateSMSTemplateList() {
        self.requestManager.request(forPath: ApiUrl.getMassSMSVariable, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[CreateSMSTemplateModel], GrowthNetworkError>) in
            switch result {
            case .success(let smsTemplateData):
                self.smsVariableListData = smsTemplateData
                self.delegate?.smsVarableTListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getCreateSMSTemplateistData(index: Int)-> CreateSMSTemplateModel {
        return self.smsVariableListData[index]
    }

}

extension CreateSMSTemplateViewModel: CreateSMSTemplateViewModelProtocol {
    
    var getSMSVariableListData: [CreateSMSTemplateModel] {
        return self.smsVariableListData
    }
}
