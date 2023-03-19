//
//  TasksListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

protocol TasksListViewControllerProtocol: AnyObject {
    func tasksDataRecived()
    func errorReceived(error: String)
}

class TasksListViewController: UIViewController, TasksListViewControllerProtocol {
    
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: TasksListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [TaskDTOList]()
    var workflowTaskPatientId = Int()
    var workflowTaskLeadId = Int()
    var screenTitile = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableView()
        self.viewModel = TasksListViewModel(delegate: self)
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addUserButtonTapped), imageName: "add")
    }
    
    @objc func addUserButtonTapped(_ sender: UIButton) {
        if screenTitile == "Patient Task" {
            let createPateintsTasksVC = UIStoryboard(name: "CreatePateintsTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatePateintsTasksViewController") as! CreatePateintsTasksViewController
            createPateintsTasksVC.workflowTaskPatient = workflowTaskPatientId
            navigationController?.pushViewController(createPateintsTasksVC, animated: true)
        }else{
            let createVC = UIStoryboard(name: "CreateTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateTasksViewController") as! CreateTasksViewController
            navigationController?.pushViewController(createVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.tasks
        if screenTitile == "Patient Task" {
            self.view.ShowSpinner()
            viewModel?.getPateintTaskList(pateintId: workflowTaskPatientId)
        }else if (screenTitile == "Lead Task"){
            self.view.ShowSpinner()
            viewModel?.getLeadTaskList(LeadId: workflowTaskLeadId)
        }else{
            self.view.ShowSpinner()
            viewModel?.getTasksList()
        }
        addSerchBar()
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func registerTableView() {
        self.taskListTableView.delegate = self
        self.taskListTableView.dataSource = self
        taskListTableView.register(UINib(nibName: "TaskListTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskListTableViewCell")
    }
    
    func tasksDataRecived() {
        self.view.HideSpinner()
        self.taskListTableView.setContentOffset(.zero, animated: true)
        self.taskListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
