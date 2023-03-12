//
//  ChatSessionDetailViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 12/03/23.
//

import Foundation
import UIKit

protocol ChatSessionDetailViewControllerProtocol {
    func errorReceived(error: String)
    func chatSessionDetailReceivedSuccefully()
}

class ChatSessionDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
  
    var viewModel: ChatSessionDetailViewModelProtocol?
    var isSearch: Bool = false
    var chatQuestionareId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.chatSessionList
        self.viewModel = ChatSessionDetailViewModel(delegate: self)
        self.registerCell()
    }
    
    func registerCell(){
        self.tableView.register(UINib(nibName: "ChatSessionUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSessionUserTableViewCell")
        self.tableView.register(UINib(nibName: "ChatSessionBotTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSessionBotTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getChatSessionDetail(chatSessionId: self.chatQuestionareId)
    }
  }

extension ChatSessionDetailViewController: ChatSessionDetailViewControllerProtocol {
        
    func chatSessionDetailReceivedSuccefully(){
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
