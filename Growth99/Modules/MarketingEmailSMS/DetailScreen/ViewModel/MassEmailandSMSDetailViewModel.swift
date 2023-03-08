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
    var  getmassEmailSMSQuotaCountData: MassEmailSMSEQuotaCountModel? { get }
    var  getmassEmailSMSAuditQuotaCountData: MassEmailSMSEQuotaCountModel? { get }
    func localToServerWithDate(date: String) -> String
}

class MassEmailandSMSDetailViewModel: MassEmailandSMSDetailViewModelProtocol {
    var delegate: MassEmailandSMSDetailViewControlProtocol?
    var massEmailDeatilList: MassEmailSMSDetailListModel?
    var massEmailLeadTagsList: [MassEmailSMSTagListModel] = []
    var massEmailPateintsTagsList: [MassEmailSMSTagListModel] = []
    var massEmailSMSLeadCount: MassEmailSMSCountModel?
    var massEmailSMSPatientCount: MassEmailSMSCountModel?
    var massEmailSMSQuotaCount: MassEmailSMSEQuotaCountModel?
    var massEmailSMSAuditQuotaCount: MassEmailSMSEQuotaCountModel?
    
    init(delegate: MassEmailandSMSDetailViewControlProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
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
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)")
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailSMSLeadStatus):
                self.massEmailSMSLeadCount = massEmailSMSLeadStatus
                self.delegate?.massEmailSMSLeadCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailPatientStatusMethod(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String) {
        let appendParam = "appointmentStatus=\(appointmentStatus)&moduleName=\(moduleName)&patientTagIds=\(patientTagIds)&patientStatus=\(patientStatus)"
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)")
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailSMSPatientStatus):
                self.massEmailSMSPatientCount = massEmailSMSPatientStatus
                self.delegate?.massEmailSMSPatientCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailLeadStatusAllMethod() {
        let appendParam = "leadStatus=All&moduleName=All"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)")
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailSMSLeadStatus):
                self.massEmailSMSLeadCount = massEmailSMSLeadStatus
                self.delegate?.massEmailSMSLeadStatusAllDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getMassEmailPatientStatusAllMethod() {
        let appendParam = "appointmentStatus=All&moduleName=All&patientTagIds=&patientStatus="
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)")
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailSMSPatientStatus):
                self.massEmailSMSPatientCount = massEmailSMSPatientStatus
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
            case .success(let massEmailSMSQuotaCount):
                self.massEmailSMSQuotaCount = massEmailSMSQuotaCount
                self.delegate?.massEmailSMSEQuotaCountDataReceived()
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
    
    var getmassEmailSMSQuotaCountData: MassEmailSMSEQuotaCountModel? {
        return self.massEmailSMSQuotaCount
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
}
