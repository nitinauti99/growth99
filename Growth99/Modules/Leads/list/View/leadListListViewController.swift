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
    func leadRemovedSuccefully(mrssage: String)
    func errorReceived(error: String)
}

class leadListViewController: UIViewController, leadListTableViewCellDelegate {
   
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
        self.setBarButton()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = Constant.Profile.leadListTitle
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.getleadList()
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
        self.viewModel?.getleadList(page: pageNumber, size: 10, statusFilter: "", sourceFilter: "", search: searchBar.text ?? String.blank, leadTagFilter: "")
    }
    
    func loadMoreItemsForList(){
        if (viewModel?.getleadListData.count ?? 0) ==  viewModel?.leadListTotalCount {
            return
        }
        self.currentPage += 1
        self.getListFromServer(currentPage)
     }
    
    func registerTableView() {
        self.tableView.register(UINib(nibName: "leadListTableViewCell", bundle: nil), forCellReuseIdentifier: "leadListTableViewCell")
    }
    
    @IBAction func serachleadList(sender: UIButton) {
        if searchBar.text == "" {
            return
        }
        self.view.ShowSpinner()
        self.currentPage = 0
        self.viewModel?.getleadList(page: currentPage, size: 10, statusFilter: "", sourceFilter: "", search: searchBar.text ?? String.blank, leadTagFilter: "")
    }
    
    @objc func creatUser() {
        let createleadListVC = UIStoryboard(name: "CreateLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateLeadViewController") as! CreateLeadViewController
        self.navigationController?.pushViewController(createleadListVC, animated: true)
    }
    
    func removeLead(cell: leadListTableViewCell, index: IndexPath) {
        let fullName = (viewModel?.leadPeginationListDataAtIndex(index: index.row)?.firstName ?? "")  + (viewModel?.leadPeginationListDataAtIndex(index: index.row)?.lastName ?? "")
        
        let alert = UIAlertController(title: "Delete Lead", message: "Are you sure you want to delete \n\(fullName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            let leadId = self?.viewModel?.leadPeginationListDataAtIndex(index: index.row)?.id ?? 0
            self?.viewModel?.removeLead(leadId: leadId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editLead(cell: leadListTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "EditLeadViewController", bundle: nil).instantiateViewController(withIdentifier: "EditLeadViewController") as! EditLeadViewController
        editVC.LeadId = viewModel?.leadPeginationListDataAtIndex(index: index.row)?.id ?? 0
        editVC.LeadData = viewModel?.leadPeginationListDataAtIndex(index: index.row)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func detailLead(cell: leadListTableViewCell, index: IndexPath) {
        let LeadDetail = LeadDetailContainerView.viewController()
        LeadDetail.workflowLeadId = viewModel?.leadPeginationListDataAtIndex(index: index.row)?.id ?? 0
        self.navigationController?.pushViewController(LeadDetail, animated: true)
    }
    
    @objc func getleadList(){
        self.viewModel?.getleadList(page: currentPage, size: 10, statusFilter: "", sourceFilter: "", search: "", leadTagFilter: "")
    }
    
}

extension leadListViewController: leadListViewControllerProtocol {
   
    func leadRemovedSuccefully(mrssage: String){
        self.view.showToast(message: mrssage, color: UIColor().successMessageColor())
        self.getleadList()
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
