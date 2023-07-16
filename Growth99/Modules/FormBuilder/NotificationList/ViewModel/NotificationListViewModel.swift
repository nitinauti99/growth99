//
//  NotificationListViewModel.swift
//  Growth99
//
//  Created by Nitin Auti on 26/02/23.
//

import Foundation

protocol NotificationListViewModelProtocol {
    func getNotificationListList(questionId: Int)
    var getNotificationListData: [NotificationListModel] { get }
    var getNotificationFilterListData: [NotificationListModel] { get }
    func filterData(searchText: String)
    func getNotificationListDataAtIndexPath(index: Int) -> NotificationListModel?
    func getNotificationFilterDataAtIndexPath(index: Int) -> NotificationListModel?
    func removeNotification(questionId: Int,notificationId: Int)
}

class NotificationListViewModel {
    var delegate: NotificationListViewContollerProtocol?
    var notificationListData: [NotificationListModel] = []
    var notificationFilteListrData: [NotificationListModel] = []
    
    init(delegate: NotificationListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getNotificationListList(questionId: Int) {
        let finaleURL = ApiUrl.notificationList.appending("\(questionId)/notifications")
        
        self.requestManager.request(forPath: finaleURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[NotificationListModel], GrowthNetworkError>) in
            switch result {
            case .success(let notificationListData):
                self.notificationListData = notificationListData
                self.delegate?.NotificationListsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func filterData(searchText: String) {
        self.notificationFilteListrData = self.notificationListData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.toEmail?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let phoneNumber = String(task.phoneNumber ?? "").prefix(searchText.count).elementsEqual(searchText)
            let notificationType = String(task.notificationType ?? "").prefix(searchText.count).elementsEqual(searchText)
            return nameMatch  || notificationType
        }
    }
    
    func getNotificationListDataAtIndexPath(index: Int) -> NotificationListModel? {
        return notificationListData[index]
        
    }
    
    func getNotificationFilterDataAtIndexPath(index: Int) -> NotificationListModel? {
        return self.notificationFilteListrData[index]
    }
    
    func removeNotification(questionId: Int,notificationId: Int) {
        let finaleUrl = ApiUrl.notificationList.appending("\(questionId)/notifications/\(notificationId)")
        
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.notificationRemovedSuccefully(message: "Questionnaire Notification deleted successfully")
                }else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "To Delete These Consents Form, Please remove it for the service attched")
                }else{
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
}

extension NotificationListViewModel: NotificationListViewModelProtocol {
    
    var getNotificationListData: [NotificationListModel] {
        return self.notificationListData
    }
    
    var getNotificationFilterListData: [NotificationListModel] {
        return self.notificationFilteListrData
    }
}
