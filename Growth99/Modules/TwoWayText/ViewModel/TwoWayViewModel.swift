//
//  TwoWayViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 06/12/23.
//

import Foundation

protocol TwoWayListViewModelProtocol {
    func getTwoWayList(pageNo: Int, pageSize: Int, fromPage: String)
    func getTwoWayFilterData(searchText: String)
    func getTwoWayDataAtIndex(index: Int)-> AuditLogsList?
    func getTwoWayFilterDataAtIndex(index: Int)-> AuditLogsList?
    var  getTwoWayData: [AuditLogsList] { get }
    var  getTwoWayFilterData: [AuditLogsList] { get }
    var  getTwoWayFilterOpenData: [AuditLogsList] { get }
    var  getTwoWayFilterClosedData: [AuditLogsList] { get }
    var  getTwoWayFilterReadData: [AuditLogsList] { get }
    var  getTwoWayFilterUnReadData: [AuditLogsList] { get }
    var  selectedSegmentIndexValue: Int { get set }
    func sendMessage(msgData: [String: Any], sourceType: String)
}

class TwoWayListViewModel {
    var delegate: TwoWayListViewContollerProtocol?
    var twoWayListData: [AuditLogsList] = []
    var twoWayFilterData: [AuditLogsList] = []
    var twoWayFilterReadData: [AuditLogsList] = []
    var twoWayFilterUnReadData: [AuditLogsList] = []
    var selectedSegmentIndexValue: Int = 0
    
    var headers: HTTPHeaders {
        return ["x-tenantid": UserRepository.shared.Xtenantid ?? String.blank,
                "Authorization": "Bearer "+(UserRepository.shared.authToken ?? String.blank)
        ]
    }
    init(delegate: TwoWayListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getTwoWayList(pageNo: Int, pageSize: Int, fromPage: String) {
        let url = "\(ApiUrl.twoWayText)\(pageNo)&pageSize=\(pageSize)&searchText="
        self.requestManager.request(forPath: url, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<TwoWayModel, GrowthNetworkError>) in
            switch result {
            case .success(let twoWayListData):
                self.twoWayListData = twoWayListData.auditLogsList ?? []
                print( self.twoWayListData)
                if fromPage == "Detail" {
                    self.delegate?.twoWayDetailListDataRecived()
                } else {
                    self.delegate?.twoWayListDataRecived()
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func sendMessage(msgData: [String: Any], sourceType: String) {
        self.requestManager.request(forPath: ApiUrl.smsTwoWay.appending("/\(sourceType)/send-custom-sms"), method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: msgData, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.twoWayDetailDataRecived()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while sending message")
                } else {
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension TwoWayListViewModel: TwoWayListViewModelProtocol {
    
    func getTwoWayFilterData(searchText: String) {
        self.twoWayFilterData = self.getTwoWayData.filter { (task: AuditLogsList) -> Bool in
            let searchText = searchText.lowercased()
            let nameMatch = task.leadFullName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.sourceId ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
        
    }
    
    func getTwoWayDataAtIndex(index: Int)-> AuditLogsList? {
        return self.getTwoWayData[index]
    }
    
    func getTwoWayFilterDataAtIndex(index: Int)-> AuditLogsList? {
        return self.twoWayFilterData[index]
    }
    var getTwoWayFilterData: [AuditLogsList] {
        return self.twoWayFilterData
    }
    
    var getTwoWayData: [AuditLogsList] {
        switch selectedSegmentIndexValue {
        case 0:
            return getTwoWayFilterOpenData
        case 1:
            return getTwoWayFilterClosedData
        default:
            return twoWayListData
        }
    }
    
    var getTwoWayFilterOpenData: [AuditLogsList] {
        return twoWayListData.filter { $0.leadChatStatus == "OPEN" }
    }
    
    var getTwoWayFilterClosedData: [AuditLogsList] {
        return twoWayListData.filter { $0.leadChatStatus == "CLOSED" }
    }
    
    var getTwoWayFilterReadData: [AuditLogsList] {
        return twoWayListData.filter { $0.lastMessageRead == true }
    }
    
    var getTwoWayFilterUnReadData: [AuditLogsList] {
        return twoWayListData.filter { $0.lastMessageRead == false }
    }
}
