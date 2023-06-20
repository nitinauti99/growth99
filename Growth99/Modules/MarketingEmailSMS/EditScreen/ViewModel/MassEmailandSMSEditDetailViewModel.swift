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
    func getMassSMSEditLeadTagsListEdit()
    func getMassSMSEditPateintsTagsListEdit()
    func getMassSMSEditBusinessSMSQuotaMethod()
    func getMassSMSEditAuditEmailQuotaMethod()
    var  getMassSMSTriggerEditListData: MassSMSEditModel? { get }
    var  getMassSMSEditEmailSmsQuotaData: MassEmailSMSEQuotaCountModelEdit? { get }
    var  getMassSMSEditEmailSmsCount: MassEmailSMSEQuotaCountModelEdit? { get }
}

class MassEmailandSMSEditDetailViewModel: MassEmailandSMSEditDetailViewModelProtocol {
    
    var delegate: MassEmailandSMSEditDetailViewControlProtocol?
    var massSMStriggerEditList: MassSMSEditModel?
    var massSMStriggerEditDetailList: MassEmailSMSDetailListModelEdit?
    var massSMSEditLeadTagsList: [MassEmailSMSTagListModelEdit] = []
    var massSMSEditPateintsTagsList: [MassEmailSMSTagListModelEdit] = []
    var massSMSEditEmailSmsQuota: MassEmailSMSEQuotaCountModelEdit?
    var massSMSEditEmailSmsCount: MassEmailSMSEQuotaCountModelEdit?
    
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
    
    var getMassSMSTriggerEditListData: MassSMSEditModel? {
        return massSMStriggerEditList
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
    
    var getMassEmailEditDetailData: MassEmailSMSDetailListModelEdit? {
        return self.massSMStriggerEditDetailList
    }
    
    func getMassSMSEditLeadTagsListEdit() {
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
    
    
    func getMassSMSEditPateintsTagsListEdit() {
        self.requestManager.request(forPath: ApiUrl.patientTagList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[MassEmailSMSTagListModelEdit], GrowthNetworkError>) in
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
            case .success(let emailSmsQuota):
                self.massSMSEditEmailSmsQuota = emailSmsQuota
                self.delegate?.massSMSEditEmailSmsQuotaDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getMassSMSEditEmailSmsQuotaData: MassEmailSMSEQuotaCountModelEdit? {
        return massSMSEditEmailSmsQuota
    }
    
    func getMassSMSEditAuditEmailQuotaMethod() {
        self.requestManager.request(forPath: ApiUrl.massEmailAuditEmailSMSQuota, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSEQuotaCountModelEdit, GrowthNetworkError>) in
            switch result {
            case .success(let emailSmsCount):
                self.massSMSEditEmailSmsCount = emailSmsCount
                self.delegate?.massSMSEditEmailSmsCountDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedEdit(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getMassSMSEditEmailSmsCount: MassEmailSMSEQuotaCountModelEdit? {
        return massSMSEditEmailSmsCount
    }
}
