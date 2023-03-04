//
//  leadListViewController.swift
//  Growth99
//
//  Created by nitin auti on 28/11/22.
//

import Foundation
import UIKit

protocol leadListViewControllerProtocol: AnyObject {
    func leadListDataRecived()
    func errorReceived(error: String)
}

class leadListViewController: UIViewController, leadListViewControllerProtocol {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var viewModel: leadListViewModelProtocol?
    var isSearch : Bool = false
    var currentPage : Int = 0
    var isLoadingList : Bool = true
    var totalCount: Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = leadListViewModel(delegate: self)
        self.view.ShowSpinner()
        self.getleadList()
        self.setBarButton()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = Constant.Profile.leadListTitle
        self.addSerchBar()
        self.registerTableView()
    }

    func setBarButton(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationleadList"), object: nil)
        self.navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
    }
    
    @objc func updateUI(){
        self.getleadList()
        self.view.ShowSpinner()
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
        self.viewModel?.getleadList(page: pageNumber, size: 10, statusFilter: "", sourceFilter: "", search: searchBar.text ?? String.blank, leadListTagFilter: "")
    }
    
    func loadMoreItemsForList(){
        if (viewModel?.getleadListData.count ?? 0) ==  viewModel?.leadListTotalCount {
            return
        }
        self.currentPage += 1
        self.getListFromServer(currentPage)
     }
    
    func registerTableView() {
        self.tableView.register(UINib(nibName: "leadListHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "leadListHeaderTableViewCell")
        self.tableView.register(UINib(nibName: "leadListTableViewCell", bundle: nil), forCellReuseIdentifier: "leadListTableViewCell")
    }
    
    @IBAction func serachleadListList(sender: UIButton) {
        if searchBar.text == "" {
            return
        }
        self.view.ShowSpinner()
        self.currentPage = 0
        self.viewModel?.getleadList(page: currentPage, size: 10, statusFilter: "", sourceFilter: "", search: searchBar.text ?? String.blank, leadListTagFilter: "")
    }
    
    @objc func creatUser() {
        let createleadListVC = UIStoryboard(name: "CreateLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateLeadViewController") as! CreateLeadViewController
        self.present(createleadListVC, animated: true)
    }
    
    @objc func getleadList(){
        self.viewModel?.getleadList(page: currentPage, size: 10, statusFilter: "", sourceFilter: "", search: "", leadListTagFilter: "")
    }
    
    func leadListDataRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
