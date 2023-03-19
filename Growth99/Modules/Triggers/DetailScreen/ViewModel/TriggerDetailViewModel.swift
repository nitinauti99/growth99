//
//  TriggerDetailViewModel.swift
//  Growth99
//
//  Created by Apple on 07/03/23.
//

import Foundation
protocol TriggerDetailViewModelProtocol {
    func getTriggerDetailList()
    func getLandingPageNames()
    func getTriggerQuestionnaires()
    func getTriggerLeadSourceUrl()
    
    var  getTriggerDetailData: TriggerDetailListModel? { get }
    var  getLandingPageNamesData: [LandingPageNamesModel] { get }
    var  getTriggerQuestionnairesData: [LandingPageNamesModel] { get }
    var  getTriggerLeadSourceUrlData: [LeadSourceUrlListModel] { get }
    
    func localToServerWithDate(date: String) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    
    func createTriggerDataMethod(triggerDataParms: [String: Any])
    func createAppointmentDataMethod(appointmentDataParms: [String: Any])
}

class TriggerDetailViewModel: TriggerDetailViewModelProtocol {
    var delegate: TriggerDetailViewControlProtocol?
    var triggerDeatilList: TriggerDetailListModel?
    var triggerLandingPageNames: [LandingPageNamesModel] = []
    var triggerQuestionnaires: [LandingPageNamesModel] = []
    var triggerLeadSourceUrl: [LeadSourceUrlListModel] = []
    var timePicker = UIDatePicker()

    init(delegate: TriggerDetailViewControlProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getTriggerDetailList() {
        self.requestManager.request(forPath: ApiUrl.massEmailTrigerList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerDetailListModel, GrowthNetworkError>) in
            switch result {
            case .success(let triggerDeatilList):
                self.triggerDeatilList = triggerDeatilList
                self.delegate?.triggerDetailDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerLeadSourceUrl() {
        let finaleUrl = ApiUrl.getLeadsourceurls
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[LeadSourceUrlListModel], GrowthNetworkError>) in
            switch result {
            case .success(let triggerLeadSourceUrl):
                self.triggerLeadSourceUrl = triggerLeadSourceUrl
                self.delegate?.triggerLeadSourceUrlDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getLandingPageNames() {
        self.requestManager.request(forPath: ApiUrl.triggerLandingPageNames, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[LandingPageNamesModel], GrowthNetworkError>) in
            switch result {
            case .success(let triggerLandingPageNames):
                self.triggerLandingPageNames = triggerLandingPageNames
                self.delegate?.triggerLandingPageNamesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerQuestionnaires() {
        self.requestManager.request(forPath: ApiUrl.triggerQuestionnaire, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[LandingPageNamesModel], GrowthNetworkError>) in
            switch result {
            case .success(let triggerQuestionnaires):
                self.triggerQuestionnaires = triggerQuestionnaires
                self.delegate?.triggerQuestionnairesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func createTriggerDataMethod(triggerDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.getAllTriggers, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: triggerDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.createTriggerDataReceived()
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
    
    func createAppointmentDataMethod(appointmentDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.createTriggerAppointment, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: appointmentDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.createAppointmentDataReceived()
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
    
    var getTriggerDetailData: TriggerDetailListModel? {
        return self.triggerDeatilList
    }
    
    var  getLandingPageNamesData: [LandingPageNamesModel] {
        return triggerLandingPageNames
    }
    
    var getTriggerQuestionnairesData: [LandingPageNamesModel] {
        return triggerQuestionnaires
    }
    
    var getTriggerLeadSourceUrlData: [LeadSourceUrlListModel] {
        return triggerLeadSourceUrl
    }
    
    func localToServerWithDate(date: String) -> String {
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
    
    func timeFormatterString(textField: CustomTextField) -> String {
        timePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        timePicker.datePickerMode = .time
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        textField.resignFirstResponder()
        timePicker.reloadInputViews()
        return formatter.string(from: timePicker.date)
    }
}
