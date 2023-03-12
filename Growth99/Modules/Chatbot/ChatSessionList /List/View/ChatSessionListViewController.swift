//
//  ChatSessionListViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 10/03/23.
//

import Foundation
import UIKit

protocol ChatSessionListViewControllerProtocol {
    func errorReceived(error: String)
    func chatSessionListReceivedSuccefully()
}

class ChatSessionListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
  
    var viewModel: ChatSessionListViewModelProtocol?
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSerchBar()
        self.title = Constant.Profile.chatSessionList
        self.viewModel = ChatSessionListViewModel(delegate: self)
        self.tableView.register(UINib(nibName: "ChatSessionListTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSessionListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getChatSessionList()
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
 }


extension ChatSessionListViewController: ChatSessionListViewControllerProtocol {
        
    func chatSessionListReceivedSuccefully(){
        self.view.HideSpinner()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
     }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
