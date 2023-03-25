//
//  TriggerEditDetailViewModel.swift
//  Growth99
//
//  Created by Apple on 07/03/23.
//

import Foundation
protocol TriggerEditDetailViewModelProtocol {
    func getTriggerDetailListEdit()
    func getLandingPageNamesEdit()
    func getTriggerQuestionnairesEdit()
    func getTriggerLeadSourceUrlEdit()
    
    var  getTriggerEditListData: TriggerEditModel? { get }
    var  getTriggerDetailDataEdit: TriggerEditDetailListModel? { get }
    var  getLandingPageNamesDataEdit: [EditLandingPageNamesModel] { get }
    var  getTriggerQuestionnairesDataEdit: [EditLandingPageNamesModel] { get }
    var  getTriggerLeadSourceUrlDataEdit: [LeadSourceUrlListModel] { get }
    
    func localToServerWithDateEdit(date: String) -> String
    func timeFormatterStringEdit(textField: CustomTextField) -> String
    
    func createTriggerDataMethodEdit(triggerDataParms: [String: Any], selectedTriggerid: Int)
    func createAppointmentDataMethodEdit(appointmentDataParms: [String: Any], selectedTriggerid: Int)
    func getSelectedTriggerList(selectedTriggerId: Int) 
}

class TriggerEditDetailViewModel: TriggerEditDetailViewModelProtocol {
    
    var delegate: TriggerEditDetailViewControlProtocol?
    var triggerEditList: TriggerEditModel?
    var triggerEditDeatilList: TriggerEditDetailListModel?
    var triggerEditLandingPageNames: [EditLandingPageNamesModel] = []
    var triggerEditQuestionnaires: [EditLandingPageNamesModel] = []
    var triggerEditLeadSourceUrl: [LeadSourceUrlListModel] = []
    var timePicker = UIDatePicker()

    init(delegate: TriggerEditDetailViewControlProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    
    func getSelectedTriggerList(selectedTriggerId: Int) {
        self.requestManager.request(forPath: ApiUrl.editTrigger + "\(selectedTriggerId)", method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerEditModel, GrowthNetworkError>) in
            switch result {
            case .success(let triggerEditList):
                self.triggerEditList = triggerEditList
                self.delegate?.triggerEditSelectedDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getTriggerEditListData: TriggerEditModel? {
        return triggerEditList
    }
    
    func getTriggerDetailListEdit() {
        self.requestManager.request(forPath: ApiUrl.massEmailTrigerList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerEditDetailListModel, GrowthNetworkError>) in
            switch result {
            case .success(let triggerDeatilList):
                self.triggerEditDeatilList = triggerDeatilList
                self.delegate?.triggerEditDetailDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerLeadSourceUrlEdit() {
        let finaleUrl = ApiUrl.getLeadsourceurls
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[LeadSourceUrlListModel], GrowthNetworkError>) in
            switch result {
            case .success(let triggerLeadSourceUrl):
                self.triggerEditLeadSourceUrl = triggerLeadSourceUrl
                self.delegate?.triggerEditLeadSourceUrlDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getLandingPageNamesEdit() {
        self.requestManager.request(forPath: ApiUrl.triggerLandingPageNames, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[EditLandingPageNamesModel], GrowthNetworkError>) in
            switch result {
            case .success(let triggerLandingPageNames):
                self.triggerEditLandingPageNames = triggerLandingPageNames
                self.delegate?.triggerEditLandingPageNamesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerQuestionnairesEdit() {
        self.requestManager.request(forPath: ApiUrl.triggerQuestionnaire, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[EditLandingPageNamesModel], GrowthNetworkError>) in
            switch result {
            case .success(let triggerQuestionnaires):
                self.triggerEditQuestionnaires = triggerQuestionnaires
                self.delegate?.triggerEditQuestionnairesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createTriggerDataMethodEdit(triggerDataParms: [String: Any], selectedTriggerid: Int) {
        self.requestManager.request(forPath: ApiUrl.editTrigger.appending("\(selectedTriggerid)"), method: .PUT, headers: self.requestManager.Headers(), task: .requestParameters(parameters: triggerDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.createEditTriggerDataReceived()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while creating Trigger")
                } else {
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createAppointmentDataMethodEdit(appointmentDataParms: [String: Any], selectedTriggerid: Int) {
        self.requestManager.request(forPath: ApiUrl.createTriggerAppointment.appending("/\(selectedTriggerid)"), method: .PUT, headers: self.requestManager.Headers(), task: .requestParameters(parameters: appointmentDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.createEditAppointmentDataReceived()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while creating Appointment")
                } else {
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getTriggerDetailDataEdit: TriggerEditDetailListModel? {
        return self.triggerEditDeatilList
    }
    
    var  getLandingPageNamesDataEdit: [EditLandingPageNamesModel] {
        return triggerEditLandingPageNames
    }
    
    var getTriggerQuestionnairesDataEdit: [EditLandingPageNamesModel] {
        return triggerEditQuestionnaires
    }
    
    var getTriggerLeadSourceUrlDataEdit: [LeadSourceUrlListModel] {
        return triggerEditLeadSourceUrl
    }
    
    func localToServerWithDateEdit(date: String) -> String {
        let currentDate = Date()
        let dateFormatter22 = DateFormatter()
        dateFormatter22.string(from: currentDate)
        dateFormatter22.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter22.dateFormat = "MM/dd/yyyy"
        let dateWith = dateFormatter22.string(from: currentDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "h:mm a"
        return dateWith + dateFormatter.string(from: date)
    }
    
    func timeFormatterStringEdit(textField: CustomTextField) -> String {
        timePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        timePicker.datePickerMode = .time
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        textField.resignFirstResponder()
        timePicker.reloadInputViews()
        return formatter.string(from: timePicker.date)
    }
}
