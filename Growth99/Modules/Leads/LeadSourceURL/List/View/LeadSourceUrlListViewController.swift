//
//  LeadSourceUrlListViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import Foundation
import UIKit

protocol LeadSourceUrlListViewControllerProtocol: AnyObject {
    func leadTagListRecived()
    func errorReceived(error: String)
    func leadSoureceUrlRemovedSuccefully(message: String)
}

class LeadSourceUrlListViewController: UIViewController, LeadSourceUrlListViewControllerProtocol,LeadSourceUrlListTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: LeadSourceUrlListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [PateintsTagListModel]()
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LeadSourceUrlListViewModel(delegate: self)
        self.setBarButton()
    }
        
    func registerTableView() {
        self.tableView.register(UINib(nibName: "LeadSourceUrlListTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadSourceUrlListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel?.getLeadSourceUrlList()
        self.title = Constant.Profile.leadSourceURLs
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
    }
    
    @objc func creatUser() {
        let leadTagsAddVC = UIStoryboard(name: "LeadSourceUrlAddViewController", bundle: nil).instantiateViewController(withIdentifier: "LeadSourceUrlAddViewController") as! LeadSourceUrlAddViewController
        leadTagsAddVC.leadTagScreenName = "Create Screen"
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
    
    func leadTagListRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func removeLeadTag(cell: LeadSourceUrlListTableViewCell, index: IndexPath) {
        var tagName : String = ""
        var tagId: Int = 0
       
        if self.isSearch {
            tagId = self.viewModel?.leadTagsFilterListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.leadTagsFilterListDataAtIndex(index: index.row)?.sourceUrl ?? String.blank
        }else{
            tagId = self.viewModel?.leadTagsListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.leadTagsListDataAtIndex(index: index.row)?.sourceUrl ?? String.blank
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

    func leadSoureceUrlRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: .red)
        viewModel?.getLeadSourceUrlList()
    }

    func editLeadTag(cell: LeadSourceUrlListTableViewCell, index: IndexPath) {
        let detailController = UIStoryboard(name: "LeadSourceUrlAddViewController", bundle: nil).instantiateViewController(withIdentifier: "LeadSourceUrlAddViewController") as! LeadSourceUrlAddViewController
        detailController.leadTagScreenName = "Edit Screen"
        if self.isSearch {
            detailController.leadSourceUrlId = viewModel?.leadTagsFilterListDataAtIndex(index: index.row)?.id ?? 0
        }else{
            detailController.leadSourceUrlId = viewModel?.leadTagsListDataAtIndex(index: index.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
}
