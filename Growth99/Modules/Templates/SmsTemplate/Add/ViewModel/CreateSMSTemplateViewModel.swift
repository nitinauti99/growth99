//
//  CreateCreateSMSTemplateViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation

protocol CreateSMSTemplateViewModelProtocol {
    func getMassSMSVariablesList()
    func getAppointmentVariablesList()
    func getLeadVariablesList()
    func crateSMSTemplate(parameters: [String:Any])
    func updateSMSTemplate(smsTemplatesId:Int, parameters: [String:Any])
    func getSMSTemplateData(smsTemplateId: Int)

    func getMassSMSTemplateListData(index: Int)-> CreateSMSTemplateModel
    func getLeadTemplateListData(index: Int)-> CreateSMSTemplateModel
    func getAppointmentTemplateListData(index: Int)-> CreateSMSTemplateModel

    var getSMSVariableListData: [CreateSMSTemplateModel] { get }
    var getLeadVariableListData: [CreateSMSTemplateModel] { get }
    var getAppointMentVariableListData: [CreateSMSTemplateModel] { get }
    var getSMSTemplateListData: smsTemplateDataModel? { get }

}

class CreateSMSTemplateViewModel {
   
    var delegate: CreateSMSTemplateViewControllerProtocol?
   
    var smsVariableListData: [CreateSMSTemplateModel] = []
    var leadVariableListData: [CreateSMSTemplateModel] = []
    var appointmentVariableListData: [CreateSMSTemplateModel] = []
    var smsTemplateData: smsTemplateDataModel?

    init(delegate: CreateSMSTemplateViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getSMSTemplateData(smsTemplateId: Int){
        self.requestManager.request(forPath: ApiUrl.getSMSTemplate.appending("\(smsTemplateId)"), method: .GET, headers: self.requestManager.Headers()) { (result: Result<smsTemplateDataModel, GrowthNetworkError>) in
            switch result {
            case .success(let smsTemplateData):
                self.smsTemplateData = smsTemplateData
                self.delegate?.recivedSMSTemplateData()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getLeadVariablesList(){
        self.requestManager.request(forPath: ApiUrl.getLeadVariable, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[CreateSMSTemplateModel], GrowthNetworkError>) in
            switch result {
            case .success(let leadVariableListData):
                self.leadVariableListData = leadVariableListData
                self.delegate?.recivedLeadVariablesList()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getLeadTemplateListData(index: Int)-> CreateSMSTemplateModel {
        return self.leadVariableListData[index]
    }
    
    func getAppointmentVariablesList(){
        self.requestManager.request(forPath: ApiUrl.getAppointMEntVariable, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[CreateSMSTemplateModel], GrowthNetworkError>) in
            switch result {
            case .success(let appointmentVariableListData):
                self.appointmentVariableListData = appointmentVariableListData
                self.delegate?.recivedAppointmentVariablesList()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getAppointmentTemplateListData(index: Int)-> CreateSMSTemplateModel {
        return self.appointmentVariableListData[index]
    }
    
    func getMassSMSVariablesList() {
        self.requestManager.request(forPath: ApiUrl.getMassSMSVariable, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[CreateSMSTemplateModel], GrowthNetworkError>) in
            switch result {
            case .success(let smsTemplateData):
                self.smsVariableListData = smsTemplateData
                self.delegate?.recivedMassSMSVariablesList()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassSMSTemplateListData(index: Int)-> CreateSMSTemplateModel {
        return self.smsVariableListData[index]
    }
    
    func crateSMSTemplate(parameters: [String:Any]) {
        self.requestManager.request(forPath: ApiUrl.createSMSTemplates, method: .POST, headers: self.requestManager.Headers(),task: .requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.smsTemplateCreatedSuccessfully()
                }else if response.statusCode == 500 {
                    self.delegate?.errorReceived(error: "Failed update SMSTemplate")
                }else{
                    self.delegate?.errorReceived(error: "Internal server error")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func updateSMSTemplate(smsTemplatesId:Int, parameters: [String:Any]) {
        self.requestManager.request(forPath: ApiUrl.createSMSTemplates.appending("/\(smsTemplatesId)"), method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.smsTemplateCreatedSuccessfully()
                }else if response.statusCode == 500 {
                    self.delegate?.errorReceived(error: "Failed update SMSTemplate")
                }else{
                    self.delegate?.errorReceived(error: "Internal server error")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
}

extension CreateSMSTemplateViewModel: CreateSMSTemplateViewModelProtocol {
   
    var getSMSTemplateListData: smsTemplateDataModel? {
        return self.smsTemplateData
    }
   
    var getLeadVariableListData: [CreateSMSTemplateModel] {
        return self.leadVariableListData
    }
    
    var getAppointMentVariableListData: [CreateSMSTemplateModel] {
        return self.appointmentVariableListData
    }
    
    var getSMSVariableListData: [CreateSMSTemplateModel] {
        return self.smsVariableListData
    }
    
}
