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
    
    func filterData(searchText: String, selectedIndex: Int)
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex: Int) -> SMSTemplateModel?
    func getTemplateFilterDataAtIndexPath(index: Int, selectedIndex: Int) -> SMSTemplateModel?
}

class SMSTemplateViewModel {
    var delegate: SMSTemplateViewContollerProtocol?
    var smsTemplateListData: [SMSTemplateModel] = []
    var smsTemplateFilterData: [SMSTemplateModel] = []
    
    var leadTemplateListData: [SMSTemplateModel] = []
    var apppointmentTemplateListData: [SMSTemplateModel] = []
    var massSMSTemplateListData: [SMSTemplateModel] = []
    
    init(delegate: SMSTemplateViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getSMSTemplateList() {
        self.requestManager.request(forPath: ApiUrl.smsTemplatesList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[SMSTemplateModel], GrowthNetworkError>) in
            switch result {
            case .success(let smsTemplateData):
                self.leadTemplateListData = []
                self.apppointmentTemplateListData = []
                self.massSMSTemplateListData = []
                self.smsTemplateListData = smsTemplateData
                self.setTemplate()
                self.delegate?.SmsTemplatesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: "Unable to load email template.")
                print("Error while performing request \(error)")
            }
        }
    }
    
    func setTemplate(){
        for template in self.smsTemplateListData {
            if template.templateFor == "Lead" {
                leadTemplateListData.append(template)
                leadTemplateListData.sort(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
            }else if (template.templateFor == "Appointment"){
                apppointmentTemplateListData.append(template)
                apppointmentTemplateListData.sort(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
            }else {
                massSMSTemplateListData.append(template)
                massSMSTemplateListData.sort(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
            }
        }
    }
    
    func filterData(searchText: String, selectedIndex: Int) {
        if selectedIndex == 0 {
            self.smsTemplateFilterData = self.leadTemplateListData.filter { task in
                let searchText = searchText.lowercased()
                let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
                let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
                return nameMatch || idMatch
            }
            
        }else if (selectedIndex == 1){
            self.smsTemplateFilterData = self.apppointmentTemplateListData.filter { task in
                let searchText = searchText.lowercased()
                let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
                let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
                return nameMatch || idMatch
            }
        }else {
            self.smsTemplateFilterData = self.massSMSTemplateListData.filter { task in
                let searchText = searchText.lowercased()
                let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
                let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
                return nameMatch || idMatch
            }
        }
    }
    
    func getSelectedTemplateFilterData(selectedIndex: Int)-> [Any] {
        return self.smsTemplateFilterData
    }
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex:Int) -> SMSTemplateModel? {
        if selectedIndex == 0 {
            return leadTemplateListData[index]
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData[index]
        }else {
            return massSMSTemplateListData[index]
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
            return leadTemplateListData[index]
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData[index]
        }else {
            return massSMSTemplateListData[index]
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
