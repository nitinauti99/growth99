//
//  MassEmailandSMSDetailViewModel.swift
//  Growth99
//
//  Created by Apple on 07/03/23.
//

import Foundation
protocol MassEmailandSMSDetailViewModelProtocol {
    func getMassEmailDetailList()
    func getMassEmailLeadTagsList()
    func getMassEmailPateintsTagsList()
    func getMassEmailLeadStatusMethod(leadStatus: String, moduleName: String, leadTagIds: String, source: String)
    func getMassEmailPatientStatusMethod(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String)
    func getMassEmailBusinessSMSQuotaMethod()
    func getMassEmailAuditEmailQuotaMethod()
    func getMassEmailLeadStatusAllMethod()
    func getMassEmailPatientStatusAllMethod()
    var  getMassEmailDetailData: MassEmailSMSDetailListModel? { get }
    var  getMassEmailLeadTagsData: [MassEmailSMSTagListModel] { get }
    var  getMassEmailPateintsTagsData: [MassEmailSMSTagListModel] { get }
    var  getMassEmailSMSPatientCountData: MassEmailSMSCountModel? { get }
    var  getMassEmailSMSLeadCountData: MassEmailSMSCountModel? { get }
    var  getmassEmailSMSBusinessQuotaCountData: MassEmailSMSEQuotaCountModel? { get }
    var  getmassEmailSMSAuditQuotaCountData: MassEmailSMSEQuotaCountModel? { get }
    
    var  getmassEmailSMSLeadAllCountData: MassEmailSMSLeadAllCountModel? { get }
    var  getmassEmailSMSPatientsAllCountData: MassEmailSMSPatientsAllCountModel? { get }
    
    func localToServerWithDate(date: String) -> String
    func localInputToServerInput(date: String) -> String
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    
    func postMassLeadDataMethod(leadDataParms: [String: Any])
    func postMassPatientDataMethod(patientDataParms: [String: Any])
    func postMassLeadPatientDataMethod(leadPatientDataParms: [String: Any])
}

class MassEmailandSMSDetailViewModel: MassEmailandSMSDetailViewModelProtocol {
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let formatter = DateFormatter()
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    let inFormatter = DateFormatter()
    let outFormatter = DateFormatter()
    var delegate: MassEmailandSMSDetailViewControlProtocol?
    var massEmailDeatilList: MassEmailSMSDetailListModel?
    var massEmailLeadTagsList: [MassEmailSMSTagListModel] = []
    var massEmailPateintsTagsList: [MassEmailSMSTagListModel] = []
    var massEmailSMSLeadCount: MassEmailSMSCountModel?
    var massEmailSMSPatientCount: MassEmailSMSCountModel?
    var massEmailSMSBusinessQuotaCount: MassEmailSMSEQuotaCountModel?
    var massEmailSMSAuditQuotaCount: MassEmailSMSEQuotaCountModel?
    
    var massEmailSMSLeadAllCount: MassEmailSMSLeadAllCountModel?
    var massEmailSMSPatientsAllCount: MassEmailSMSPatientsAllCountModel?
    
    init(delegate: MassEmailandSMSDetailViewControlProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getMassEmailLeadTagsList() {
        self.requestManager.request(forPath: ApiUrl.leadTagList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[MassEmailSMSTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let massEMailLeadTagsList):
                self.massEmailLeadTagsList = massEMailLeadTagsList
                self.delegate?.massEmailLeadTagsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailPateintsTagsList() {
        self.requestManager.request(forPath: ApiUrl.patientTagList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[MassEmailSMSTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.massEmailPateintsTagsList = pateintsTagList
                self.delegate?.massEmailPatientTagsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailDetailList() {
        self.requestManager.request(forPath: ApiUrl.massEmailTrigerList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSDetailListModel, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailDeatilList):
                self.massEmailDeatilList = massEmailDeatilList
                self.delegate?.massEmailDetailDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailLeadStatusMethod(leadStatus: String, moduleName: String, leadTagIds: String, source: String) {
        let appendParam = "leadStatus=\(leadStatus)&moduleName=\(moduleName)&leadTagIds=\(leadTagIds)&source=\(source)"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {(result: Result<MassEmailSMSCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massEmailSMSLeadCount = response
                self.delegate?.massEmailSMSLeadCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func getMassEmailPatientStatusMethod(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String) {
        let appendParam = "appointmentStatus=\(appointmentStatus)&moduleName=\(moduleName)&patientTagIds=\(patientTagIds)&patientStatus=\(patientStatus)"
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {(result: Result<MassEmailSMSCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massEmailSMSPatientCount = response
                self.delegate?.massEmailSMSPatientCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailLeadStatusAllMethod() {
        let appendParam = "leadStatus=All&moduleName=All"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {(result: Result<MassEmailSMSLeadAllCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massEmailSMSLeadAllCount = response
                self.delegate?.massEmailSMSLeadStatusAllDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var  getmassEmailSMSLeadAllCountData: MassEmailSMSLeadAllCountModel? {
        return massEmailSMSLeadAllCount
    }
    var  getmassEmailSMSPatientsAllCountData: MassEmailSMSPatientsAllCountModel? {
        return massEmailSMSPatientsAllCount
    }
    
    func getMassEmailPatientStatusAllMethod() {
        let appendParam = "appointmentStatus=All&moduleName=All&patientTagIds=&patientStatus="
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {(result: Result<MassEmailSMSPatientsAllCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massEmailSMSPatientsAllCount = response
                self.delegate?.massEmailSMSPatientStatusAllDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailBusinessSMSQuotaMethod() {
        self.requestManager.request(forPath: ApiUrl.massEmailBusinessSMSQuota, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSEQuotaCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailSMSBusinessQuotaCount):
                self.massEmailSMSBusinessQuotaCount = massEmailSMSBusinessQuotaCount
                self.delegate?.massEmailSMSBusinessQuotaCountDataReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailAuditEmailQuotaMethod() {
        self.requestManager.request(forPath: ApiUrl.massEmailAuditEmailSMSQuota, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSEQuotaCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailSMSAuditQuotaCount):
                self.massEmailSMSAuditQuotaCount = massEmailSMSAuditQuotaCount
                self.delegate?.massEmailSMSAuditQuotaCountDataReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func postMassLeadDataMethod(leadDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.marketingMassLead, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: leadDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.marketingMassLeadDataReceived()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while creating Mass Lead")
                } else {
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func postMassPatientDataMethod(patientDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.marketingMassPatient, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: patientDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.marketingMassPatientDataReceived()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while creating Mass Patient")
                } else {
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func postMassLeadPatientDataMethod(leadPatientDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.marketingMassLeadPatient, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: leadPatientDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.marketingMassLeadPatientDataReceived()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while creating Mass Lead and Patient")
                } else {
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getMassEmailDetailData: MassEmailSMSDetailListModel? {
        return self.massEmailDeatilList
    }
    
    var getMassEmailLeadTagsData: [MassEmailSMSTagListModel] {
        return self.massEmailLeadTagsList
    }
    
    var getMassEmailPateintsTagsData: [MassEmailSMSTagListModel] {
        return self.massEmailPateintsTagsList
    }
    
    var getMassEmailSMSPatientCountData: MassEmailSMSCountModel? {
        return self.massEmailSMSPatientCount
    }
    
    var getMassEmailSMSLeadCountData: MassEmailSMSCountModel? {
        return self.massEmailSMSLeadCount
    }
    
    var getmassEmailSMSBusinessQuotaCountData: MassEmailSMSEQuotaCountModel? {
        return self.massEmailSMSBusinessQuotaCount
    }
    
    var getmassEmailSMSAuditQuotaCountData: MassEmailSMSEQuotaCountModel? {
        return self.massEmailSMSAuditQuotaCount
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
    
    func localInputToServerInput(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date)
    }
    
    func dateFormatterString(textField: CustomTextField) -> String {
        var datePickerEdit = textField.inputView as? UIDatePicker ?? UIDatePicker()
        let dateFormatterEdit = DateFormatter()
        dateFormatterEdit.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MM/dd/yyyy"
        datePickerEdit.minimumDate = Date()
        textField.resignFirstResponder()
        datePickerEdit.reloadInputViews()
        if let date = dateFormatterEdit.date(from: dateFormatterEdit.string(from: datePickerEdit.date)) {
            return outputDateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func timeFormatterString(textField: CustomTextField) -> String {
        timePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        timePicker.datePickerMode = .time
        formatter.timeStyle = .short
        textField.resignFirstResponder()
        timePicker.reloadInputViews()
        return formatter.string(from: timePicker.date)
    }
}
