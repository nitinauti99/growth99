//
//  TasksListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 02/03/23.
//

import Foundation
import UIKit

extension TasksListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getTaskFilterData.count ?? 0
        } else {
            return viewModel?.getTaskData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = TaskListTableViewCell()
        cell = taskListTableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell") as! TaskListTableViewCell
        if isSearch {
            cell.configureCellWithSearch(userVM: viewModel, index: indexPath)
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
        editVC.screenTitile = self.screenTitile

        if isSearch {
            editVC.taskId = viewModel?.taskFilterDataAtIndex(index: indexPath.row)?.id ?? 0
            editVC.workflowTaskPatient = viewModel?.taskDataAtIndex(index: indexPath.row)?.patientId ?? 0
        }else{
            editVC.taskId = viewModel?.taskDataAtIndex(index: indexPath.row)?.id ?? 0
            editVC.workflowTaskPatient = viewModel?.taskDataAtIndex(index: indexPath.row)?.patientId ?? 0
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
}
