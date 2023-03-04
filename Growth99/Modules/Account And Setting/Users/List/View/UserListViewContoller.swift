//
//  UserListViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 15/11/22.
//

import Foundation
import UIKit

protocol UserListViewContollerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class UserListViewContoller: UIViewController, UserListViewContollerProtocol {
    
    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: UserListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [UserListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = UserListViewModel(delegate: self)
        self.getUserList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        let detailController = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.registerTableView()
        self.title = Constant.Profile.users
    }
    
    @objc func updateUI(){
        self.view.ShowSpinner()
        self.getUserList()
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getUserList()
    }
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        viewModel?.getUserList()
    }

    func registerTableView() {
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
        userListTableView.register(UINib(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListTableViewCell")
    }
    
    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "UserCreateViewController", bundle: nil).instantiateViewController(withIdentifier: "UserCreateViewController") as! UserCreateViewController
        self.present(createUserVC, animated: true)
    }
    
    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getUserList()
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.userListTableView.setContentOffset(.zero, animated: true)
        self.userListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
