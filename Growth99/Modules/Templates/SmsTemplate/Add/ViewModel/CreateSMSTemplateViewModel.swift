//
//  CreateCreateSMSTemplateViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation

protocol CreateSMSTemplateViewModelProtocol {
    func getCreateSMSTemplateList()
   
    func getSelectedTemplate(selectedIndex: Int) ->[Any]
    func getSelectedTemplateFilterData(selectedIndex: Int)-> [Any]
    func filterData(searchText: String)
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex: Int) -> CreateSMSTemplateModel?
    func getTemplateFilterDataAtIndexPath(index: Int, selectedIndex: Int) -> CreateSMSTemplateModel?
    
    var getLeadTemplateListData: [Any] { get }
    var getAppointmentTemplateListData: [Any] { get }
    var getMassEmailTemplateListData: [Any] { get }
    
    var getTemplateListData: [CreateSMSTemplateModel] { get }
    var getTemplateFilterListData: [CreateSMSTemplateModel] { get }
    
}

class CreateSMSTemplateViewModel {
    var delegate: CreateSMSTemplateViewControllerProtocol?
    var smsTemplateListData: [CreateSMSTemplateModel] = []
    var smsTemplateFilterData: [CreateSMSTemplateModel] = []
    
    var leadTemplateListData: [Any] = []
    var apppointmentTemplateListData: [Any] = []
    var massCreateSMSTemplateListData: [Any] = []
    
    init(delegate: CreateSMSTemplateViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getCreateSMSTemplateList() {
        self.requestManager.request(forPath: ApiUrl.smsTemplatesList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[CreateSMSTemplateModel], GrowthNetworkError>) in
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
                massCreateSMSTemplateListData.append(template)
            }
        }
    }
    
    func filterData(searchText: String) {
        self.smsTemplateFilterData = (self.smsTemplateListData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        print(self.smsTemplateFilterData)
    }
    
    func getSelectedTemplateFilterData(selectedIndex: Int)-> [Any] {
        return self.smsTemplateFilterData
    }
    
    func getTemplateDataAtIndexPath(index: Int, selectedIndex:Int) -> CreateSMSTemplateModel? {
        if selectedIndex == 0 {
            return leadTemplateListData[index] as? CreateSMSTemplateModel
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData[index] as? CreateSMSTemplateModel
        }else {
            return massCreateSMSTemplateListData[index] as? CreateSMSTemplateModel
        }
    }
    
    func getTemplateFilterDataAtIndexPath(index: Int, selectedIndex: Int) -> CreateSMSTemplateModel? {
        return self.smsTemplateFilterData[index]
    }
    
    func getSelectedTemplate(selectedIndex: Int) -> [Any] {
        if selectedIndex == 0 {
            return leadTemplateListData
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData
        }else {
            return massCreateSMSTemplateListData
        }
    }
    
    func smsTemplateDataAtIndex(index: Int, selectedIndex: Int) -> CreateSMSTemplateModel?{
        if selectedIndex == 0 {
            return leadTemplateListData[index] as? CreateSMSTemplateModel
        }else if (selectedIndex == 1){
            return apppointmentTemplateListData[index] as? CreateSMSTemplateModel
        }else {
            return massCreateSMSTemplateListData[index] as? CreateSMSTemplateModel
        }
    }
    
    //    func CreateSMSTemplateFilterDataDataAtIndex(index: Int)-> CreateSMSTemplateListModel? {
    //        return self.CreateSMSTemplateListData[index]
    //    }
}

extension CreateSMSTemplateViewModel: CreateSMSTemplateViewModelProtocol {
   
    var getLeadTemplateListData: [Any] {
        return self.leadTemplateListData
    }
    
    var getAppointmentTemplateListData: [Any] {
        return self.apppointmentTemplateListData
    }
    
    var getMassEmailTemplateListData: [Any] {
        return self.massCreateSMSTemplateListData
    }
    
    var getTemplateFilterListData: [CreateSMSTemplateModel] {
        return self.smsTemplateListData
    }
    
    var getTemplateListData: [CreateSMSTemplateModel] {
        return self.smsTemplateListData
    }
    
    
}
