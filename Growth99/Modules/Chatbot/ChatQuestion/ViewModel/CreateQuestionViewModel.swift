//
//  CreateQuestionViewModelProtocol.swift
//  Growth99
//
//  Created by Nitin Auti on 07/03/23.
//

import Foundation


protocol CreateQuestionViewModelProtocol {
    func updateQuestion(question: String, answer:String, referenceLink: String, chatQuestionId: Int, questionareId: Int)

    func createQuestion(question: String, answer:String, referenceLink: String, chatQuestionId: Int)
    func isValidUrl(url: String) -> Bool
}

class CreateQuestionViewModel {
    var delegate: CreateQuestionViewContollerProtocol?
    
    init(delegate: CreateQuestionViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    /// api is used for create chat Questionnaire
    func createQuestion(question: String, answer:String, referenceLink: String, chatQuestionId: Int) {
        let parameters: Parameters = [
            "question": question,
            "answer": answer,
            "referenceLink": referenceLink,
        ]
        let finalURL = ApiUrl.createChatQuestion.appending("\(chatQuestionId)/chatquestions")
        
        self.requestManager.request(forPath: finalURL, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.chatQuestionCreated(message: "Question Created successfully.")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
        
    }
    
    func updateQuestion(question: String, answer:String, referenceLink: String, chatQuestionId: Int, questionareId: Int){
        let parameters: Parameters = [
            "question": question,
            "answer": answer,
            "referenceLink": referenceLink,
            "id": questionareId

        ]
        let finalURL = ApiUrl.createChatQuestion.appending("\(chatQuestionId)/chatquestions")
        
        self.requestManager.request(forPath: finalURL, method: .POST, headers: self.requestManager.Headers(),task:.requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.chatQuestionUpdated(message: "Question added successfully.")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension CreateQuestionViewModel: CreateQuestionViewModelProtocol {
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = Constant.Regex.urlValidation
        let isUrl = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        return isUrl.evaluate(with: url)
    }
}
