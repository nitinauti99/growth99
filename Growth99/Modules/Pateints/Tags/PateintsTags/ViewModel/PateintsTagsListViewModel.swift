//
//  PateintsTagsListViewModel.swift
//  Growth99
//
//  Created by nitin auti on 29/01/23.
//

import Foundation

protocol PateintsTagsListViewModelProtocol {
    func getQuestionarieList()
    var QuestionarieDataList: [PateintsTagListModel] { get }
    func QuestionarieDataAtIndex(index: Int) -> PateintsTagListModel?
    var QuestionarieFilterDataData: [PateintsTagListModel] { get }
    func QuestionarieFilterDataDataAtIndex(index: Int)-> PateintsTagListModel?
    func removePateintsTag(pateintsTagid: Int)
}

class PateintsTagsListViewModel {
    var delegate: PateintsTagsListViewControllerProtocol?
    var QuestionarieData: [PateintsTagListModel] = []
    var QuestionarieFilterData: [PateintsTagListModel] = []
    
    init(delegate: PateintsTagsListViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionarieList() {
        self.requestManager.request(forPath: ApiUrl.patientTagList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[PateintsTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.QuestionarieData = pateintsTagList
                self.delegate?.pateintsTagListRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removePateintsTag(pateintsTagid: Int) {
        self.requestManager.request(forPath: ApiUrl.removePatientsTags.appending("\(pateintsTagid)"), method: .DELETE, headers: self.requestManager.Headers()) { (result: Result< PateintsTagRemove, GrowthNetworkError>) in
            
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.pateintTagRemovedSuccefully(mrssage: data.success ?? "")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func QuestionarieDataAtIndex(index: Int)-> PateintsTagListModel? {
        return self.QuestionarieData[index]
    }
    
    func QuestionarieFilterDataDataAtIndex(index: Int)-> PateintsTagListModel? {
        return self.QuestionarieFilterDataData[index]
    }
}

extension PateintsTagsListViewModel: PateintsTagsListViewModelProtocol {
   
   
    var QuestionarieDataList: [PateintsTagListModel] {
        return self.QuestionarieData
    }
    
    var QuestionarieFilterDataData: [PateintsTagListModel] {
        return self.QuestionarieFilterData
    }
}
