//
//  EmailTemplateViewModel.swift
//  Growth99
//
//  Created by nitin auti on 08/02/23.
//

import Foundation

protocol EmailTemplateViewModelProtocol {
    var getLeadTemplateListData: [Any] { get }
    var getAppointmentTemplateListData: [Any] { get }
    var getMassEmailTemplateListData: [Any] { get }
    
    var getTemplateListData: [EmailTemplateListModel] { get }
    var getTemplateFilterListData: [EmailTemplateListModel] { get }
    
    func getSelectedTemplate(selectedIndex: Int) ->[Any]
    func getSelectedTemplateFilterData(selectedIndex: Int)-> [Any]
    
    func getEmailTemplateList()
    func filterData(searchText: String, selectedIndex: Int)
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex: Int) -> EmailTemplateListModel?
    func getTemplateFilterDataAtIndexPath(index: Int, selectedIndex: Int) -> EmailTemplateListModel?
}

class EmailTemplateViewModel {
    var delegate: EmailTemplateViewContollerProtocol?
    var emailTemplateListData: [EmailTemplateListModel] = []
    
    var emailTemplateFilterData: [EmailTemplateListModel] = []
    
    var leadTemplateListData: [EmailTemplateListModel] = []
    var apppointmentTemplateListData: [EmailTemplateListModel] = []
    var massEmailTemplateListData: [EmailTemplateListModel] = []
    
    init(delegate: EmailTemplateViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getEmailTemplateList() {
        self.requestManager.request(forPath: ApiUrl.emailTemplatesList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[EmailTemplateListModel], GrowthNetworkError>) in
            switch result {
            case .success(let emailTemplateData):
                self.emailTemplateListData = emailTemplateData
                self.setTemplate()
                self.delegate?.emailTemplatesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func setTemplate(){
        for template in self.emailTemplateListData {
            if template.templateFor == "Lead" {
                leadTemplateListData.append(template)
                leadTemplateListData.sort(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
            }else if (template.templateFor == "Appointment"){
                apppointmentTemplateListData.append(template)
                apppointmentTemplateListData.sort(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
            }else if (template.templateFor == "MassEmail"){
                massEmailTemplateListData.append(template)
                massEmailTemplateListData.sort(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
            }
        }
    }
    
    func getSelectedTemplate(selectedIndex: Int) -> [Any] {
        if selectedIndex == 0 {
            return leadTemplateListData
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData
        }else {
            return massEmailTemplateListData
        }
    }
    
    func getSelectedTemplateFilterData(selectedIndex: Int)-> [Any] {
        return self.emailTemplateFilterData
    }
    
    func filterData(searchText: String, selectedIndex: Int) {
        if selectedIndex == 0 {
            self.emailTemplateFilterData = self.leadTemplateListData.filter { task in
                let searchText = searchText.lowercased()
                let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
                let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
                return nameMatch || idMatch
            }
            
        }else if (selectedIndex == 1){
            self.emailTemplateFilterData = self.apppointmentTemplateListData.filter { task in
                let searchText = searchText.lowercased()
                let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
                let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
                return nameMatch || idMatch
            }
        }else {
            self.emailTemplateFilterData = self.massEmailTemplateListData.filter { task in
                let searchText = searchText.lowercased()
                let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
                let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
                return nameMatch || idMatch
            }
        }
    }
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex:Int) -> EmailTemplateListModel? {
        if selectedIndex == 0 {
            return leadTemplateListData[index]
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData[index]
        }else {
            return massEmailTemplateListData[index]
        }
    }
    
    func getTemplateFilterDataAtIndexPath(index: Int, selectedIndex: Int) -> EmailTemplateListModel? {
        return self.emailTemplateFilterData[index]
    }
}

extension EmailTemplateViewModel: EmailTemplateViewModelProtocol {
    
    var getTemplateListData: [EmailTemplateListModel] {
        return self.emailTemplateListData
    }
    
    var getTemplateFilterListData: [EmailTemplateListModel] {
        return self.emailTemplateFilterData
    }
    
    var getLeadTemplateListData: [Any] {
        return self.leadTemplateListData
    }
    
    var getAppointmentTemplateListData: [Any] {
        return self.apppointmentTemplateListData
    }
    
    var getMassEmailTemplateListData: [Any] {
        return self.massEmailTemplateListData
    }
    
    
}
