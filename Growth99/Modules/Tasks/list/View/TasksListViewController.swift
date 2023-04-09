//
//  TasksListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

protocol TasksListViewControllerProtocol: AnyObject {
    func tasksDataRecived()
    func taskRemovedSuccefully(message: String)
    func errorReceived(error: String)
}

class TasksListViewController: UIViewController {
    
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
        self.addSerchBar()
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
        self.taskListTableView.register(UINib(nibName: "TaskListTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskListTableViewCell")
    }
    
}
extension TasksListViewController: TasksListViewControllerProtocol {
   
    func tasksDataRecived() {
        self.view.HideSpinner()
        self.taskListTableView.setContentOffset(.zero, animated: true)
        self.taskListTableView.reloadData()
    }
  
    func taskRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            if self.screenTitile == "Patient Task" {
                self.view.ShowSpinner()
                self.viewModel?.getPateintTaskList(pateintId: self.workflowTaskPatientId)
            }else if (self.screenTitile == "Lead Task"){
                self.view.ShowSpinner()
                self.viewModel?.getLeadTaskList(LeadId: self.workflowTaskLeadId)
            }else{
                self.view.ShowSpinner()
                self.viewModel?.getTasksList()
            }
        })
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension TasksListViewController: TaskListTableViewCellDelegate {
    
    func editTask(cell: TaskListTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "EditTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "EditTasksViewController") as! EditTasksViewController
        editVC.screenTitile = self.screenTitile
        if isSearch {
            editVC.taskId = viewModel?.taskFilterDataAtIndex(index: index.row)?.id ?? 0
            editVC.workflowTaskPatient = viewModel?.taskDataAtIndex(index: index.row)?.patientId ?? 0
        }else{
            editVC.taskId = viewModel?.taskDataAtIndex(index: index.row)?.id ?? 0
            editVC.workflowTaskPatient = viewModel?.taskDataAtIndex(index: index.row)?.patientId ?? 0
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    func removeTask(cell: TaskListTableViewCell, index: IndexPath) {
        var taskName = String()
        var taskId = Int()

        if isSearch {
            taskName = viewModel?.taskFilterDataAtIndex(index: index.row)?.name ?? ""
            taskId = viewModel?.taskFilterDataAtIndex(index: index.row)?.id ?? 0
        }else{
            taskName = viewModel?.taskDataAtIndex(index: index.row)?.name ?? ""
            taskId = viewModel?.taskDataAtIndex(index: index.row)?.id ?? 0
        }
        
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete \n\(taskName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
           self?.viewModel?.removeTask(taskId: taskId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
