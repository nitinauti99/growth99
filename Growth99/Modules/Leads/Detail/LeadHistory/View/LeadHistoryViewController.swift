//
//  LeadHistoryViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import Foundation
import UIKit

protocol LeadHistoryViewControllerProtocol: AnyObject {
    func LeadHistoryDataRecived()
    func errorReceived(error: String)
}

class LeadHistoryViewController: UIViewController, LeadHistoryViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: LeadHistoryViewModelProtocol?
    var isSearch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LeadHistoryViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.title = Constant.Profile.leadHistroy
        self.view.ShowSpinner()
        self.viewModel?.getLeadHistory()
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }

    func registerTableView() {
        self.tableView.register(UINib(nibName: "LeadHistoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadHistoryListTableViewCell")
    }
    
    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getLeadHistory()
    }
    
    func LeadHistoryDataRecived() {
        self.view.HideSpinner()
        self.tableView.setContentOffset(.zero, animated: true)
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
