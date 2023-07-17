//
//  TriggerEditDetailViewController+TriggerEditTimeCellDelegate.swift
//  Growth99
//
//  Created by Sravan Goud on 17/07/23.
//

import Foundation
import UIKit

extension TriggerEditDetailViewController: TriggerEditTimeCellDelegate {
    func hourlyNetworkButton(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
        let timeHourlyArray = ["Min", "Hour", "Day"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: timeHourlyArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.timeHourlyTextField.showError(message: "Please enter time duration")
            } else {
                cell.timeHourlyTextField.text = selectedItem
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.timeHourlyButton, size: CGSize(width:  cell.timeHourlyButton.frame.width, height: (Double(timeHourlyArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func scheduledBasedOnButton(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
        let scheduledBasedOnArray = ["Appointment Created Date", "Before Appointment Date", "After Appointment Date"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: scheduledBasedOnArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { (selectedItem, index, selected, selectedList) in
            cell.scheduledBasedOnTextField.text = selectedItem
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.scheduledBasedOnButton, size: CGSize(width: cell.scheduledBasedOnButton.frame.width, height: (Double(scheduledBasedOnArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func addAnotherConditionButton(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
        if triggerDetailList.count == 4 {
            orderOfConditionTrigger = orderOfConditionTrigger + 2
        } else {
            orderOfConditionTrigger = orderOfConditionTrigger + 1
        }
        if moduleSelectionType == "leads" {
            if cell.timerTypeSelected == "Frequency" {
                if cell.timeDurationTextField.text == "" {
                    cell.timeDurationTextField.showError(message: "Please enter time duration")
                } else if cell.timeHourlyTextField.text == "" {
                    cell.timeHourlyTextField.showError(message: "Please select duration")
                } else {
                    scrollToBottom()
                    let creatChild = TriggerEditData(id: "", timerType: "", triggerTarget: "", triggerFrequency: "", actionIndex: 0, dateType: "", triggerTime: 0, showBorder: false, userId: "", scheduledDateTime: "", triggerTemplate: 0, addNew: false, endTime: "", triggerType: "", taskName: "", startTime: "", orderOfCondition: 0, type: "Create")
                    let createTimechild =  TriggerEditData(id: "", timerType: "", triggerTarget: "", triggerFrequency: "", actionIndex: 0, dateType: "", triggerTime: 0, showBorder: false, userId: "", scheduledDateTime: "", triggerTemplate: 0, addNew: false, endTime: "", triggerType: "", taskName: "", startTime: "", orderOfCondition: 0, type: "Time")
                    cell.parentCell?.finalArray.append(creatChild)
                    cell.parentCell?.finalArray.append(createTimechild)
                    cell.parentCell?.parentTableView.reloadData()
                }
            } else {
                if cell.timeRangeStartTimeTF.text == "" {
                    cell.timeRangeStartTimeTF.showError(message: "Please enter start time")
                } else if cell.timeRangeEndTimeTF.text == "" {
                    cell.timeRangeEndTimeTF.showError(message: "Please select end time")
                } else {
                    scrollToBottom()
                    let creatChild = TriggerEditData(id: "", timerType: "", triggerTarget: "", triggerFrequency: "", actionIndex: 0, dateType: "", triggerTime: 0, showBorder: false, userId: "", scheduledDateTime: "", triggerTemplate: 0, addNew: false, endTime: "", triggerType: "", taskName: "", startTime: "", orderOfCondition: 0, type: "Create")
                    let createTimechild =  TriggerEditData(id: "", timerType: "", triggerTarget: "", triggerFrequency: "", actionIndex: 0, dateType: "", triggerTime: 0, showBorder: false, userId: "", scheduledDateTime: "", triggerTemplate: 0, addNew: false, endTime: "", triggerType: "", taskName: "", startTime: "", orderOfCondition: 0, type: "Time")
                    cell.parentCell?.finalArray.append(creatChild)
                    cell.parentCell?.finalArray.append(createTimechild)
                    cell.parentCell?.parentTableView.reloadData()
                }
            }
            
        } else {
            if cell.timeDurationTextField.text == "" {
                cell.timeDurationTextField.showError(message: "Please enter time duration")
            } else if cell.timeHourlyTextField.text == "" {
                cell.timeHourlyTextField.showError(message: "Please select duration")
            } else if cell.scheduledBasedOnTextField.text == "" {
                cell.timeHourlyTextField.showError(message: "Please select scheduled")
            } else {
                scrollToBottom()
                let creatChild = TriggerEditData(id: "", timerType: "", triggerTarget: "", triggerFrequency: "", actionIndex: 0, dateType: "", triggerTime: 0, showBorder: false, userId: "", scheduledDateTime: "", triggerTemplate: 0, addNew: false, endTime: "", triggerType: "", taskName: "", startTime: "", orderOfCondition: 0, type: "Create")
                let createTimechild =  TriggerEditData(id: "", timerType: "", triggerTarget: "", triggerFrequency: "", actionIndex: 0, dateType: "", triggerTime: 0, showBorder: false, userId: "", scheduledDateTime: "", triggerTemplate: 0, addNew: false, endTime: "", triggerType: "", taskName: "", startTime: "", orderOfCondition: 0, type: "Time")
                cell.parentCell?.finalArray.append(creatChild)
                cell.parentCell?.finalArray.append(createTimechild)
                cell.parentCell?.parentTableView.reloadData()
                cell.parentCell?.parentTableViewHight.constant =  CGFloat((cell.parentCell?.finalArray.count ?? 0) * 500)
            }
        }
    }
    
    func nextBtnAction(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
        if moduleSelectionType == "leads" {
            if cell.timerTypeSelected == "Frequency" {
                if cell.timeDurationTextField.text == "" {
                    cell.timeDurationTextField.showError(message: "Please enter time duration")
                } else if cell.timeHourlyTextField.text == "" {
                    cell.timeHourlyTextField.showError(message: "Please select duration")
                } else {
                    selectedTriggerTime = Int(cell.timeDurationTextField.text ?? "0") ?? 0
                    selectedTriggerFrequency = cell.timeHourlyTextField.text ?? ""
                    timerTypeSelected = cell.timerTypeSelected
                    submitBtn.backgroundColor = UIColor(hexString: "#009EDE")
                    submitBtn.isEnabled = true
                }
            } else {
                if cell.timeRangeStartTimeTF.text == "" {
                    cell.timeRangeStartTimeTF.showError(message: "Please select start time")
                } else if cell.timeRangeEndTimeTF.text == "" {
                    cell.timeRangeEndTimeTF.showError(message: "Please select end time")
                } else {
                    selectedStartTime = cell.timeRangeStartTimeTF.text ?? ""
                    selectedEndTime = cell.timeRangeEndTimeTF.text ?? ""
                    selectedTriggerTime = Int(cell.timeDurationTextField.text ?? "0") ?? 0
                    selectedTriggerFrequency = cell.timeHourlyTextField.text ?? ""
                    timerTypeSelected = cell.timerTypeSelected
                    submitBtn.backgroundColor = UIColor(hexString: "#009EDE")
                    submitBtn.isEnabled = true
                }
            }
        } else {
            if cell.timeDurationTextField.text == "" {
                cell.timeDurationTextField.showError(message: "Please enter time duration")
            } else if cell.timeHourlyTextField.text == "" {
                cell.timeHourlyTextField.showError(message: "Please select duration")
            } else if cell.scheduledBasedOnTextField.text == "" {
                cell.timeHourlyTextField.showError(message: "Please select scheduled")
            } else {
                if cell.scheduledBasedOnTextField.text == "Appointment Created Date" {
                    scheduledBasedOnSelected = "APPOINTMENT_CREATED"
                } else if cell.scheduledBasedOnTextField.text == "Before Appointment Date" {
                    scheduledBasedOnSelected = "APPOINTMENT_BEFORE"
                } else {
                    scheduledBasedOnSelected = "APPOINTMENT_AFTER"
                }
                selectedTriggerTime = Int(cell.timeDurationTextField.text ?? "0") ?? 0
                selectedTriggerFrequency = cell.timeHourlyTextField.text ?? ""
                timerTypeSelected = cell.timerTypeSelected
                submitBtn.backgroundColor = UIColor(hexString: "#009EDE")
                submitBtn.isEnabled = true
            }
        }
    }
    
    func buttontimeRangeStartTapped(cell: TriggerEditTimeTableViewCell) {
        cell.updateTimeRangeStartTextField(with: self.viewModel?.timeFormatterStringEdit(textField: cell.timeRangeStartTimeTF) ?? String.blank)
    }
    
    func buttontimeRangeEndTapped(cell: TriggerEditTimeTableViewCell) {
        cell.updateTimeRangeEndTextField(with: self.viewModel?.timeFormatterStringEdit(textField: cell.timeRangeEndTimeTF) ?? String.blank)
    }
}
