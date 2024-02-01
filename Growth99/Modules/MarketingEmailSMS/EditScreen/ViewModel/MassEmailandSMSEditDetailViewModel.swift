//
//  MassEmailandSMSEditDetailViewModel.swift
//  Growth99
//
//  Created by Apple on 07/03/23.
//

import Foundation
protocol MassEmailandSMSEditDetailViewModelProtocol {
    func getSelectedMassSMSEditList(selectedMassSMSId: Int)
    func getMassSMSEditDetailList()
    func getMassSMSEditLeadTagsList()
    func getMassSMSEditPateintsTagsList()
    func getMassSMSEditBusinessSMSQuotaMethod()
    func getMassSMSEditAuditEmailQuotaMethod()
    func getMassSMSEditAllLeadMethod()
    func getMassSMSEditAllPatientMethod()
    func getMassSMSEditLeadCountsMethod(leadStatus: String, moduleName: String, leadTagIds: String, source: String)
    func getMassSMSEditPatientCountMethod(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String)
    func getMassSMSEditInitialLeadCountsMethod(leadStatus: String, moduleName: String, leadTagIds: String, source: String)
    func getMassSMSEditInitialPatientCountMethod(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String)
    var  getMassSMSTriggerEditListData: MassSMSEditModel? { get }
    var  getMassSMSEditBusniessEmailSmsQuotaData: MassEmailSMSEQuotaCountModelEdit? { get }
    var  getMassSMSEditAuditEmailSmsCount: MassEmailSMSEQuotaCountModelEdit? { get }
    var  getMassSMSEditLeadTagsListData: [MassEmailSMSTagListModelEdit]? { get }
    var  getMassSMSEditPateintsTagsListData: [MassEmailSMSPTagListModelEdit]? { get }
    func localToServerWithDateEdit(date: String) -> String
    func localInputToServerInputEdit(date: String) -> String
    func dateFormatterStringEdit(textField: CustomTextField) -> String
    func timeFormatterStringEdit(textField: CustomTextField) -> String
    var  getMassSMSEditLeadCountData: MassEmailSMSCountModelEdit? { get }
    var  getMassSMSEditPatientCountData: MassEmailSMSCountModelEdit? { get }
    var  getMassSMSEditAllLeadCountData: MassEmailSMSLeadAllCountModelEdit? { get }
    var  getMassSMSEditAllPatientCountData: MassEmailSMSPatientAllCountModelEdit? { get }
    var  getMassEmailEditDetailData: MassEmailSMSDetailListModelEdit? { get }
    func editMassSMSLeadDataMethod(selectedMassSMSId: Int, leadDataParms: [String: Any])
    func editMassSMSPatientDataMethod(selectedMassSMSId: Int, patientDataParms: [String: Any])
    func editMassSMSLeadPatientDataMethod(selectedMassSMSId: Int, leadPatientDataParms: [String: Any])
    func convertDateFormat(dateString: String) -> String?
    func convertTimeFormat(dateString: String) -> String?
}

class MassEmailandSMSEditDetailViewModel: MassEmailandSMSEditDetailViewModelProtocol {
    
    var timePickerEdit = UIDatePicker()
    let formatterEdit = DateFormatter()
    let inFormatterEdit = DateFormatter()
    let outFormatterEdit = DateFormatter()
    var delegate: MassEmailandSMSEditDetailViewControlProtocol?
    var massSMStriggerEditList: MassSMSEditModel?
    var massSMStriggerEditDetailList: MassEmailSMSDetailListModelEdit?
    var massSMSEditLeadTagsList: [MassEmailSMSTagListModelEdit] = []
    var massSMSEditPateintsTagsList: [MassEmailSMSPTagListModelEdit] = []
    var massSMSEditBusinessEmailSmsQuota: MassEmailSMSEQuotaCountModelEdit?
    var massSMSEditAuditEmailSmsCount: MassEmailSMSEQuotaCountModelEdit?
    var massSMSEditLeadCount: MassEmailSMSCountModelEdit?
    var massSMSEditPatientCount: MassEmailSMSCountModelEdit?
    var massSMSEditAllLeadCount: MassEmailSMSLeadAllCountModelEdit?
    var massSMSEditAllPatientCount: MassEmailSMSPatientAllCountModelEdit?
    
    init(delegate: MassEmailandSMSEditDetailViewControlProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getSelectedMassSMSEditList(selectedMassSMSId: Int) {
        self.requestManager.request(forPath: ApiUrl.editTrigger + "\(selectedMassSMSId)", method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassSMSEditModel, GrowthNetworkError>) in
            switch result {
            case .success(let massSMStriggerEditList):
                self.massSMStriggerEditList = massSMStriggerEditList
                self.delegate?.massSMStriggerEditSelectedDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassSMSEditDetailList() {
        self.requestManager.request(forPath: ApiUrl.massEmailTrigerList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSDetailListModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let editDetailList):
                self.massSMStriggerEditDetailList = editDetailList
                self.delegate?.massSMSEditDetailDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassSMSEditLeadTagsList() {
        self.requestManager.request(forPath: ApiUrl.leadTagList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[MassEmailSMSTagListModelEdit], GrowthNetworkError>) in
            switch result {
            case .success(let editLeadTagsList):
                self.massSMSEditLeadTagsList = editLeadTagsList
                self.delegate?.massSMSEditLeadTagsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassSMSEditPateintsTagsList() {
        self.requestManager.request(forPath: ApiUrl.patientTagList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[MassEmailSMSPTagListModelEdit], GrowthNetworkError>) in
            switch result {
            case .success(let editPateintsTagsList):
                self.massSMSEditPateintsTagsList = editPateintsTagsList
                self.delegate?.massSMSEditPatientTagsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassSMSEditBusinessSMSQuotaMethod() {
        self.requestManager.request(forPath: ApiUrl.massEmailBusinessSMSQuota, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSEQuotaCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let businessEmailSMSQuota):
                self.massSMSEditBusinessEmailSmsQuota = businessEmailSMSQuota
                self.delegate?.massSMSEditBusinessEmailSMSQuotaDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassSMSEditAuditEmailQuotaMethod() {
        self.requestManager.request(forPath: ApiUrl.massEmailAuditEmailSMSQuota, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSEQuotaCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let auditEmailSMSQuota):
                self.massSMSEditAuditEmailSmsCount = auditEmailSMSQuota
                self.delegate?.massSMSEditAuditEmailSmsCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassSMSEditAllLeadMethod() {
        let appendParam = "leadStatus=All&moduleName=All"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {(result: Result<MassEmailSMSLeadAllCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massSMSEditAllLeadCount = response
                self.delegate?.massSMSEditAllLeadCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
            }
        }
    }
    
    func getMassSMSEditAllPatientMethod() {
        let appendParam = "appointmentStatus=All&moduleName=All&patientTagIds=&patientStatus="
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {(result: Result<MassEmailSMSPatientAllCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massSMSEditAllPatientCount = response
                self.delegate?.massSMSEditAllPatientCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
            }
        }
    }
    
    func getMassSMSEditLeadCountsMethod(leadStatus: String, moduleName: String, leadTagIds: String, source: String) {
        let appendParam = "leadStatus=\(leadStatus)&moduleName=\(moduleName)&leadTagIds=\(leadTagIds)&source=\(source)"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {(result: Result<MassEmailSMSCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massSMSEditLeadCount = response
                self.delegate?.massSMSEditLeadCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
            }
        }
    }
    
    func getMassSMSEditPatientCountMethod(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String) {
        let appendParam = "appointmentStatus=\(appointmentStatus)&moduleName=\(moduleName)&patientTagIds=\(patientTagIds)&patientStatus=\(patientStatus)"
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers())  {(result: Result<MassEmailSMSCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massSMSEditPatientCount = response
                self.delegate?.massSMSEditPatientCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
            }
        }
    }
    
    func getMassSMSEditInitialLeadCountsMethod(leadStatus: String, moduleName: String, leadTagIds: String, source: String) {
        let appendParam = "leadStatus=\(leadStatus)&moduleName=\(moduleName)&leadTagIds=\(leadTagIds)&source=\(source)"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {(result: Result<MassEmailSMSCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massSMSEditLeadCount = response
                self.delegate?.massSMSEditInitialLeadCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
            }
        }
    }
    
    func getMassSMSEditInitialPatientCountMethod(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String) {
        let appendParam = "appointmentStatus=\(appointmentStatus)&moduleName=\(moduleName)&patientTagIds=\(patientTagIds)&patientStatus=\(patientStatus)"
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers())  {(result: Result<MassEmailSMSCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.massSMSEditPatientCount = response
                self.delegate?.massSMSEditInitialPatientCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
            }
        }
    }
    
    func editMassSMSLeadDataMethod(selectedMassSMSId: Int, leadDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.marketingMassLead + "\(selectedMassSMSId)", method: .PUT, headers: self.requestManager.Headers(), task: .requestParameters(parameters: leadDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.massSMSEditLeadDataReceived()
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
    
    func editMassSMSPatientDataMethod(selectedMassSMSId: Int, patientDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.marketingMassPatient + "\(selectedMassSMSId)", method: .PUT, headers: self.requestManager.Headers(), task: .requestParameters(parameters: patientDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.massSMSEditPatientDataReceived()
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
    
    func editMassSMSLeadPatientDataMethod(selectedMassSMSId: Int, leadPatientDataParms: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.marketingMassLeadPatient + "\(selectedMassSMSId)", method: .PUT, headers: self.requestManager.Headers(), task: .requestParameters(parameters: leadPatientDataParms, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.massSMSEditLeadPatientDataReceived()
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
    
    var getMassSMSTriggerEditListData: MassSMSEditModel? {
        return massSMStriggerEditList
    }
    
    var getMassEmailEditDetailData: MassEmailSMSDetailListModelEdit? {
        return self.massSMStriggerEditDetailList
    }
    
    var getMassSMSEditLeadTagsListData: [MassEmailSMSTagListModelEdit]? {
        return self.massSMSEditLeadTagsList
    }
    
    var getMassSMSEditPateintsTagsListData: [MassEmailSMSPTagListModelEdit]? {
        return self.massSMSEditPateintsTagsList
    }
    
    var getMassSMSEditBusniessEmailSmsQuotaData: MassEmailSMSEQuotaCountModelEdit? {
        return massSMSEditBusinessEmailSmsQuota
    }
    
    var getMassSMSEditAuditEmailSmsCount: MassEmailSMSEQuotaCountModelEdit? {
        return massSMSEditAuditEmailSmsCount
    }
    
    var getMassSMSEditAllLeadCountData: MassEmailSMSLeadAllCountModelEdit? {
        return self.massSMSEditAllLeadCount
    }
    
    var getMassSMSEditAllPatientCountData: MassEmailSMSPatientAllCountModelEdit? {
        return self.massSMSEditAllPatientCount
    }
    
    var getMassSMSEditLeadCountData: MassEmailSMSCountModelEdit? {
        return self.massSMSEditLeadCount
    }
    
    var getMassSMSEditPatientCountData: MassEmailSMSCountModelEdit? {
        return self.massSMSEditPatientCount
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
    
    func convertDateFormat(dateString: String) -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MM/dd/yyyy"
        
        if let date = inputDateFormatter.date(from: dateString) {
            return outputDateFormatter.string(from: date)
        }
        
        return nil
    }
    
    func convertTimeFormat(dateString: String) -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "h:mm a"
        
        if let date = inputDateFormatter.date(from: dateString) {
            return outputDateFormatter.string(from: date)
        }
        
        return nil
    }
    
    func timeFormatterStringEdit(textField: CustomTextField) -> String {
        timePickerEdit = textField.inputView as? UIDatePicker ?? UIDatePicker()
        timePickerEdit.datePickerMode = .time
        formatterEdit.timeStyle = .short
        textField.resignFirstResponder()
        timePickerEdit.reloadInputViews()
        return formatterEdit.string(from: timePickerEdit.date)
    }
}
