//
//  QuestionarieViewModel.swift
//  Growth99
//
//  Created by nitin auti on 21/01/23.
//

import Foundation

protocol QuestionarieViewModelProtocol {
    func getQuestionarieList(pateintId: Int)
    var QuestionarieDataList: [QuestionarieModel] { get }
    func QuestionarieDataAtIndex(index: Int) -> QuestionarieModel?
    var QuestionarieFilterDataData: [QuestionarieModel] { get }
    func QuestionarieFilterDataDataAtIndex(index: Int)-> QuestionarieModel?
}

class QuestionarieViewModel {
    var delegate: QuestionarieViewControllerProtocol?
    var QuestionarieData: [QuestionarieModel] = []
    var QuestionarieFilterData: [QuestionarieModel] = []
    
    init(delegate: QuestionarieViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionarieList(pateintId: Int) {
        let finaleUrl = ApiUrl.patientsQuestionnaire + "\(pateintId)" + "/questionnaire"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[QuestionarieModel], GrowthNetworkError>) in
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
    
    func QuestionarieDataAtIndex(index: Int)-> QuestionarieModel? {
        return self.QuestionarieData[index]
    }
    
    func QuestionarieFilterDataDataAtIndex(index: Int)-> QuestionarieModel? {
        return self.QuestionarieFilterDataData[index]
    }
}

extension QuestionarieViewModel: QuestionarieViewModelProtocol {
   
    var QuestionarieDataList: [QuestionarieModel] {
        return self.QuestionarieData
    }
    
    var QuestionarieFilterDataData: [QuestionarieModel] {
        return self.QuestionarieFilterData
    }
}
