//
//  leadDetailViewModel.swift
//  Growth99
//
//  Created by nitin auti on 21/12/22.
//

import Foundation

protocol leadDetailViewProtocol {
    func getQuestionnaireList(questionnaireId: Int)
    func getSMSDefaultList()
    func getEmailDefaultList()
    var questionnaireDetailListData: [QuestionAnswers]? { get }
    var smsTemplateListData: [SMStemplatesListDetailModel]? { get }
    var emailTemplateListData: [EmailTemplatesListDetailModel]? { get }
    func sendTemplate(template: String)
    func updateLeadStatus(template: String)
    var leadStatus:String { get }
    func sendCustomSMS(leadId: Int, phoneNumber: String, body: String)
    func sendCustomEmail(leadId: Int, email: String,subject:String, body: String)

}

class leadDetailViewModel {
    var delegate: leadDetailViewControllerProtocol?
    var questionnaireDetailList: QuestionnaireDetailList?

    var smstemplatesListDetail = [SMStemplatesListDetailModel]()
    var emailTemplatesListDetail = [EmailTemplatesListDetailModel]()

    init(delegate: leadDetailViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getQuestionnaireList(questionnaireId: Int) {
        let finaleUrl = ApiUrl.getQuestionnaireDetailList + "\(questionnaireId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<QuestionnaireDetailList, GrowthNetworkError>) in
            switch result {
            case .success(let questionnaireList):
                self.questionnaireDetailList = questionnaireList
                self.delegate?.recivedQuestionnaireList()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getSMSDefaultList() {
        self.requestManager.request(forPath: ApiUrl.getSMStemplatesListDetail, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[SMStemplatesListDetailModel], GrowthNetworkError>) in
            switch result {
            case .success(let smsTemplateList):
                self.smstemplatesListDetail = smsTemplateList
                self.delegate?.recivedSmsTemplateList()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getEmailDefaultList() {
        self.requestManager.request(forPath: ApiUrl.getEmailTemplatesListDetail, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[EmailTemplatesListDetailModel], GrowthNetworkError>) in
            switch result {
            case .success(let emailTemplateList):
                self.emailTemplatesListDetail = emailTemplateList
                self.delegate?.recivedEmailTemplateList()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func sendTemplate(template: String) {
        self.requestManager.request(forPath: ApiUrl.updateQuestionnaireSubmission.appending(template), method: .OPTIONS, headers: self.requestManager.Headers()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.smsSend(responseMessage: "SMS Send Successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func updateLeadStatus(template: String) {
        self.requestManager.request(forPath: ApiUrl.updateQuestionnaireSubmission.appending(template), method: .PUT, headers: self.requestManager.Headers()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.updatedLeadStatusRecived(responseMessage: "Lead Status updated Successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func sendCustomSMS(leadId: Int, phoneNumber: String, body: String) {
        let urlParameter: Parameters = [
            "leadId": leadId,
            "phoneNumber": phoneNumber,
            "body": body,
        ]
        self.requestManager.request(forPath: ApiUrl.sendCustomsms, method: .OPTIONS, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.smsSendSuccessfully(responseMessage: "sms send Successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func sendCustomEmail(leadId: Int, email: String, subject:String, body: String) {
        let urlParameter: Parameters = [
            "leadId": leadId,
            "phoneNumber": email,
            "subject": subject,
            "body": body,
        ]
        self.requestManager.request(forPath: ApiUrl.sendCustomEmail, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.emailSendSuccessfully(responseMessage: "email send Successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }


}

extension leadDetailViewModel: leadDetailViewProtocol {
  
    var leadStatus: String {
        return  self.questionnaireDetailList?.leadStatus ?? String.blank
    }

    var smsTemplateListData: [SMStemplatesListDetailModel]? {
        return self.smstemplatesListDetail
    }
    
    var emailTemplateListData: [EmailTemplatesListDetailModel]? {
        return self.emailTemplatesListDetail
    }
    
    var questionnaireDetailListData: [QuestionAnswers]? {
        return self.questionnaireDetailList?.questionAnswers ?? []
    }
    
}
