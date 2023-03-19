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
    func filterData(searchText: String)
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex: Int) -> EmailTemplateListModel?
    func getTemplateFilterDataAtIndexPath(index: Int, selectedIndex: Int) -> EmailTemplateListModel?
}

class EmailTemplateViewModel {
    var delegate: EmailTemplateViewContollerProtocol?
    var emailTemplateListData: [EmailTemplateListModel] = []
   
    var emailTemplateFilterData: [EmailTemplateListModel] = []
    
    var leadTemplateListData: [Any] = []
    var apppointmentTemplateListData: [Any] = []
    var massEmailTemplateListData: [Any] = []
    
    init(delegate: EmailTemplateViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
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
            }else if (template.templateFor == "Appointment"){
                apppointmentTemplateListData.append(template)
            }else {
                massEmailTemplateListData.append(template)
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
    
    func filterData(searchText: String) {
        self.emailTemplateFilterData = (self.emailTemplateListData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        print(self.emailTemplateFilterData)
    }
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex:Int) -> EmailTemplateListModel? {
        if selectedIndex == 0 {
            return leadTemplateListData[index] as? EmailTemplateListModel
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData[index] as? EmailTemplateListModel
        }else {
            return massEmailTemplateListData[index] as? EmailTemplateListModel
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
