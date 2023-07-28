//
//  TriggerEditDetailViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation
import UIKit

extension TriggerEditDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return triggerDetailList.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BottomTableViewCell") as? BottomTableViewCell else {
            return UIView()
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if triggerDetailList[indexPath.row].cellType == "Default" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditDefaultTableViewCell", for: indexPath) as? TriggerEditDefaultTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            let modelData = viewModel?.getTriggerEditListData
            cell.configureCell(triggerListEdit: modelData, index: indexPath)
            return cell
        }
        else if triggerDetailList[indexPath.row].cellType == "Module" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditModuleTableViewCell", for: indexPath) as? TriggerEditModuleTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configureCell(triggerListEdit: viewModel?.getTriggerEditListData, index: indexPath)
            moduleSelectionType = cell.moduleTypeSelected
            return cell
        }
        else if triggerDetailList[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerLeadEditActionTableViewCell", for: indexPath) as? TriggerLeadEditActionTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configureCell(tableView: triggerdDetailTableView, index: indexPath, triggerListEdit: viewModel?.getTriggerEditListData, viewModel: viewModel, viewController: self)
            return cell
        }
        else if triggerDetailList[indexPath.row].cellType == "Appointment" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditAppointmentActionTableViewCell", for: indexPath) as? TriggerEditAppointmentActionTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configureCell(tableView: triggerdDetailTableView, index: indexPath, triggerListEdit: viewModel?.getTriggerEditListData, viewModel: viewModel, viewController: self)
            return cell
        }
        else if triggerDetailList[indexPath.row].cellType == "Create" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditSMSCreateTableViewCell", for: indexPath) as? TriggerEditSMSCreateTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            if isAddanotherClicked == false {
                var createDataIndex = -1
                for i in 0..<triggerDetailList.count {
                    if triggerDetailList[i].cellType == "Create" {
                        createDataIndex += 1 // Increment the index for each "Create" cell found
                    }
                    if i == indexPath.row {
                        break // Stop when we reach the current row
                    }
                }
                
                // Check if createDataIndex is within valid range
                if createDataIndex >= 0, let triggerData = viewModel?.getTriggerEditListData?.triggerData?[createDataIndex] {
                    cell.configureCell(index: indexPath, triggerEditData: triggerData, parentViewModel: viewModel, viewController: self, moduleSelectionTypeTrigger: moduleSelectionType)
                    manageBorder = false
                }
            } else {
                cell.configureCellCreate(index: indexPath, moduleSelectionTypeTrigger: moduleSelectionType)
                manageBorder = true
            }
            return cell
        }
        else if triggerDetailList[indexPath.row].cellType == "Time" {
            // Display "Time" cell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditTimeTableViewCell", for: indexPath) as? TriggerEditTimeTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            if isAddanotherTimeClicked == false {
                // Calculate the triggerDataIndex for "Time" cell
                var timeDataIndex = -1
                for i in 0..<triggerDetailList.count {
                    if triggerDetailList[i].cellType == "Time" {
                        timeDataIndex += 1 // Increment the index for each "Time" cell found
                    }
                    if i == indexPath.row {
                        break // Stop when we reach the current row
                    }
                }
                
                // Check if timeDataIndex is within valid range
                if timeDataIndex >= 0, let triggerData = viewModel?.getTriggerEditListData?.triggerData?[timeDataIndex] {
                    cell.configureCell(tableView: triggerdDetailTableView, index: indexPath, triggerEditData: triggerData, parentViewModel: viewModel, viewController: self, moduleSelectionTypeTrigger: moduleSelectionType, arrayCount: triggerDetailList.count)
                }
            } else {
                cell.configureCellTime(index: indexPath, moduleSelectionTypeTrigger: moduleSelectionType, arrayCount: triggerDetailList.count)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func createTriggerInfo(triggerCreateData: [String: Any]) {
        smsandTimeArray.append(triggerCreateData)
    }
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.triggerDetailList.count-1, section: 0)
            self.triggerdDetailTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
