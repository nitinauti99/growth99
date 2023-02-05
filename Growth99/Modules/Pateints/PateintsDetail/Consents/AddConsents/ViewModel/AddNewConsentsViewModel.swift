//
//  ConsentsViewModel.swift
//  Growth99
//
//  Created by nitin auti on 05/02/23.
//

import Foundation

protocol AddNewConsentsViewModelProtocol {
    func getConsentsList()
    var ConsentsDataList: [AddNewConsentsModel] { get }
    func ConsentsDataAtIndex(index: Int) -> AddNewConsentsModel?
    var ConsentsFilterDataData: [AddNewConsentsModel] { get }
    func ConsentsFilterDataDataAtIndex(index: Int)-> AddNewConsentsModel?
    func sendConsentsListToPateint(questionnaireIds: (Int, Int))
}

class AddNewConsentsViewModel {
    var delegate: AddNewConsentsViewControllerProtocol?
    var ConsentsData: [AddNewConsentsModel] = []
    var ConsentsFilterData: [AddNewConsentsModel] = []
    
    init(delegate: AddNewConsentsViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getConsentsList() {
        self.requestManager.request(forPath: ApiUrl.patientsConsentsList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[AddNewConsentsModel], GrowthNetworkError>) in
            switch result {
            case .success(let ConsentsList):
                self.ConsentsData = ConsentsList
                self.delegate?.ConsentsListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func sendConsentsListToPateint(questionnaireIds: (Int, Int)) {
//
//        self.requestManager.request(forPath: ApiUrl.createTaskUser, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                print(response)
//                self.delegate?.taskUserCreatedSuccessfully(responseMessage: "task User Created Successfully")
//            case .failure(let error):
//                self.delegate?.errorReceived(error: error.localizedDescription)
//            }
//        }
    }
    
    func ConsentsDataAtIndex(index: Int)-> AddNewConsentsModel? {
        return self.ConsentsData[index]
    }
    
    func ConsentsFilterDataDataAtIndex(index: Int)-> AddNewConsentsModel? {
        return self.ConsentsFilterDataData[index]
    }
}

extension AddNewConsentsViewModel: AddNewConsentsViewModelProtocol {
   
    var ConsentsDataList: [AddNewConsentsModel] {
        return self.ConsentsData
    }
    
    var ConsentsFilterDataData: [AddNewConsentsModel] {
        return self.ConsentsFilterData
    }
}
