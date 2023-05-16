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
    func sendEmailTemplate(template: String)
    func sendSMSTemplate(template: String)
    func updatePateintStatus(template: String)
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func sendCustomSMS(leadId: Int, phoneNumber: String, body: String)
    func sendCustomEmail(leadId: Int, email: String,subject:String, body: String)
    func updatePateintsInfo(pateintId: Int, inputString: String, ansString: String)
    
    var pateintsDetailListData: PateintsDetailListModel? { get }
    var smsTemplateListData: [SMStemplatesListDetailModel]? { get }
    var emailTemplateListData: [EmailTemplatesListDetailModel]? { get }
}

class PateintDetailViewModel {
    var delegate: PateintDetailViewControllerProtocol?
    var pateintsDetailList: PateintsDetailListModel?

    var smstemplatesListDetail = [SMStemplatesListDetailModel]()
    var emailTemplatesListDetail = [EmailTemplatesListDetailModel]()

    init(delegate: PateintDetailViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getpateintsList(pateintId: Int) {
        let finaleUrl = ApiUrl.patientsDetailList + "\(pateintId)"

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
    
    func sendSMSTemplate(template: String) {
        self.requestManager.request(forPath: ApiUrl.sendSMSToPateints.appending(template), method: .POST, headers: self.requestManager.Headers()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
                    self.delegate?.smsSend(responseMessage: "SMS sent successfully")
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while sending SMS")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func sendEmailTemplate(template: String) {
        self.requestManager.request(forPath: ApiUrl.sendSMSToPateints.appending(template), method: .POST, headers: self.requestManager.Headers()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
                    self.delegate?.smsSend(responseMessage: "Email sent successfully")
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while sending Email")
                }
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
                self.delegate?.updatedLeadStatusRecived(responseMessage: "Patient status updated successfully")
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
                self.delegate?.updatedPateintsInfo(responseMessage: "Patient edited successfully")
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
        self.requestManager.request(forPath: ApiUrl.sendCustomsms, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.smsSendSuccessfully(responseMessage: "SMS sent successfully")
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
                self.delegate?.emailSendSuccessfully(responseMessage: "Email sent successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
}

extension PateintDetailViewModel: PateintDetailViewModelProtocol {
    
    var smsTemplateListData: [SMStemplatesListDetailModel]? {
        return self.smstemplatesListDetail
    }
    
    var emailTemplateListData: [EmailTemplatesListDetailModel]? {
        return self.emailTemplatesListDetail
    }
    
    var pateintsDetailListData: PateintsDetailListModel? {
        return self.pateintsDetailList
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let regex = Constant.Regex.phone
        let isPhoneNo = NSPredicate(format:"SELF MATCHES %@", regex)
        return isPhoneNo.evaluate(with: phoneNumber)
    }
    
}
