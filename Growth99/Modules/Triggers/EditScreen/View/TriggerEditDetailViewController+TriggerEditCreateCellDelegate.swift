//
//  TriggerEditDetailViewController+TriggerEditCreateCellDelegate.swift
//  Growth99
//
//  Created by Sravan Goud on 17/07/23.
//

import Foundation
import UIKit

extension TriggerEditDetailViewController: TriggerEditCreateCellDelegate {
    func nextButtonCreate(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, triggerNetworkType: String) {
        if cell.networkTypeSelected == "SMS" {
            if cell.selectSMSTargetTextLabel.text == "Select trigger target" {
                cell.selectSMSTagetEmptyTextLabel.isHidden = false
            } else if cell.selectSMSNetworkTextLabel.text == "Select network" {
                cell.selectSMSNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.createNextButton.isEnabled = false
                cell.selectSMSTagetEmptyTextLabel.isHidden = true
                cell.selectSMSNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton(networkType: triggerNetworkType, triggerTarget: cell.selectSMSTargetTextLabel.text ?? "")
            }
        } else if cell.networkTypeSelected == "EMAIL" {
            if cell.selectEmailTargetTextLabel.text == "Select trigger target" {
                cell.selectEmailTagetEmptyTextLabel.isHidden = false
            } else if cell.selectEmailNetworkTextLabel.text == "Select network" {
                cell.selectEmailNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.createNextButton.isEnabled = false
                cell.selectEmailTagetEmptyTextLabel.isHidden = true
                cell.selectEmailNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton(networkType: triggerNetworkType,  triggerTarget: cell.selectEmailTargetTextLabel.text ?? "")
            }
        } else {
            if cell.taskNameTextField.text == String.blank {
                cell.taskNameTextField.showError(message: "Please enter task name")
            } else if cell.assignTaskNetworkTextLabel.text == "Select network" {
                cell.assignTaskEmptyTextLabel.isHidden = false
            } else {
                isTaskName = cell.taskNameTextField.text ?? ""
                isAssignedToTask = cell.assignTaskNetworkTextLabel.text ?? ""
                cell.createNextButton.isEnabled = false
                cell.assignTaskEmptyTextLabel.isHidden = true
                taskName = cell.taskNameTextField.text ?? ""
                setupNetworkNextButton(networkType: triggerNetworkType, triggerTarget: "leads")
            }
        }
    }
    
    func setupNetworkNextButton(networkType: String, triggerTarget: String) {
        selectedNetworkType = networkType
        selectedTriggerTarget = triggerTarget
        scrollToBottom()
    }
    
    /// set cell drop dwon action
    func smsTargetButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, sender: UIButton) {
        if moduleSelectionType == "leads" {
            smsTargetArray = ["Leads", "Clinic"]
            
        } else {
            smsTargetArray = ["Patient", "Clinic"]
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTargetArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.selectSMSTargetTextLabel.text = "Select trigger target"
                cell.selectSMSNetworkTextLabel.text = "Select network"
                cell.selectSMSTagetEmptyTextLabel.isHidden = false
            } else {
                cell.selectSMSTagetEmptyTextLabel.isHidden = true
                cell.selectSMSNetworkTextLabel.text = "Select network"
                cell.selectSMSTargetTextLabel.text = selectedItem
                self?.smsTargetSelectionType = selectedItem ?? String.blank
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.networkSMSTagetSelectonButton, size: CGSize(width: cell.networkSMSTagetSelectonButton.frame.width, height: (Double(smsTargetArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func smsNetworkButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, smsTargetType: String) {
        if moduleSelectionType == "leads" && smsTargetType == "Leads" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.smsTarget == "Lead"}) ?? []
        } else if moduleSelectionType == "leads" && smsTargetType == "Clinic" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.smsTarget == "Clinic"}) ?? []
        } else if moduleSelectionType == "Appointment" && smsTargetType == "Patient" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.smsTarget == "Patient"}) ?? []
        } else if moduleSelectionType == "Appointment" && smsTargetType == "Clinic" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.smsTarget == "Clinic"}) ?? []
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.selectSMSNetworkTextLabel.text = "Select network"
                cell.selectSMSNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectSMSNetworkEmptyTextLabel.isHidden = true
                cell.selectSMSNetworkTextLabel.text = selectedItem?.name
                self?.selectedSmsTemplates = selectedList
                self?.selectedSmsTemplateId = String(selectedItem?.id ?? 0)
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.networkSMSNetworkSelectonButton, size: CGSize(width: cell.networkSMSNetworkSelectonButton.frame.width, height: (Double(smsTemplatesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func emailTargetButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath) {
        if moduleSelectionType == "leads" {
            emailTargetArray = ["Leads", "Clinic"]
        } else {
            emailTargetArray = ["Patient", "Clinic"]
        }
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTargetArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.selectEmailTargetTextLabel.text = "Select trigger target"
                cell.selectEmailTagetEmptyTextLabel.isHidden = false
                cell.selectEmailNetworkTextLabel.text = "Select network"
            } else {
                cell.selectEmailTagetEmptyTextLabel.isHidden = true
                cell.selectEmailNetworkTextLabel.text = "Select network"
                cell.selectEmailTargetTextLabel.text = selectedItem
                self?.emailTargetSelectionType = selectedItem ?? String.blank
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.networkEmailTagetSelectonButton, size: CGSize(width: cell.networkEmailTagetSelectonButton.frame.width, height: (Double(emailTargetArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func emailNetworkButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, emailTargetType: String) {
        if moduleSelectionType == "leads" && emailTargetType == "Leads" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.emailTarget == "Lead"}) ?? []
        } else if moduleSelectionType == "leads" && emailTargetType == "Clinic" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.emailTarget == "Clinic"}) ?? []
        } else if moduleSelectionType == "Appointment" && emailTargetType == "Patient" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.emailTarget == "Patient"}) ?? []
        } else if moduleSelectionType == "Appointment" && emailTargetType == "Clinic" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.emailTarget == "Clinic"}) ?? []
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.selectEmailNetworkTextLabel.text = "Select network"
                cell.selectEmailNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectEmailNetworkEmptyTextLabel.isHidden = true
                cell.selectEmailNetworkTextLabel.text = selectedItem?.name
                self?.selectedEmailTemplates = selectedList
                self?.selectedemailTemplateId = String(selectedItem?.id ?? 0)
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.networkEmailNetworkSelectonButton, size: CGSize(width: cell.networkEmailNetworkSelectonButton.frame.width, height: (Double(emailTemplatesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func taskNetworkNetworkButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath) {
        taskUserListArray = viewModel?.getTriggerDetailDataEdit?.userDTOList ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: taskUserListArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = "\(allClinics.firstName ?? "") \(allClinics.lastName ?? "")"
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.assignTaskNetworkTextLabel.text = "Select network"
                cell.assignTaskEmptyTextLabel.isHidden = false
            } else {
                cell.assignTaskEmptyTextLabel.isHidden = true
                self?.selectedTaskTemplate = selectedItem?.id ?? 0
                self?.isAssignedToTask = "\(selectedItem?.firstName ?? "") \(selectedItem?.lastName ?? "")"
                cell.assignTaskNetworkTextLabel.text = "\(selectedItem?.firstName ?? "") \(selectedItem?.lastName ?? "")"
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.assignTaskNetworkSelectonButton, size: CGSize(width: cell.assignTaskNetworkSelectonButton.frame.width, height: (Double(taskUserListArray.count * 30))), arrowDirection: .up), from: self)
    }
}
