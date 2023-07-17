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
        let cell = UITableViewCell()
        if triggerDetailList[indexPath.row].cellType == "Default" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditDefaultTableViewCell", for: indexPath) as? TriggerEditDefaultTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            let modelData = viewModel?.getTriggerEditListData
            cell.configureCell(triggerListEdit: modelData, index: indexPath)
            return cell
        }
        else if triggerDetailList[indexPath.row].cellType == "Module" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditModuleTableViewCell", for: indexPath) as? TriggerEditModuleTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.configureCell(triggerListEdit: viewModel?.getTriggerEditListData, index: indexPath)
            moduleSelectionType = cell.moduleTypeSelected
            return cell
        }
        else if triggerDetailList[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerLeadEditActionTableViewCell", for: indexPath) as? TriggerLeadEditActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.configureCell(tableView: triggerdDetailTableView, index: indexPath, triggerListEdit: viewModel?.getTriggerEditListData, viewModel: viewModel, viewController: self)
            return cell
        }
        else if triggerDetailList[indexPath.row].cellType == "Appointment" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerEditAppointmentActionTableViewCell", for: indexPath) as? TriggerEditAppointmentActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.configureCell(tableView: triggerdDetailTableView, index: indexPath, triggerListEdit: viewModel?.getTriggerEditListData, viewModel: viewModel, viewController: self)
            return cell
        }
        else if triggerDetailList[indexPath.row].cellType == "Both" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerParentCreateTableViewCell", for: indexPath) as? TriggerParentCreateTableViewCell else { return UITableViewCell()}
            for item in viewModel?.getTriggerEditListData?.triggerData ?? [] {
                let creatChild = TriggerEditData(id: item.id, timerType: item.timerType, triggerTarget: item.triggerTarget, triggerFrequency: item.triggerFrequency, actionIndex: item.actionIndex, dateType: item.dateType, triggerTime: item.triggerTime, showBorder: item.showBorder, userId: item.userId, scheduledDateTime: item.scheduledDateTime, triggerTemplate: item.triggerTemplate, addNew: item.addNew, endTime: item.endTime, triggerType: item.triggerType, taskName: item.taskName, startTime: item.endTime, orderOfCondition: item.orderOfCondition, type: "Create")
                
                let createTimechild = TriggerEditData(id: item.id, timerType: item.timerType, triggerTarget: item.triggerTarget, triggerFrequency: item.triggerFrequency, actionIndex: item.actionIndex, dateType: item.dateType, triggerTime: item.triggerTime, showBorder: item.showBorder, userId: item.userId, scheduledDateTime: item.scheduledDateTime, triggerTemplate: item.triggerTemplate, addNew: item.addNew, endTime: item.endTime, triggerType: item.triggerType, taskName: item.taskName, startTime: item.startTime, orderOfCondition: item.orderOfCondition, type: "Time")
                finalArray.append(creatChild)
                finalArray.append(createTimechild)
                isTaskName = item.taskName ?? ""
                selectedNetworkType = item.triggerType ?? ""
                selectedSmsTemplateId = String(item.triggerTemplate ?? 0)
                selectedemailTemplateId = String(item.triggerTemplate ?? 0)
                selectedTriggerTarget = item.triggerTarget ?? ""
            }
            cell.configureCell(triggerEditData: finalArray, index: indexPath, moduleSelectionTypeTrigger: moduleSelectionType, selectedNetworkType: selectedNetworkType, parentViewModel: viewModel, viewController: self)
            return cell
        }
        
        return cell
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
