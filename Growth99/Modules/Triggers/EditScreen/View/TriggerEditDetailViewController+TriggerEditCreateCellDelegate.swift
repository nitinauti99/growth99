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
            if cell.smsTargetTF.text == "" {
                cell.smsTargetTF.showError(message: "Select trigger target")
            } else if cell.smsNetworTF.text == "" {
                cell.smsNetworTF.showError(message: "Select network")
            } else {
                cell.createNextButton.isEnabled = false
                setupNetworkNextButton(networkType: triggerNetworkType, triggerTarget: cell.smsTargetTF.text ?? "")
            }
        } else if cell.networkTypeSelected == "EMAIL" {
            if cell.emailTargetTF.text == "" {
                cell.emailTargetTF.showError(message: "Select trigger target")
            } else if cell.emailNetworTF.text == "" {
                cell.emailNetworTF.showError(message: "Select network")
            } else {
                cell.createNextButton.isEnabled = false
                setupNetworkNextButton(networkType: triggerNetworkType,  triggerTarget: cell.emailTargetTF.text ?? "")
            }
        } else {
            if cell.taskNameTextField.text == "" {
                cell.taskNameTextField.showError(message: "Please enter task name")
            } else if cell.assignTaskNetworkTF.text == "" {
                cell.assignTaskNetworkTF.showError(message: "Select network")
            } else {
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
            cell.smsTargetTF.text = selectedItem
            self?.smsTargetSelectionType = selectedItem ?? String.blank
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
            cell.smsNetworTF.text = selectedItem?.name
            self?.selectedSmsTemplates = selectedList
            self?.selectedSmsTemplateId = String(selectedItem?.id ?? 0)
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
            cell.emailTargetTF.text = selectedItem
            self?.emailTargetSelectionType = selectedItem ?? String.blank
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.emailTagetSelectonButton, size: CGSize(width: cell.emailTagetSelectonButton.frame.width, height: (Double(emailTargetArray.count * 30))), arrowDirection: .up), from: self)
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
            self?.selectedEmailTemplates = selectedList
            self?.selectedemailTemplateId = String(selectedItem?.id ?? 0)
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.emailNetworkSelectonButton, size: CGSize(width: cell.emailTagetSelectonButton.frame.width, height: (Double(emailTemplatesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func taskNetworkNetworkButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath) {
        taskUserListArray = viewModel?.getTriggerDetailDataEdit?.userDTOList ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: taskUserListArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = "\(allClinics.firstName ?? "") \(allClinics.lastName ?? "")"
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.selectedTaskTemplate = selectedItem?.id ?? 0
            self?.isAssignedToTask = "\(selectedItem?.firstName ?? "") \(selectedItem?.lastName ?? "")"
            cell.assignTaskNetworkTF.text = "\(selectedItem?.firstName ?? "") \(selectedItem?.lastName ?? "")"
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.assignTaskNetworkSelectonButton, size: CGSize(width: cell.assignTaskNetworkSelectonButton.frame.width, height: (Double(taskUserListArray.count * 30))), arrowDirection: .up), from: self)
    }
}
