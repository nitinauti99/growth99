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
    var getMassEmailTemplateListData: [Any] { get }
    
    var getTemplateListData: [SMSTemplateModel] { get }
    var getTemplateFilterListData: [SMSTemplateModel] { get }
    
    func getSelectedTemplate(selectedIndex: Int) ->[Any]
    func getSelectedTemplateFilterData(selectedIndex: Int)-> [Any]
    
    func getSMSTemplateList()
    
    func filterData(searchText: String)
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex: Int) -> SMSTemplateModel?
    func getTemplateFilterDataAtIndexPath(index: Int, selectedIndex: Int) -> SMSTemplateModel?
}

class SMSTemplateViewModel {
    var delegate: SMSTemplateViewContollerProtocol?
    var smsTemplateListData: [SMSTemplateModel] = []
    var smsTemplateFilterData: [SMSTemplateModel] = []
    
    var leadTemplateListData: [Any] = []
    var apppointmentTemplateListData: [Any] = []
    var massSMSTemplateListData: [Any] = []
    
    init(delegate: SMSTemplateViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
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
    
    func setTemplate(){
        for template in self.smsTemplateListData {
            if template.templateFor == "Lead" {
                leadTemplateListData.append(template)
            }else if (template.templateFor == "Appointment"){
                apppointmentTemplateListData.append(template)
            }else {
                massSMSTemplateListData.append(template)
            }
        }
    }
    
    func filterData(searchText: String) {
        self.smsTemplateFilterData = (self.smsTemplateListData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() || String($0.id ?? 0) == searchText })
    }
    
    func getSelectedTemplateFilterData(selectedIndex: Int)-> [Any] {
        return self.smsTemplateFilterData
    }
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex:Int) -> SMSTemplateModel? {
        if selectedIndex == 0 {
            return leadTemplateListData[index] as? SMSTemplateModel
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData[index] as? SMSTemplateModel
        }else {
            return massSMSTemplateListData[index] as? SMSTemplateModel
        }
    }
    
    func getTemplateFilterDataAtIndexPath(index: Int, selectedIndex: Int) -> SMSTemplateModel? {
        return self.smsTemplateFilterData[index]
    }
    
    func getSelectedTemplate(selectedIndex: Int) -> [Any] {
        if selectedIndex == 0 {
            return leadTemplateListData
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData
        }else {
            return massSMSTemplateListData
        }
    }
    
    func smsTemplateDataAtIndex(index: Int, selectedIndex: Int) -> SMSTemplateModel?{
        if selectedIndex == 0 {
            return leadTemplateListData[index] as? SMSTemplateModel
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData[index] as? SMSTemplateModel
        }else {
            return massSMSTemplateListData[index] as? SMSTemplateModel
        }
    }
}

extension SMSTemplateViewModel: SMSTemplateViewModelProtocol {
    
    var getLeadTemplateListData: [Any] {
        return self.leadTemplateListData
    }
    
    var getAppointmentTemplateListData: [Any] {
        return self.apppointmentTemplateListData
    }
    
    var getMassEmailTemplateListData: [Any] {
        return self.massSMSTemplateListData
    }
    
    var getTemplateFilterListData: [SMSTemplateModel] {
        return self.smsTemplateListData
    }
    
    var getTemplateListData: [SMSTemplateModel] {
        return self.smsTemplateListData
    }
}
