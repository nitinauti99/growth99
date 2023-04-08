//
//  AddNewQuestionarieModel.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import Foundation

protocol AddNewQuestionarieViewModelProtocol {
    func getQuestionarieList()
    func questionarieDataAtIndex(index: Int) -> AddNewQuestionarieModel?
    func questionarieFilterDataAtIndex(index: Int)-> AddNewQuestionarieModel?
    func sendQuestionarieListToPateint(patient:Int, questionnaireIds:[AddNewQuestionarieModel])
    func filterData(searchText: String)
    var getQuestionarieDataList: [AddNewQuestionarieModel] { get }
    var getQuestionarieFilterData: [AddNewQuestionarieModel] { get }
}

class AddNewQuestionarieViewModel {
    var delegate: AddNewQuestionarieViewControllerProtocol?
    var questionarieData: [AddNewQuestionarieModel] = []
    var questionarieFilterData: [AddNewQuestionarieModel] = []
    
    init(delegate: AddNewQuestionarieViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getQuestionarieList() {
        self.requestManager.request(forPath: ApiUrl.patientsQuestionnaireList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[AddNewQuestionarieModel], GrowthNetworkError>) in
            switch result {
            case .success(let questionarieList):
                self.questionarieData = questionarieList
                self.delegate?.questionarieListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func sendQuestionarieListToPateint(patient:Int, questionnaireIds:[AddNewQuestionarieModel]) {
        let str = ApiUrl.getPatientsQuestionnaire.appending("\(patient)/questionnaire/assign?questionnaireIds=")
       
        let finaleUrl = str + questionnaireIds.map { String($0.id ?? 0) }.joined(separator: ",")

        let urlParameter: [String: Any] = [
            "questionnaireIds": questionnaireIds.map { String($0.id ?? 0) }.joined(separator: ","),
        ]
        
        self.requestManager.request(forPath: finaleUrl, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.questionarieSendToPateints()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func filterData(searchText: String) {
        self.questionarieFilterData = self.questionarieData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func questionarieDataAtIndex(index: Int)-> AddNewQuestionarieModel? {
        return self.questionarieData[index]
    }
    
    func questionarieFilterDataAtIndex(index: Int)-> AddNewQuestionarieModel? {
        return self.questionarieFilterData[index]
    }
}

extension AddNewQuestionarieViewModel: AddNewQuestionarieViewModelProtocol {
   
    var getQuestionarieDataList: [AddNewQuestionarieModel] {
        return self.questionarieData
    }
    
    var getQuestionarieFilterData: [AddNewQuestionarieModel] {
        return self.questionarieFilterData
    }
}
