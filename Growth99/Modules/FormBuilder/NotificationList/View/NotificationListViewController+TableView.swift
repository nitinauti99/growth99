//
//  NotificationListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 26/02/23.
//

import Foundation
import UIKit

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getNotificationFilterListData.count ?? 0 == 0 {
                self.tableView.setEmptyMessage()
            } else {
                self.tableView.restore()
            }
            return viewModel?.getNotificationFilterListData.count ?? 0
        } else {
            if viewModel?.getNotificationListData.count ?? 0 == 0 {
                self.tableView.setEmptyMessage()
            } else {
                self.tableView.restore()
            }
            return viewModel?.getNotificationListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = NotificationListTableViewCell()
        cell = self.tableView.dequeueReusableCell(withIdentifier: "NotificationListTableViewCell", for: indexPath) as! NotificationListTableViewCell
        cell.delegate = self

        if isSearch {
            cell.configureCellisSearch(NotificationList: viewModel, index: indexPath)
        }else{
            cell.configureCell(NotificationList: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createNotificationVC = UIStoryboard(name: "CreateNotificationViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateNotificationViewController") as! CreateNotificationViewController
        var notificationId = Int()
            notificationId = viewModel?.getNotificationListDataAtIndexPath(index: indexPath.row)?.id ?? 0
        if isSearch {
            notificationId =  viewModel?.getNotificationFilterDataAtIndexPath(index: indexPath.row)?.id ?? 0
        }
        createNotificationVC.questionId = questionId
        createNotificationVC.notificationId = notificationId
        createNotificationVC.screenName = "Edit Notification"
        self.navigationController?.pushViewController(createNotificationVC, animated: true)
    }
   
    
}
