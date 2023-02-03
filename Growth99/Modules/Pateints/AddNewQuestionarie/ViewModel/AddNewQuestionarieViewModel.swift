//
//  AddNewQuestionarieModel.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import Foundation

protocol AddNewQuestionarieViewModelProtocol {
    func getQuestionarieList()
    var QuestionarieDataList: [AddNewQuestionarieModel] { get }
    func QuestionarieDataAtIndex(index: Int) -> AddNewQuestionarieModel?
    var QuestionarieFilterDataData: [AddNewQuestionarieModel] { get }
    func QuestionarieFilterDataDataAtIndex(index: Int)-> AddNewQuestionarieModel?
    func sendQuestionarieListToPateint(questionnaireIds: (Int, Int))
}

class AddNewQuestionarieViewModel {
    var delegate: AddNewQuestionarieViewControllerProtocol?
    var QuestionarieData: [AddNewQuestionarieModel] = []
    var QuestionarieFilterData: [AddNewQuestionarieModel] = []
    
    init(delegate: AddNewQuestionarieViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionarieList() {
        self.requestManager.request(forPath: ApiUrl.patientsQuestionnaireList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[AddNewQuestionarieModel], GrowthNetworkError>) in
            switch result {
            case .success(let questionarieList):
                self.QuestionarieData = questionarieList
                self.delegate?.questionarieListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func sendQuestionarieListToPateint(questionnaireIds: (Int, Int)) {
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
    
    func QuestionarieDataAtIndex(index: Int)-> AddNewQuestionarieModel? {
        return self.QuestionarieData[index]
    }
    
    func QuestionarieFilterDataDataAtIndex(index: Int)-> AddNewQuestionarieModel? {
        return self.QuestionarieFilterDataData[index]
    }
}

extension AddNewQuestionarieViewModel: AddNewQuestionarieViewModelProtocol {
   
    var QuestionarieDataList: [AddNewQuestionarieModel] {
        return self.QuestionarieData
    }
    
    var QuestionarieFilterDataData: [AddNewQuestionarieModel] {
        return self.QuestionarieFilterData
    }
}
