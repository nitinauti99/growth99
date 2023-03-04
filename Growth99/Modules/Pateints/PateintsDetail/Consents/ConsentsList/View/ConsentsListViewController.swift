//
//  ConsentsListViewController.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import Foundation
import UIKit

protocol ConsentsListViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class ConsentsListViewController: UIViewController, ConsentsListViewControllerProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var viewModel: ConsentsListViewModelProtocol?
    var filteredTableData = [ConsentsListModel]()
    var isSearch : Bool = false
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSerchBar()
        self.registerTableView()
        self.viewModel = ConsentsListViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        viewModel?.getConsentsList(pateintId: pateintId)
    }
  
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getConsentsList()
    }
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        viewModel?.getConsentsList(pateintId: pateintId)
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.register(UINib(nibName: "ConsentsListTableViewCell", bundle: nil), forCellReuseIdentifier: "ConsentsListTableViewCell")
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        self.present(createUserVC, animated: true)
    }
    
    @objc func getConsentsList(){
        self.view.ShowSpinner()
        viewModel?.getConsentsList(pateintId: pateintId)
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
        if viewModel?.consentsDataList.count == 0 {
            self.emptyMessage(parentView: self.view, message: "There is no data to show")
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
