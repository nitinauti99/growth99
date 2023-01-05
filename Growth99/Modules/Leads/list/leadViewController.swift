//
//  leadViewController.swift
//  Growth99
//
//  Created by nitin auti on 28/11/22.
//

import Foundation
import UIKit

protocol leadViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class leadViewController: UIViewController, leadViewControllerProtocol {
   
    @IBOutlet private weak var leadListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var viewModel: leadViewModelProtocol?
    var refreshControl : UIRefreshControl!
    var isSearch : Bool = false
    var filteredTableData:[String] = []
    var currentPage : Int = 0
    var isLoadingList : Bool = true
    var totalCount: Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = leadViewModel(delegate: self)
        self.setBarButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.getLeadList()
        self.setUpUI()
        addSerchBar()
        self.registerTableView()
        self.navigationItem.title = "Leads Overview"
    }
    
    func setBarButton(){
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "navImage"), for: .normal)
        button.addTarget(self, action:  #selector(creatLead), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func updateUI(){
        self.getLeadList()
        self.view.ShowSpinner()
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getLeadList()
    }
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        isLoadingList = false
        viewModel?.getLeadList(page: pageNumber, size: 10, statusFilter: "", sourceFilter: "", search: searchBar.text ?? "", leadTagFilter: "")
    }
    
    func loadMoreItemsForList(){
        if (viewModel?.leadUserData.count ?? 0) ==  viewModel?.leadTotalCount {
            return
        }
         currentPage += 1
         getListFromServer(currentPage)
     }
    
    func registerTableView() {
        self.leadListTableView.delegate = self
        self.leadListTableView.dataSource = self
        leadListTableView.register(UINib(nibName: "LeadHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadHeaderTableViewCell")
        leadListTableView.register(UINib(nibName: "LeadTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadTableViewCell")
    }
    
    func setUpUI(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl.backgroundColor = UIColor.clear
        self.refreshControl.tintColor = UIColor.black
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: UIControl.Event.valueChanged)
        self.leadListTableView.addSubview(self.refreshControl)
    }
    
    @IBAction func serachLeadList(sender: UIButton) {
        if searchBar.text == "" {
            return
        }
        self.view.ShowSpinner()
        currentPage = 0
        viewModel?.getLeadList(page: currentPage, size: 10, statusFilter: "", sourceFilter: "", search: searchBar.text ?? "", leadTagFilter: "")
    }
    
   @objc func pullToRefresh(sender:AnyObject) {
        self.refreshControl?.beginRefreshing()
        currentPage = 0
        searchBar.text = ""
        self.getLeadList()
    }
    
    @objc func creatLead() {
        let createLeadVC = UIStoryboard(name: "CreateLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateLeadViewController") as! CreateLeadViewController
        self.present(createLeadVC, animated: true)
    }
    
    @objc func getLeadList(){
        viewModel?.getLeadList(page: currentPage, size: 10, statusFilter: "", sourceFilter: "", search: "", leadTagFilter: "")
    }
    
    func LeadDataRecived() {
        self.refreshControl?.endRefreshing()
        self.view.HideSpinner()
        self.leadListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension leadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.leadUserData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = LeadTableViewCell()
        cell = leadListTableView.dequeueReusableCell(withIdentifier: "LeadTableViewCell") as! LeadTableViewCell
        cell.configureCell(leadVM: viewModel, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "leadDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "leadDetailViewController") as! leadDetailViewController
        detailController.LeadData = viewModel?.leadDataAtIndex(index: indexPath.row)
        navigationController?.pushViewController(detailController, animated: true)
    }
}

extension leadViewController:  UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.view.ShowSpinner()
            currentPage = 0
            self.getLeadList()
        }
     }

    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.ShowSpinner()
        currentPage = 0
        self.getLeadList()
    }
}
extension leadViewController:  UIScrollViewDelegate {
     
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isLoadingList = false
    }
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((leadListTableView.contentOffset.y + leadListTableView.frame.size.height) >= leadListTableView.contentSize.height) {
            self.loadMoreItemsForList()
            self.isLoadingList = true
        }
    }
}

