//
//  leadDetailViewModel.swift
//  Growth99
//
//  Created by nitin auti on 21/12/22.
//

import Foundation

protocol leadDetailViewProtocol {
    func getQuestionnaireList(questionnaireId: Int)
    var questionnaireDetailListData: [QuestionAnswers]? { get }
}

class leadDetailViewModel {
    var delegate: leadDetailViewControllerProtocol?
    var questionnaireDetailList = [QuestionAnswers]()

    init(delegate: leadDetailViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionnaireList(questionnaireId: Int) {
        let finaleUrl = ApiUrl.getQuestionnaireDetailList + "\(questionnaireId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<QuestionnaireDetailList, GrowthNetworkError>) in
            switch result {
            case .success(let questionnaireList):
                self.questionnaireDetailList = questionnaireList.questionAnswers ?? []
                self.delegate?.recivedQuestionnaireList()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }   
}

extension leadDetailViewModel: leadDetailViewProtocol {
   
    var questionnaireDetailListData: [QuestionAnswers]? {
        return self.questionnaireDetailList
    }
}
