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
}

class NotificationListViewModel {
    var delegate: NotificationListViewContollerProtocol?
    var notificationListData: [NotificationListModel] = []
    var notificationFilteListrData: [NotificationListModel] = []
        
    init(delegate: NotificationListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
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
        self.notificationListData = (self.notificationListData.filter { $0.toEmail?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
   
    func getNotificationListDataAtIndexPath(index: Int) -> NotificationListModel? {
        return notificationListData[index]

    }
    
    func getNotificationFilterDataAtIndexPath(index: Int) -> NotificationListModel? {
        return self.notificationFilteListrData[index]
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
