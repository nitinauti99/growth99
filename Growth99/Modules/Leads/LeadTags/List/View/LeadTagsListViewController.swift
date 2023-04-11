//
//  LeadTagsViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

protocol LeadTagsListViewControllerProtocol: AnyObject {
    func leadTagListRecived()
    func errorReceived(error: String)
    func leadTagRemovedSuccefully(message: String)
}

class LeadTagsListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: LeadTagsListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [PateintsTagListModel]()
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LeadTagsListViewModel(delegate: self)
        self.setBarButton()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getLeadTagsData.count ?? 0)
    }
    
    func registerTableView() {
        self.tableView.register(UINib(nibName: "LeadTagsListTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadTagsListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel?.getLeadTagsList()
        self.title = Constant.Profile.leadTags
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
    }
    
    @objc func creatUser() {
        let leadTagsAddVC = UIStoryboard(name: "LeadTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "LeadTagsAddViewController") as! LeadTagsAddViewController
        leadTagsAddVC.leadTagScreenName = "Create Screen"
        leadTagsAddVC.leadTagsList = viewModel?.getLeadTagsData
        self.navigationController?.pushViewController(leadTagsAddVC, animated: true)
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

extension LeadTagsListViewController: LeadTagsListViewControllerProtocol {
   
    func leadTagListRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getLeadTagsData.count ?? 0)
    }
    
    func leadTagRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        viewModel?.getLeadTagsList()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension LeadTagsListViewController: LeadTagsListTableViewCellDelegate {
    func removeLeadTag(cell: LeadTagsListTableViewCell, index: IndexPath) {
        var tagName : String = ""
        var tagId: Int = 0
       
        if self.isSearch {
            tagId = self.viewModel?.leadTagsFilterListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.leadTagsFilterListDataAtIndex(index: index.row)?.name ?? String.blank
        }else{
            tagId = self.viewModel?.leadTagsListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.leadTagsListDataAtIndex(index: index.row)?.name ?? String.blank
        }
        
        let alert = UIAlertController(title: "Delete Patient", message: "Are you sure you want to delete \n\(tagName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeLeadTag(leadId: tagId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func editLeadTag(cell: LeadTagsListTableViewCell, index: IndexPath) {
        let detailController = UIStoryboard(name: "LeadTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "LeadTagsAddViewController") as! LeadTagsAddViewController
        detailController.leadTagScreenName = "Edit Screen"
        detailController.leadTagsList = viewModel?.getLeadTagsData

        if self.isSearch {
            detailController.leadTagId = viewModel?.leadTagsFilterListDataAtIndex(index: index.row)?.id ?? 0
        }else{
            detailController.leadTagId = viewModel?.leadTagsListDataAtIndex(index: index.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
}
