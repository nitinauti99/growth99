//
//  TasksListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

protocol TasksListViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
}

class TasksListViewController: UIViewController, TasksListViewControllerProtocol {
    
    @IBOutlet private weak var taskListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: TasksListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [TaskDTOList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TasksListViewModel(delegate: self)
        self.getUserList()
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        let createVC = UIStoryboard(name: "CreateTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateTasksViewController") as! CreateTasksViewController
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.registerTableView()
        self.title = Constant.Profile.users
    }
    
    @objc func updateUI(){
        self.getUserList()
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
        self.getUserList()
    }
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        viewModel?.getUserList()
    }
    
    func registerTableView() {
        self.taskListTableView.delegate = self
        self.taskListTableView.dataSource = self
        taskListTableView.register(UINib(nibName: "TaskListTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskListTableViewCell")
    }
    
    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getUserList()
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.taskListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension TasksListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredTableData.count
        } else {
            return viewModel?.taskData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TaskListTableViewCell()
        cell = taskListTableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell") as! TaskListTableViewCell
        if isSearch {
            cell.configureCell(userVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(userVM: viewModel, index: indexPath)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createVC = UIStoryboard(name: "CreateTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateTasksViewController") as! CreateTasksViewController
        //detailController.pateintId = viewModel?.userDataAtIndex(index: indexPath.row)?.id ?? 0
        navigationController?.pushViewController(createVC, animated: true)
    }
}

extension TasksListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.taskData.filter { $0.userName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        taskListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        taskListTableView.reloadData()
    }
}
