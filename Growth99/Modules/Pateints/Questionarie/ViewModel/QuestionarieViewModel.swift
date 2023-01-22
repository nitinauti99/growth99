//
//  QuestionarieViewModel.swift
//  Growth99
//
//  Created by nitin auti on 21/01/23.
//

import Foundation

protocol QuestionarieViewModelProtocol {
    func getQuestionarieList(pateintId: Int)
    var QuestionarieDataList: [QuestionarieListModel] { get }
    func QuestionarieDataAtIndex(index: Int) -> QuestionarieListModel?
    var QuestionarieFilterDataData: [QuestionarieListModel] { get }
    func QuestionarieFilterDataDataAtIndex(index: Int)-> QuestionarieListModel?
}

class QuestionarieViewModel {
    var delegate: QuestionarieViewControllerProtocol?
    var QuestionarieData: [QuestionarieListModel] = []
    var QuestionarieFilterData: [QuestionarieListModel] = []
    
    init(delegate: QuestionarieViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionarieList(pateintId: Int) {
        let finaleUrl = ApiUrl.patientsQuestionnaireList + "\(pateintId)" + "/questionnaire"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[QuestionarieListModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.QuestionarieData = userData
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

extension QuestionarieViewModel: QuestionarieViewModelProtocol {
   
    var QuestionarieDataList: [QuestionarieListModel] {
        return self.QuestionarieData
    }
    
    var QuestionarieFilterDataData: [QuestionarieListModel] {
        return self.QuestionarieFilterData
    }
}
