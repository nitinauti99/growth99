//
//  DeletedDeletedLeadListViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

protocol DeletedLeadListViewControllerProtocol: AnyObject {
    func DeletedLeadListDataRecived()
    func errorReceived(error: String)
    func leadRemovedSuccefully(mrssage: String)
}

class DeletedLeadListViewController: UIViewController, DeletedLeadListViewControllerProtocol {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var viewModel: DeletedLeadListViewModelProtocol?
    var isSearch : Bool = false
    var currentPage : Int = 0
    var isLoadingList : Bool = true
    var totalCount: Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = DeletedLeadListViewModel(delegate: self)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = Constant.Profile.deletedLeadListTitle
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.getDeletedLeadList()
    }
  
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }

    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        self.isLoadingList = false
        self.viewModel?.getDeletedLeadList(page: pageNumber, size: 10, statusFilter: "", sourceFilter: "", search: searchBar.text ?? String.blank, leadTagFilter: "")
    }
    
    func registerTableView() {
        self.tableView.register(UINib(nibName: "DeletedLeadListTableViewCell", bundle: nil), forCellReuseIdentifier: "DeletedLeadListTableViewCell")
    }
    
    @IBAction func serachDeletedLeadListList(sender: UIButton) {
        if searchBar.text == "" {
            return
        }
        self.view.ShowSpinner()
        self.currentPage = 0
        self.viewModel?.getDeletedLeadList(page: currentPage, size: 10, statusFilter: "", sourceFilter: "", search: searchBar.text ?? String.blank, leadTagFilter: "")
    }
    

    
    func leadRemovedSuccefully(mrssage: String){
        self.view.showToast(message: mrssage, color: .red)
        self.getDeletedLeadList()
    }

    @objc func getDeletedLeadList(){
        self.viewModel?.getDeletedLeadList(page: currentPage, size: 10, statusFilter: "", sourceFilter: "", search: "", leadTagFilter: "")
    }
    
    func DeletedLeadListDataRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
