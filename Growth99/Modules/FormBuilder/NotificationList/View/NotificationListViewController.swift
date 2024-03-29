//
//  NotificationListViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 26/02/23.
//

import Foundation
import UIKit

protocol NotificationListViewContollerProtocol {
    func NotificationListsDataRecived()
    func errorReceived(error: String)
    func notificationRemovedSuccefully(message: String)
}

class NotificationListViewController: UIViewController, NotificationListViewContollerProtocol,NotificationListTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: NotificationListViewModelProtocol?
    
    var questionId = Int()
    var selectedindex = 0
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.notificationList
        viewModel = NotificationListViewModel(delegate: self)
        tableView.register(UINib(nibName: "NotificationListTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationListTableViewCell")
        self.addSerchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        viewModel?.getNotificationListList(questionId: questionId)

    }

    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func removeNotification(cell: NotificationListTableViewCell, index: IndexPath) {
        var notificationName : String = ""
        var notificationId = Int()
        notificationName = viewModel?.getNotificationListDataAtIndexPath(index: index.row)?.notificationType ?? String.blank
            notificationId = viewModel?.getNotificationListDataAtIndexPath(index: index.row)?.id ?? 0
        if isSearch {
            notificationName = viewModel?.getNotificationFilterDataAtIndexPath(index: index.row)?.notificationType ?? String.blank
            notificationId =  viewModel?.getNotificationFilterDataAtIndexPath(index: index.row)?.id ?? 0
        }
        let alert = UIAlertController(title: Constant.Profile.deleteConcents , message: "Are you sure you want to delete \n\(notificationName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeNotification(questionId: self?.questionId ?? 0, notificationId: notificationId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func notificationRemovedSuccefully(message: String) {
        self.view.HideSpinner()
        self.view.showToast(message: message, color: .black)
        viewModel?.getNotificationListList(questionId: questionId)
    }
    
    
    func NotificationListsDataRecived(){
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
}
