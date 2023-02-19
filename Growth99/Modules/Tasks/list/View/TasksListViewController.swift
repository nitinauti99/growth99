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
    var workflowTaskPatient = Int()
    var fromPateint = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TasksListViewModel(delegate: self)
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        if fromPateint == true {
            let createPateintsTasksVC = UIStoryboard(name: "CreatePateintsTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintsTasksViewController") as! CreatePateintsTasksViewController
            createPateintsTasksVC.workflowTaskPatient = workflowTaskPatient
             navigationController?.pushViewController(createPateintsTasksVC, animated: true)
        }else{
            let createVC = UIStoryboard(name: "CreateTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateTasksViewController") as! CreateTasksViewController
            navigationController?.pushViewController(createVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fromPateint == true {
            self.view.ShowSpinner()
            viewModel?.getPateintTaskList(pateintId: workflowTaskPatient)
        }else{
            self.getTaskList()
        }
        addSerchBar()
        self.registerTableView()
        self.title = Constant.Profile.tasks
    }
    
    @objc func updateUI(){
        self.getTaskList()
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
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getTaskList()
    }
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        viewModel?.getTaskList()
    }
    
    func registerTableView() {
        self.taskListTableView.delegate = self
        self.taskListTableView.dataSource = self
        taskListTableView.register(UINib(nibName: "TaskListTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskListTableViewCell")
    }
    
    @objc func getTaskList(){
        self.view.ShowSpinner()
        viewModel?.getTaskList()
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.taskListTableView.setContentOffset(.zero, animated: true)
        self.taskListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
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
        let editVC = UIStoryboard(name: "EditTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "EditTasksViewController") as! EditTasksViewController
        editVC.taskId = viewModel?.taskDataAtIndex(index: indexPath.row)?.id ?? 0
        editVC.workflowTaskPatient = viewModel?.taskDataAtIndex(index: indexPath.row)?.patientId ?? 0
        navigationController?.pushViewController(editVC, animated: true)
    }
}

extension TasksListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.taskData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        taskListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        taskListTableView.reloadData()
    }
}
