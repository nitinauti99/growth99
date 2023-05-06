//
//  UserListViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 15/11/22.
//

import Foundation
import UIKit

protocol UserListViewContollerProtocol: AnyObject {
    func userListRecived()
    func errorReceived(error: String)
    func userRemovedSuccefully(message: String)
}

class UserListViewContoller: UIViewController {
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: UserListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [UserListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = UserListViewModel(delegate: self)
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self,
                                                                     action: #selector(addUserButtonTapped),
                                                                     imageName: "add")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.title = Constant.Profile.users
        self.view.ShowSpinner()
        self.viewModel?.getUserList()
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        let detailController = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func addSerchBar(){
        self.searchBar.searchBarStyle = UISearchBar.Style.default
        self.searchBar.placeholder = "Search..."
        self.searchBar.sizeToFit()
        self.searchBar.isTranslucent = false
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
    }
   
    func registerTableView() {
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
        self.userListTableView.register(UINib(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListTableViewCell")
    }

}

extension UserListViewContoller: UserListTableViewCellDelegate {
   
    func removeUser(cell: UserListTableViewCell, index: IndexPath) {
        var fullName: String = ""
        var userId: Int = 0
        
        if isSearch {
            fullName = (viewModel?.userFilterDataDataAtIndex(index: index.row)?.firstName ?? "")  + (viewModel?.userDataAtIndex(index: index.row)?.lastName ?? "")
            userId = self.viewModel?.userFilterDataDataAtIndex(index: index.row)?.id ?? 0
        }else{
            fullName = (viewModel?.userDataAtIndex(index: index.row)?.firstName ?? "")  + (viewModel?.userDataAtIndex(index: index.row)?.lastName ?? "")
            userId = self.viewModel?.userDataAtIndex(index: index.row)?.id ?? 0
        }
       
        let alert = UIAlertController(title: "Delete User", message: "Are you sure you want to delete \n\(fullName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeUser(userId: userId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editUser(cell: UserListTableViewCell, index: IndexPath) {
       
        if  UserRepository.shared.screenTitle == "Profile" {
            if isSearch {
                UserRepository.shared.userVariableId = viewModel?.userDataAtIndex(index: index.row)?.id ?? 0
            } else {
                UserRepository.shared.userVariableId = viewModel?.userDataAtIndex(index: index.row)?.id ?? 0
            }
            self.navigationController?.popViewController(animated: true)
            
        } else {
            guard let homeVC = UIStoryboard(name: "BaseTabbar", bundle: nil).instantiateViewController(withIdentifier: "HomeViewContoller") as? HomeViewContoller else {
                return
            }
            if isSearch {
                UserRepository.shared.userVariableId = viewModel?.userDataAtIndex(index: index.row)?.id ?? 0
            } else {
                UserRepository.shared.userVariableId = viewModel?.userDataAtIndex(index: index.row)?.id ?? 0
            }
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }

}

extension UserListViewContoller: UserListViewContollerProtocol{
   
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func userListRecived() {
        self.view.HideSpinner()
        self.userListTableView.setContentOffset(.zero, animated: true)
        self.userListTableView.reloadData()
    }
    
    func userRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        self.viewModel?.getUserList()
    }
}

