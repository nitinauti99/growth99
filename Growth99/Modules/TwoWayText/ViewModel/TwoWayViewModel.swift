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
    var  getTwoWayFilterOpenReadData: [AuditLogsList] { get }
    var  getTwoWayFilterOpenUnReadData: [AuditLogsList] { get }
    
    var  getTwoWayFilterClosedData: [AuditLogsList] { get }
    var  getTwoWayFilterClosedReadData: [AuditLogsList] { get }
    var  getTwoWayFilterClosedUnReadData: [AuditLogsList] { get }

    var  selectedSegmentIndexValue: Int { get set }
    var  getTotalCount: Int { get }
    var  selectedChildSegmentIndexValue: Int { get set }

    var twoWayCompleteListData: [AuditLogsList] { get }
    var  selectedSegmentName: String { get set}
    func sendMessage(msgData: [String: Any], sourceType: String)
}

class TwoWayListViewModel {
    var delegate: TwoWayListViewContollerProtocol?
    var twoWayListData: [AuditLogsList] = []
    var twoWayFilterData: [AuditLogsList] = []
    var twoWayFilterReadData: [AuditLogsList] = []
    var twoWayFilterUnReadData: [AuditLogsList] = []
    var selectedSegmentIndexValue: Int = 0
    var  selectedChildSegmentIndexValue: Int = 0
    var selectedSegmentName: String = "Open"
    var totalCount: Int = 0

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
                if self.twoWayListData.count == 0 {
                    self.twoWayListData = twoWayListData.auditLogsList ?? []
                } else if(fromPage == "Detail"){
                    self.twoWayListData = []
                    self.twoWayListData = twoWayListData.auditLogsList ?? []
                }else if (fromPage == "Pagination") {
                    self.twoWayListData.append(contentsOf: twoWayListData.auditLogsList ?? [])
                }else if (fromPage == "List") {
                    self.twoWayListData = []
                    self.twoWayListData = twoWayListData.auditLogsList ?? []
                }
                self.totalCount = twoWayListData.totalNumberOfElements ?? 0
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
 
    var twoWayCompleteListData: [AuditLogsList] {
        return twoWayListData
    }
    
    func getTwoWayFilterData(searchText: String) {
        self.twoWayFilterData = self.getTwoWayData.filter { (task: AuditLogsList) -> Bool in
            let searchText = searchText.lowercased()
            let nameMatch = task.leadFullName?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let numberMatch = task.sourcePhoneNumber?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.sourceId ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || numberMatch || idMatch
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
    
    var getTotalCount: Int {
        return totalCount
    }
    
    var getTwoWayData: [AuditLogsList] {
        if selectedSegmentName == "Open" {
            switch selectedChildSegmentIndexValue {
            case 0:
                return getTwoWayFilterOpenReadData
            case 1:
                return getTwoWayFilterOpenUnReadData
            default:
                return twoWayListData
            }
        } else {
            switch selectedChildSegmentIndexValue {
            case 0:
                return getTwoWayFilterClosedReadData
            case 1:
                return getTwoWayFilterClosedUnReadData
            default:
                return twoWayListData
            }
        }
    }
    
    var getTwoWayFilterOpenData: [AuditLogsList] {
        return twoWayListData.filter { $0.leadChatStatus == "OPEN" }
    }
    
    var getTwoWayFilterOpenReadData: [AuditLogsList] {
        return getTwoWayFilterOpenData.filter { $0.lastMessageRead == true }
    }
    
    var getTwoWayFilterOpenUnReadData: [AuditLogsList] {
        return getTwoWayFilterOpenData.filter { $0.lastMessageRead == false }
    }
    
    
    var getTwoWayFilterClosedData: [AuditLogsList] {
        return twoWayListData.filter { $0.leadChatStatus == "CLOSE" }
    }
    
    var getTwoWayFilterClosedReadData: [AuditLogsList] {
        return getTwoWayFilterClosedData.filter { $0.lastMessageRead == true }
    }
    
    var getTwoWayFilterClosedUnReadData: [AuditLogsList] {
        return getTwoWayFilterClosedData.filter { $0.lastMessageRead == false }
    }
}
