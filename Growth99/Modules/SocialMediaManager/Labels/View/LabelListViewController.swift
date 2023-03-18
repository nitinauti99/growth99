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
        self.title = Constant.Profile.socialProfiles
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
    }
    
    @objc func creatUser() {
        let PateintsTagsAddVC = UIStoryboard(name: "PateintsTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintsTagsAddViewController") as! PateintsTagsAddViewController
       // PateintsTagsAddVC.LabelScreenName = "Create Screen"
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
        let detailController = UIStoryboard(name: "CreateSocialProfileViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateSocialProfileViewController") as! CreateSocialProfileViewController
        detailController.socialProfilesScreenName = "Edit Screen"
        if self.isSearch {
            detailController.socialProfileId = viewModel?.labelFilterListDataAtIndex(index: index.row)?.id ?? 0
        }else{
            detailController.socialProfileId = viewModel?.labelListDataAtIndex(index: index.row)?.id ?? 0
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
        
        let alert = UIAlertController(title: "Delete Patient", message: "Are you sure you want to delete \n\(tagName)", preferredStyle: UIAlertController.Style.alert)
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
        self.tableView.reloadData()
        if viewModel?.getLabelData.count == 0 {
            self.emptyMessage(parentView: self.view, message: "There is no data to show")
        }else{
            self.emptyMessage(parentView: self.view, message: "")
        }
    }
    
    func labelRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: .red)
        viewModel?.getLabelList()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
