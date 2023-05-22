//
//  CreateTasksViewController+OepnDropDown.swift
//  Growth99
//
//  Created by Nitin Auti on 07/04/23.
//

import Foundation
import UIKit

extension CreateTasksViewController {
  
    @IBAction func openStatusListDropDwon(sender: UIButton) {
       let rolesArray = ["Completed", "InComplete"]
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.statusTextField.text  = text
         }
        selectionMenu.dismissAutomatically = true
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func openUserListDropDwon(sender: UIButton) {
        let rolesArray = viewModel?.taskUserList ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList.firstName
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.usersTextField.text  = text?.firstName
            self?.workflowTaskUser = text?.id ?? 0
        }
        selectionMenu.dismissAutomatically = true
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func openTaskLeadOrPateintsListDropDwon(sender: UIButton) {
        if leadOrPatientSelected == "Lead" {
            let finaleListArray = viewModel?.taskQuestionnaireSubmissionList ?? []
            let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: finaleListArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
                cell.textLabel?.text = taskUserList.fullName
            }
            selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
                self?.leadTextField.text  = text?.fullName
                self?.questionnaireSubmissionId = text?.id ?? 0
             }
            selectionMenu.dismissAutomatically = true
            selectionMenu.tableView?.selectionStyle = .single
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(finaleListArray.count * 44))), arrowDirection: .down), from: self)
      
        } else {
            let finaleListArray = viewModel?.taskPatientsList ?? []
            let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: finaleListArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
                cell.textLabel?.text = taskUserList.name
            }
            selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
                self?.leadTextField.text  = text?.name
                self?.workflowTaskPatient = text?.id ?? 0
             }
            selectionMenu.dismissAutomatically = true
            selectionMenu.tableView?.selectionStyle = .single
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(finaleListArray.count * 44))), arrowDirection: .down), from: self)
        }
    }
    
}
