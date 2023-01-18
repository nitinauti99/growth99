//
//  PateintDetailViewModel.swift
//  Growth99
//
//  Created by nitin auti on 04/01/23.
//

import Foundation

protocol PateintDetailViewModelProtocol {
    func getpateintsList(pateintId: Int)
    func getSMSDefaultList()
    func getEmailDefaultList()
    var pateintsDetailListData: PateintsDetailListModel? { get }
    var smsTemplateListData: [SMStemplatesListDetailModel]? { get }
    var emailTemplateListData: [EmailTemplatesListDetailModel]? { get }
    func sendTemplate(template: String)
    func updatePateintStatus(template: String)
   // var leadStatus:String { get }
    func sendCustomSMS(leadId: Int, phoneNumber: String, body: String)
    func sendCustomEmail(leadId: Int, email: String,subject:String, body: String)
    func updatePateintsInfo(pateintId: Int, inputString: String, ansString: String)

}

class PateintDetailViewModel {
    var delegate: PateintDetailViewControllerProtocol?
    var pateintsDetailList: PateintsDetailListModel?

    var smstemplatesListDetail = [SMStemplatesListDetailModel]()
    var emailTemplatesListDetail = [EmailTemplatesListDetailModel]()

    init(delegate: PateintDetailViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getpateintsList(pateintId: Int) {
        let finaleUrl = ApiUrl.patientsDetaiilList + "\(pateintId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<PateintsDetailListModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintsLis):
                self.pateintsDetailList = pateintsLis
                self.delegate?.recivedPateintDetail()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getSMSDefaultList() {
        self.requestManager.request(forPath: ApiUrl.smstemplates, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[SMStemplatesListDetailModel], GrowthNetworkError>) in
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
        self.requestManager.request(forPath: ApiUrl.emailTemplates, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[EmailTemplatesListDetailModel], GrowthNetworkError>) in
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
        self.requestManager.request(forPath: ApiUrl.smstemplates.appending(template), method: .OPTIONS, headers: self.requestManager.Headers()) { [weak self] result in
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
    
    func updatePateintStatus(template: String) {
        self.requestManager.request(forPath: ApiUrl.patientsStatus.appending(template), method: .PUT, headers: self.requestManager.Headers()) { [weak self] result in
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
    
    
    func updatePateintsInfo(pateintId: Int, inputString: String, ansString: String) {
        let urlParameter: Parameters = [
            inputString: ansString,
        ]
        
        self.requestManager.request(forPath: ApiUrl.updatePatientsInfo.appending("\(pateintId)"), method: .PATCH, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.updatedPateintsInfo(responseMessage: "Pateints Information updated Successfully")
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

extension PateintDetailViewModel: PateintDetailViewModelProtocol {
    
//    var leadStatus: String {
//        return  self.questionnaireDetailList?.leadStatus ?? ""
//    }

    var smsTemplateListData: [SMStemplatesListDetailModel]? {
        return self.smstemplatesListDetail
    }
    
    var emailTemplateListData: [EmailTemplatesListDetailModel]? {
        return self.emailTemplatesListDetail
    }
    
    var pateintsDetailListData: PateintsDetailListModel? {
        return self.pateintsDetailList
    }
}
