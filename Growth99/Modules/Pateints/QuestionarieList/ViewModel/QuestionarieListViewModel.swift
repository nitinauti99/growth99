//
//  QuestionarieListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 24/01/23.
//

import Foundation

protocol QuestionarieListViewModelProtocol {
    func getQuestionarieList()
    var QuestionarieDataList: [QuestionarieListModel] { get }
    func QuestionarieDataAtIndex(index: Int) -> QuestionarieListModel?
    var QuestionarieFilterDataData: [QuestionarieListModel] { get }
    func QuestionarieFilterDataDataAtIndex(index: Int)-> QuestionarieListModel?
}

class QuestionarieListViewModel {
    var delegate: QuestionarieListViewControllerProtocol?
    var QuestionarieData: [QuestionarieListModel] = []
    var QuestionarieFilterData: [QuestionarieListModel] = []
    
    init(delegate: QuestionarieListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionarieList() {
        self.requestManager.request(forPath: ApiUrl.patientsQuestionnaireList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[QuestionarieListModel], GrowthNetworkError>) in
            switch result {
            case .success(let questionarieList):
                self.QuestionarieData = questionarieList
                self.delegate?.LeadDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func QuestionarieDataAtIndex(index: Int)-> QuestionarieListModel? {
        return self.QuestionarieData[index]
    }
    
    func QuestionarieFilterDataDataAtIndex(index: Int)-> QuestionarieListModel? {
        return self.QuestionarieFilterDataData[index]
    }
}

extension QuestionarieListViewModel: QuestionarieListViewModelProtocol {
   
    var QuestionarieDataList: [QuestionarieListModel] {
        return self.QuestionarieData
    }
    
    var QuestionarieFilterDataData: [QuestionarieListModel] {
        return self.QuestionarieFilterData
    }
}
