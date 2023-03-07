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
    var  getMassEmailDetailData: [MassEmailandSMSDetailModel] { get }
    var  getMassEmailLeadTagsData: [MassEmailSMSTagListModel] { get }
    var  getMassEmailPateintsTagsData: [MassEmailSMSTagListModel] { get }
}

class MassEmailandSMSDetailViewModel {
    var delegate: MassEmailandSMSDetailVCProtocol?
    var massEmailDeatilList: [MassEmailandSMSDetailModel] = []
    var massEmailLeadTagsList: [MassEmailSMSTagListModel] = []
    var massEmailPateintsTagsList: [MassEmailSMSTagListModel] = []

    init(delegate: MassEmailandSMSDetailVCProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getMassEmailLeadTagsList() {
        self.requestManager.request(forPath: ApiUrl.leadTagList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[MassEmailSMSTagListModel], GrowthNetworkError>) in
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
        self.requestManager.request(forPath: ApiUrl.patientTagList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[MassEmailSMSTagListModel], GrowthNetworkError>) in
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
        self.requestManager.request(forPath: ApiUrl.massEmailTrigerList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[MassEmailandSMSDetailModel], GrowthNetworkError>) in
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
    
    var getMassEmailDetailData: [MassEmailandSMSDetailModel] {
        return self.massEmailDeatilList
    }

    var getMassEmailLeadTagsData: [MassEmailSMSTagListModel] {
        return self.massEmailLeadTagsList
    }
    
    var getMassEmailPateintsTagsData: [MassEmailSMSTagListModel] {
        return self.massEmailPateintsTagsList
    }
}

