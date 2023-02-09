//
//  SMSTemplateViewModel.swift
//  Growth99
//
//  Created by nitin auti on 09/02/23.
//

import Foundation

protocol SMSTemplateViewModelProtocol {
    var getLeadTemplateListData: [Any] { get }
    var getAppointmentTemplateListData: [Any] { get }
    var getEventTemplateListData: [Any] { get }
    var getMassSMSTemplateListData: [Any] { get }
    var smsTemplateFilterDataData: [SMSTemplateModel] { get }
    func getSMSTemplateList()
    func smsTemplateDataAtIndex(index: Int, selectedIndex: Int) -> SMSTemplateModel?
    func getSelectedTemplate(selectedIndex: Int) ->[Any]
    //func SMSTemplateFilterDataDataAtIndex(index: Int)-> SMSTemplateListModel?
}

class SMSTemplateViewModel {
    var delegate: SMSTemplateViewContollerProtocol?
    var smsTemplateListData: [SMSTemplateModel] = []
    var smsTemplateFilterData: [SMSTemplateModel] = []
    
    var leadTemplateListData: [Any] = []
    var apppointmentTemplateListData: [Any] = []
    var eventTemplateListData: [Any] = []
    var massSMSTemplateListData: [Any] = []
    
    init(delegate: SMSTemplateViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getSMSTemplateList() {
        self.requestManager.request(forPath: ApiUrl.smsTemplatesList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[SMSTemplateModel], GrowthNetworkError>) in
            switch result {
            case .success(let smsTemplateData):
                self.smsTemplateListData = smsTemplateData
                self.setTemplate()
                self.delegate?.SmsTemplatesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getSelectedTemplate(selectedIndex: Int) -> [Any] {
        if selectedIndex == 0 {
            return leadTemplateListData
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData
        }else if (selectedIndex == 2){
            return eventTemplateListData
        }else {
            return massSMSTemplateListData
        }
    }
    
    
    func setTemplate(){
        for template in self.smsTemplateListData {
            if template.templateFor == "Lead" {
                leadTemplateListData.append(template)
            }else if (template.templateFor == "Appointment"){
                apppointmentTemplateListData.append(template)
            }else if (template.templateFor == "Event"){
                eventTemplateListData.append(template)
            }else {
                massSMSTemplateListData.append(template)
            }
        }
    }
    
    func smsTemplateDataAtIndex(index: Int, selectedIndex: Int) -> SMSTemplateModel?{
        if selectedIndex == 0 {
            return leadTemplateListData[index] as? SMSTemplateModel
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData[index] as? SMSTemplateModel
        }else if (selectedIndex == 2){
            return eventTemplateListData[index] as? SMSTemplateModel
        }else {
            return massSMSTemplateListData[index] as? SMSTemplateModel
        }
    }
    
    //    func SMSTemplateFilterDataDataAtIndex(index: Int)-> SMSTemplateListModel? {
    //        return self.SMSTemplateListData[index]
    //    }
}

extension SMSTemplateViewModel: SMSTemplateViewModelProtocol {
    var getLeadTemplateListData: [Any] {
        return self.leadTemplateListData
    }
    
    var getAppointmentTemplateListData: [Any] {
        return self.apppointmentTemplateListData
    }
    
    var getEventTemplateListData: [Any] {
        return self.eventTemplateListData
    }
    
    var getMassSMSTemplateListData: [Any] {
        return self.massSMSTemplateListData
    }
    
    var smsTemplateFilterDataData: [SMSTemplateModel] {
        return self.smsTemplateListData
    }
    
    var getSMSTemplateData: [SMSTemplateModel] {
        return self.smsTemplateListData
    }
    
    
}
