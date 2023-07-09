//
//  LabelsViewController.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation
import UIKit

protocol LabelListViewControllerProtocol: AnyObject {
    func labelListRecived()
    func labelRemovedSuccefully(message: String)
    func errorReceived(error: String)
}

class LabelListViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: LabelListViewModelProtocol?
    var isSearch : Bool = false
    var labelId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LabelListViewModel(delegate: self)
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getLabelData.count ?? 0)
        self.setBarButton()
    }
        
    func registerTableView() {
        self.tableView.register(UINib(nibName: "LabelListTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel?.getLabelList()
        self.title = Constant.Profile.postLabel
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")

    }
    
    @objc func creatUser() {
        let PateintsTagsAddVC = UIStoryboard(name: "CreateLabelViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateLabelViewController") as! CreateLabelViewController
        PateintsTagsAddVC.screenName = "Create Screen"
        PateintsTagsAddVC.labelList = viewModel?.getLabelData
        self.navigationController?.pushViewController(PateintsTagsAddVC, animated: true)
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

extension LabelListViewController: LabelListTableViewCellDelegate{
   
    func editLabel(cell: LabelListTableViewCell, index: IndexPath) {
        let detailController = UIStoryboard(name: "CreateLabelViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateLabelViewController") as! CreateLabelViewController
        
        detailController.screenName = "Edit Screen"
        if self.isSearch {
            detailController.labelId = viewModel?.labelFilterListDataAtIndex(index: index.row)?.id ?? 0
            detailController.labelList = viewModel?.getLabelFilterData
        }else{
            detailController.labelId = viewModel?.labelListDataAtIndex(index: index.row)?.id ?? 0
            detailController.labelList = viewModel?.getLabelData
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func removeSocialProfile(cell: LabelListTableViewCell, index: IndexPath) {
        var tagName : String = ""
        var labelId: Int = 0
       
        if self.isSearch {
            labelId = self.viewModel?.labelFilterListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.labelFilterListDataAtIndex(index: index.row)?.name ?? String.blank
        }else{
            labelId = self.viewModel?.labelListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.labelListDataAtIndex(index: index.row)?.name ?? String.blank
        }
        
        let alert = UIAlertController(title: "Delete Post Label", message: "Are you sure you want to delete \n\(tagName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeLabel(LabelId: labelId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension LabelListViewController: LabelListViewControllerProtocol {
    
    func labelListRecived() {
        self.view.HideSpinner()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getLabelData.count ?? 0)
        self.tableView.reloadData()
    }
    
    func labelRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        self.viewModel?.getLabelList()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}
