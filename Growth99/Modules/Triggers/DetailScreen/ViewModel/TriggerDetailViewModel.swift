//
//  TriggerDetailViewModel.swift
//  Growth99
//
//  Created by Apple on 07/03/23.
//

import Foundation
protocol TriggerDetailViewModelProtocol {
    func getTriggerDetailList()
    func getTriggerLeadTagsList()
    func getTriggerPateintsTagsList()
    func getTriggerLeadStatusMethod(leadStatus: String, moduleName: String, leadTagIds: String, source: String)
    func getTriggerPatientStatusMethod(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String)
    func getTriggerBusinessSMSQuotaMethod()
    func getTriggerAuditEmailQuotaMethod()
    func getTriggerLeadStatusAllMethod()
    func getTriggerPatientStatusAllMethod()
    var  getTriggerDetailData: TriggerDetailListModel? { get }
    var  getTriggerLeadTagsData: [TriggerTagListModel] { get }
    var  getTriggerPateintsTagsData: [TriggerTagListModel] { get }
    var  getTriggerSMSPatientCountData: TriggerCountModel? { get }
    var  getTriggerSMSLeadCountData: TriggerCountModel? { get }
    var  getTriggerSMSQuotaCountData: TriggerEQuotaCountModel? { get }
    var  getTriggerSMSAuditQuotaCountData: TriggerEQuotaCountModel? { get }
    func localToServerWithDate(date: String) -> String
}

class TriggerDetailViewModel: TriggerDetailViewModelProtocol {
    var delegate: TriggerDetailViewControlProtocol?
    var TriggerDeatilList: TriggerDetailListModel?
    var TriggerLeadTagsList: [TriggerTagListModel] = []
    var TriggerPateintsTagsList: [TriggerTagListModel] = []
    var TriggerSMSLeadCount: TriggerCountModel?
    var TriggerSMSPatientCount: TriggerCountModel?
    var TriggerSMSQuotaCount: TriggerEQuotaCountModel?
    var TriggerSMSAuditQuotaCount: TriggerEQuotaCountModel?
    
    init(delegate: TriggerDetailViewControlProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getTriggerLeadTagsList() {
        self.requestManager.request(forPath: ApiUrl.leadTagList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[TriggerTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let TriggerLeadTagsList):
                self.TriggerLeadTagsList = TriggerLeadTagsList
                self.delegate?.triggerLeadTagsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerPateintsTagsList() {
        self.requestManager.request(forPath: ApiUrl.patientTagList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[TriggerTagListModel], GrowthNetworkError>) in
            switch result {
            case .success(let pateintsTagList):
                self.TriggerPateintsTagsList = pateintsTagList
                self.delegate?.triggerPatientTagsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerDetailList() {
        self.requestManager.request(forPath: ApiUrl.massEmailTrigerList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerDetailListModel, GrowthNetworkError>) in
            switch result {
            case .success(let TriggerDeatilList):
                self.TriggerDeatilList = TriggerDeatilList
                self.delegate?.triggerDetailDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerLeadStatusMethod(leadStatus: String, moduleName: String, leadTagIds: String, source: String) {
        let appendParam = "leadStatus=\(leadStatus)&moduleName=\(moduleName)&leadTagIds=\(leadTagIds)&source=\(source)"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)")
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let TriggerSMSLeadStatus):
                self.TriggerSMSLeadCount = TriggerSMSLeadStatus
                self.delegate?.triggerSMSLeadCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerPatientStatusMethod(appointmentStatus: String, moduleName: String, patientTagIds: String, patientStatus: String) {
        let appendParam = "appointmentStatus=\(appointmentStatus)&moduleName=\(moduleName)&patientTagIds=\(patientTagIds)&patientStatus=\(patientStatus)"
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)")
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let TriggerSMSPatientStatus):
                self.TriggerSMSPatientCount = TriggerSMSPatientStatus
                self.delegate?.triggerSMSPatientCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerLeadStatusAllMethod() {
        let appendParam = "leadStatus=All&moduleName=All"
        let url = ApiUrl.massEmailLeadStatus.appending("\(appendParam)")
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let TriggerSMSLeadStatus):
                self.TriggerSMSLeadCount = TriggerSMSLeadStatus
                self.delegate?.triggerSMSLeadStatusAllDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerPatientStatusAllMethod() {
        let appendParam = "appointmentStatus=All&moduleName=All&patientTagIds=&patientStatus="
        let url = ApiUrl.massEmailAppointmentStatus.appending("\(appendParam)")
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let TriggerSMSPatientStatus):
                self.TriggerSMSPatientCount = TriggerSMSPatientStatus
                self.delegate?.triggerSMSPatientStatusAllDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerBusinessSMSQuotaMethod() {
        self.requestManager.request(forPath: ApiUrl.massEmailBusinessSMSQuota, method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerEQuotaCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let TriggerSMSQuotaCount):
                self.TriggerSMSQuotaCount = TriggerSMSQuotaCount
                self.delegate?.triggerSMSEQuotaCountDataReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getTriggerAuditEmailQuotaMethod() {
        self.requestManager.request(forPath: ApiUrl.massEmailAuditEmailSMSQuota, method: .GET, headers: self.requestManager.Headers()) { (result: Result<TriggerEQuotaCountModel, GrowthNetworkError>) in
            switch result {
            case .success(let TriggerSMSAuditQuotaCount):
                self.TriggerSMSAuditQuotaCount = TriggerSMSAuditQuotaCount
                self.delegate?.triggerSMSAuditQuotaCountDataReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getTriggerDetailData: TriggerDetailListModel? {
        return self.TriggerDeatilList
    }
    
    var getTriggerLeadTagsData: [TriggerTagListModel] {
        return self.TriggerLeadTagsList
    }
    
    var getTriggerPateintsTagsData: [TriggerTagListModel] {
        return self.TriggerPateintsTagsList
    }
    
    var getTriggerSMSPatientCountData: TriggerCountModel? {
        return self.TriggerSMSPatientCount
    }
    
    var getTriggerSMSLeadCountData: TriggerCountModel? {
        return self.TriggerSMSLeadCount
    }
    
    var getTriggerSMSQuotaCountData: TriggerEQuotaCountModel? {
        return self.TriggerSMSQuotaCount
    }
    
    var getTriggerSMSAuditQuotaCountData: TriggerEQuotaCountModel? {
        return self.TriggerSMSAuditQuotaCount
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
