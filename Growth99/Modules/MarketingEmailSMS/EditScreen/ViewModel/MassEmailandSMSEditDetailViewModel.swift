//
//  MassEmailandSMSEditDetailViewModel.swift
//  Growth99
//
//  Created by Apple on 07/03/23.
//

import Foundation
protocol MassEmailandSMSEditDetailViewModelProtocol {
    func getMassEmailDetailListEdit()
    func getMassEmailLeadTagsListEdit()
    func getMassEmailPateintsTagsListEdit()
    func getMassEmailLeadStatusMethodEdit(leadStatus: String, moduleName: String, leadTagIds: String, source: String)
    func getMassEmailPatientStatusMethodEdit(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String)
    func getMassEmailBusinessSMSQuotaMethodEdit()
    func getMassEmailAuditEmailQuotaMethodEdit()
    func getMassEmailLeadStatusAllMethodEdit()
    func getMassEmailPatientStatusAllMethodEdit()
    var  getMassEmailDetailDataEdit: MassEmailSMSDetailListModelEdit? { get }
    var  getMassEmailLeadTagsDataEdit: [MassEmailSMSTagListModelEdit] { get }
    var  getMassEmailPateintsTagsDataEdit: [MassEmailSMSTagListModelEdit] { get }
    var  getMassEmailSMSPatientCountDataEdit: MassEmailSMSCountModelEdit? { get }
    var  getMassEmailSMSLeadCountDataEdit: MassEmailSMSCountModelEdit? { get }
    var  getmassEmailSMSQuotaCountDataEdit: MassEmailSMSEQuotaCountModelEdit? { get }
    var  getmassEmailSMSAuditQuotaCountDataEdit: MassEmailSMSEQuotaCountModelEdit? { get }
    func localToServerWithDateEdit(date: String) -> String
    func localInputToServerInputEdit(date: String) -> String
    func dateFormatterStringEdit(textField: CustomTextField) -> String
    func timeFormatterStringEdit(textField: CustomTextField) -> String
    
    func postMassLeadDataMethodEdit(leadDataParms: [String: Any])
    func postMassPatientDataMethodEdit(patientDataParms: [String: Any])
    func postMassLeadPatientDataMethodEdit(leadPatientDataParms: [String: Any])
}

class MassEmailandSMSEditDetailViewModel: MassEmailandSMSEditDetailViewModelProtocol {
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let formatter = DateFormatter()
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    let inFormatter = DateFormatter()
    let outFormatter = DateFormatter()
    var delegate: MassEmailandSMSEditDetailViewControlProtocol?
    var massEmailDeatilListEdit: MassEmailSMSDetailListModelEdit?
    var massEmailLeadTagsListEdit: [MassEmailSMSTagListModelEdit] = []
    var massEmailPateintsTagsListEdit: [MassEmailSMSTagListModelEdit] = []
    var massEmailSMSLeadCountEdit: MassEmailSMSCountModelEdit?
    var massEmailSMSPatientCountEdit: MassEmailSMSCountModelEdit?
    var massEmailSMSQuotaCountEdit: MassEmailSMSEQuotaCountModelEdit?
    var massEmailSMSAuditQuotaCountEdit: MassEmailSMSEQuotaCountModelEdit?
    
    init(delegate: MassEmailandSMSEditDetailViewControlProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getMassEmailLeadTagsListEdit() {
        self.requestManager.request(forPath: ApiUrl.leadTagList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[MassEmailSMSTagListModelEdit], GrowthNetworkError>) in
            switch result {
            case .success(let massEMailLeadTagsList):
                self.massEmailLeadTagsListEdit = massEMailLeadTagsList
                self.delegate?.massEmailLeadTagsDataRecivedEdit()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailPateintsTagsListEdit() {
        self.requestManager.request(forPath: ApiUrl.patientTagList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[MassEmailSMSTagListModelEdit], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.massEmailPateintsTagsListEdit = pateintsTagList
                self.delegate?.massEmailPatientTagsDataRecivedEdit()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailDetailListEdit() {
        self.requestManager.request(forPath: ApiUrl.massEmailTrigerList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSDetailListModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailDeatilList):
                self.massEmailDeatilListEdit = massEmailDeatilList
                self.delegate?.massEmailDetailDataRecivedEdit()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailLeadStatusMethodEdit(leadStatus: String, moduleName: String, leadTagIds: String, source: String) {
        let appendParam = "leadStatus=\(leadStatus)&moduleName=\(moduleName)&leadTagIds=\(leadTagIds)&source=\(source)"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {(result: Result<MassEmailSMSCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massEmailSMSLeadCountEdit = response
                self.delegate?.massEmailSMSLeadCountDataRecivedEdit()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
            }
        }
    }
    
    func getMassEmailPatientStatusMethodEdit(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String) {
        let appendParam = "appointmentStatus=\(appointmentStatus)&moduleName=\(moduleName)&patientTagIds=\(patientTagIds)&patientStatus=\(patientStatus)"
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.massEmailSMSPatientCountDataRecivedEdit()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceivedEdit(error: "We are facing issue while creating Mass Patient")
                } else {
                    self.delegate?.errorReceivedEdit(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailLeadStatusAllMethodEdit() {
        let appendParam = "leadStatus=All&moduleName=All"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.massEmailSMSLeadStatusAllDataRecivedEdit()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceivedEdit(error: "We are facing issue while creating Mass Patient")
                } else {
                    self.delegate?.errorReceivedEdit(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailPatientStatusAllMethodEdit() {
        let appendParam = "appointmentStatus=All&moduleName=All&patientTagIds=&patientStatus="
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.massEmailSMSPatientStatusAllDataRecivedEdit()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceivedEdit(error: "We are facing issue while creating Mass Patient")
                } else {
                    self.delegate?.errorReceivedEdit(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailBusinessSMSQuotaMethodEdit() {
        self.requestManager.request(forPath: ApiUrl.massEmailBusinessSMSQuota, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSEQuotaCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailSMSQuotaCount):
                self.massEmailSMSQuotaCountEdit = massEmailSMSQuotaCount
                self.delegate?.massEmailSMSEQuotaCountDataReceivedEdit()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailAuditEmailQuotaMethodEdit() {
        self.requestManager.request(forPath: ApiUrl.massEmailAuditEmailSMSQuota, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSEQuotaCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailSMSAuditQuotaCount):
                self.massEmailSMSAuditQuotaCountEdit = massEmailSMSAuditQuotaCount
                self.delegate?.massEmailSMSAuditQuotaCountDataReceivedEdit()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func postMassLeadDataMethodEdit(leadDataParms: [String: Any]) {
                
        self.requestManager.request(forPath: ApiUrl.marketingMassLead, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: leadDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.marketingMassLeadDataReceivedEdit()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceivedEdit(error: "We are facing issue while creating Mass Lead")
                } else {
                    self.delegate?.errorReceivedEdit(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func postMassPatientDataMethodEdit(patientDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.marketingMassPatient, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: patientDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.marketingMassPatientDataReceivedEdit()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceivedEdit(error: "We are facing issue while creating Mass Patient")
                } else {
                    self.delegate?.errorReceivedEdit(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func postMassLeadPatientDataMethodEdit(leadPatientDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.marketingMassLeadPatient, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: leadPatientDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.marketingMassLeadPatientDataReceivedEdit()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceivedEdit(error: "We are facing issue while creating Mass Lead and Patient")
                } else {
                    self.delegate?.errorReceivedEdit(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getMassEmailDetailDataEdit: MassEmailSMSDetailListModelEdit? {
        return self.massEmailDeatilListEdit
    }
    
    var getMassEmailLeadTagsDataEdit: [MassEmailSMSTagListModelEdit] {
        return self.massEmailLeadTagsListEdit
    }
    
    var getMassEmailPateintsTagsDataEdit: [MassEmailSMSTagListModelEdit] {
        return self.massEmailPateintsTagsListEdit
    }
    
    var getMassEmailSMSPatientCountDataEdit: MassEmailSMSCountModelEdit? {
        return self.massEmailSMSPatientCountEdit
    }
    
    var getMassEmailSMSLeadCountDataEdit: MassEmailSMSCountModelEdit? {
        return self.massEmailSMSLeadCountEdit
    }
    
    var getmassEmailSMSQuotaCountDataEdit: MassEmailSMSEQuotaCountModelEdit? {
        return self.massEmailSMSQuotaCountEdit
    }
    
    var getmassEmailSMSAuditQuotaCountDataEdit: MassEmailSMSEQuotaCountModelEdit? {
        return self.massEmailSMSAuditQuotaCountEdit
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
    
    func localInputToServerInputEdit(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date)
    }
    
    func dateFormatterStringEdit(textField: CustomTextField) -> String {
        datePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePicker.minimumDate = todaysDate
        textField.resignFirstResponder()
        datePicker.reloadInputViews()
        return dateFormatter.string(from: datePicker.date)
    }
    
    func timeFormatterStringEdit(textField: CustomTextField) -> String {
        timePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        timePicker.datePickerMode = .time
        formatter.timeStyle = .short
        textField.resignFirstResponder()
        timePicker.reloadInputViews()
        return formatter.string(from: timePicker.date)
    }
}
