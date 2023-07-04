//
//  PateintsTagsListViewController.swift
//  Growth99
//
//  Created by nitin auti on 29/01/23.
//

import Foundation
import UIKit

protocol PateintsTagsListViewControllerProtocol: AnyObject {
    func pateintsTagListRecived()
    func pateintTagRemovedSuccefully(mrssage: String)
    func errorReceived(error: String)
}

class PateintsTagsListViewController: UIViewController {
   
    @IBOutlet weak var pateintsTagsListTableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: PateintsTagsListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [PateintsTagListModel]()
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PateintsTagsListViewModel(delegate: self)
        self.setBarButton()
        self.pateintsTagsListTableview.setEmptyMessage(arrayCount: viewModel?.getPateintsTagsData.count ?? 0)
    }
        
    func registerTableView() {
        pateintsTagsListTableview.register(UINib(nibName: "PateintsTagListTableViewCell", bundle: nil), forCellReuseIdentifier: "PateintsTagListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel?.getPateintsTagsList()
        self.title = Constant.Profile.patientTags
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
    }
    
    @objc func creatUser() {
        let PateintsTagsAddVC = UIStoryboard(name: "PateintsTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintsTagsAddViewController") as! PateintsTagsAddViewController
        PateintsTagsAddVC.pateintsTagScreenName = "Create Screen"
        PateintsTagsAddVC.pateintsTagsList = viewModel?.getPateintsTagsData
        self.navigationController?.pushViewController(PateintsTagsAddVC, animated: true)
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        self.searchBar.text = ""
        self.isSearch = false
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
}

extension PateintsTagsListViewController: PateintsTagsListViewControllerProtocol {
   
    func pateintsTagListRecived() {
        self.view.HideSpinner()
        self.pateintsTagsListTableview.reloadData()
        self.pateintsTagsListTableview.setEmptyMessage(arrayCount: viewModel?.getPateintsTagsData.count ?? 0)
    }
    
    func pateintTagRemovedSuccefully(mrssage: String){
        self.view.showToast(message: mrssage, color: UIColor().successMessageColor())
        self.viewModel?.getPateintsTagsList()
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension PateintsTagsListViewController: PateintsTagListTableViewCellDelegate {
  
    func removePatieintTag(cell: PateintsTagListTableViewCell, index: IndexPath) {
        var tagName : String = ""
        var tagId: Int = 0
       
        if self.isSearch {
            tagId = self.viewModel?.pateintsTagsFilterListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.pateintsTagsFilterListDataAtIndex(index: index.row)?.name ?? String.blank
        }else{
            tagId = self.viewModel?.pateintsTagsListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.pateintsTagsListDataAtIndex(index: index.row)?.name ?? String.blank
        }
        
        let alert = UIAlertController(title: "Delete Patient Tag", message: "Are you sure you want to delete \n\(tagName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removePateintsTag(pateintsTagid: tagId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
    func editPatieintTag(cell: PateintsTagListTableViewCell, index: IndexPath) {
        let detailController = UIStoryboard(name: "PateintsTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintsTagsAddViewController") as! PateintsTagsAddViewController
        detailController.pateintsTagScreenName = "Edit Screen"
        detailController.pateintsTagsList = viewModel?.getPateintsTagsData
        if self.isSearch {
            detailController.patientTagId = viewModel?.pateintsTagsFilterListDataAtIndex(index: index.row)?.id ?? 0
        }else{
            detailController.patientTagId = viewModel?.pateintsTagsListDataAtIndex(index: index.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
}
