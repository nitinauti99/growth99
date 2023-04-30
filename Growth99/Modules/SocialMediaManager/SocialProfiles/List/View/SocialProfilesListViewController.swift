//
//  SocialProfilesViewController.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation
import UIKit

protocol SocialProfilesListViewControllerProtocol: AnyObject {
    func socialProfilesListRecived()
    func socialProfilesRemovedSuccefully(message: String)
    func errorReceived(error: String)
}

class SocialProfilesListViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: SocialProfilesListViewModelProtocol?
    var isSearch : Bool = false
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getSocialProfilesData.count ?? 0)
        self.viewModel = SocialProfilesListViewModel(delegate: self)
        self.setBarButton()
    }
        
    func registerTableView() {
        self.tableView.register(UINib(nibName: "SocialProfilesListTableViewCell", bundle: nil), forCellReuseIdentifier: "SocialProfilesListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel?.getSocialProfilesList()
        self.title = Constant.Profile.socialProfiles
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(openSocialPlatform), imageName: "add")
    }
    
    @objc func openSocialPlatform(sender: UIButton) {
        let rolesArray = ["Facebook", "Instagram", "Linkedin"]
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            print(text ?? "")
            if text == "Facebook" {
                if let url = URL(string: "https://www.facebook.com/login/"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }else if (text == "Instagram") {
                if let url = URL(string: "https://www.instagram.com/accounts/login/"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }else {
                if let url = URL(string: "https://www.linkedin.com/login"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: 150, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    func addSerchBar(){
        self.searchBar.searchBarStyle = UISearchBar.Style.default
        self.searchBar.placeholder = "Search..."
        self.searchBar.sizeToFit()
        self.searchBar.isTranslucent = false
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
    }
}

extension SocialProfilesListViewController: SocialProfilesListTableViewCellDelegate {
   
    func editSocialProfiles(cell: SocialProfilesListTableViewCell, index: IndexPath) {
        let detailController = UIStoryboard(name: "CreateSocialProfileViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateSocialProfileViewController") as! CreateSocialProfileViewController
        detailController.socialProfilesScreenName = "Edit Screen"
        if self.isSearch {
            detailController.socialProfileId = viewModel?.socialProfilesFilterListDataAtIndex(index: index.row)?.id ?? 0
        }else{
            detailController.socialProfileId = viewModel?.socialProfilesListDataAtIndex(index: index.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func removeSocialProfile(cell: SocialProfilesListTableViewCell, index: IndexPath) {
        var tagName : String = ""
        var tagId: Int = 0
       
        if self.isSearch {
            tagId = self.viewModel?.socialProfilesFilterListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.socialProfilesFilterListDataAtIndex(index: index.row)?.name ?? String.blank
        }else{
            tagId = self.viewModel?.socialProfilesListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.socialProfilesListDataAtIndex(index: index.row)?.name ?? String.blank
        }
        
        let alert = UIAlertController(title: "Delete Social Profile", message: "Are you sure you want to delete \n\(tagName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeSocialProfiles(socialProfilesId: tagId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension SocialProfilesListViewController: SocialProfilesListViewControllerProtocol {
    
    func socialProfilesListRecived() {
        self.view.HideSpinner()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getSocialProfilesData.count ?? 0)
        self.tableView.reloadData()
    }
    
    func socialProfilesRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: .systemGreen)
        viewModel?.getSocialProfilesList()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}
