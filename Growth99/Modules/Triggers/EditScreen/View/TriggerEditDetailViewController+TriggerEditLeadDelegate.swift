//
//  TriggerEditDetailViewController+TriggerEditLeadDelegate.swift
//  Growth99
//
//  Created by Sravan Goud on 17/07/23.
//

import Foundation
import UIKit

extension TriggerEditDetailViewController: TriggerLeadEdiTableViewCellDelegate {
    func nextButtonLead(cell: TriggerLeadEditActionTableViewCell, index: IndexPath) {
        if cell.leadFromTextField.text == "" {
            cell.leadFromTextField.showError(message: "Please select source")
        } else if isSelectLandingSelected == true && cell.leadSelectLandingTextField.text == "" {
            cell.leadSelectLandingTextField.showError(message: "Please select landing page")
        } else if isSelectFormsSelected == true && cell.leadLandingSelectFromTextField.text == "" {
            cell.leadLandingSelectFromTextField.showError(message: "Please select form")
        } else if isLeadStatusChangeSelected == true && isInitialStatusSelected == true && cell.leadInitialStatusTextField.text == "" {
            cell.leadInitialStatusTextField.showError(message: "Please select initial status")
        } else if isLeadStatusChangeSelected == true && isFinalStatusSelected == true && cell.leadFinalStatusTextField.text == "" {
            cell.leadFinalStatusTextField.showError(message: "Please select final status")
        } else {
            if triggerDetailList.count < 4 {
                createNewTriggerCell(cellNameType: "Both")
                scrollToBottom()
            }
        }
    }
    
    func leadFormButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: cell.selectedLeadSources) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.leadFromTextField.showError(message: "Please select source")
                cell.leadFromTextField.text = ""
                self?.isSelectLandingSelected = false
                self?.isSelectFormsSelected = false
                cell.selectedLeadLandingPages.removeAll()
                cell.selectedleadForms.removeAll()
                cell.selectedLeadSourceUrl.removeAll()
                cell.selectedLeadSources.removeAll()
                cell.showLeadSelectLanding(isShown: false)
                cell.showleadLandingSelectFrom(isShown: false)
                cell.showleadSelectSource(isShown: false)
                
            } else {
                cell.leadFromTextField.text = selectedList.joined(separator: ",")
                cell.selectedLeadSources = selectedList
                if selectedList.joined(separator: ",").contains("Landing Page") &&
                    selectedList.joined(separator: ",").contains("Form") &&
                    selectedList.joined(separator: ",").contains("Facebook") {
                    self?.isSelectLandingSelected = true
                    self?.isSelectFormsSelected = true
                    cell.showLeadSelectLanding(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: true)
                    cell.showleadSelectSource(isShown: true)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Landing Page") &&
                            selectedList.joined(separator: ",").contains("Form"){
                    self?.isSelectLandingSelected = true
                    self?.isSelectFormsSelected = true
                    cell.selectedLeadSourceUrl.removeAll()
                    cell.showLeadSelectLanding(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: true)
                    cell.showleadSelectSource(isShown: false)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Landing Page") &&
                            selectedList.joined(separator: ",").contains("Facebook") {
                    self?.isSelectLandingSelected = true
                    self?.isSelectFormsSelected = false
                    cell.selectedleadForms.removeAll()
                    cell.showLeadSelectLanding(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: false)
                    cell.showleadSelectSource(isShown: true)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Form") &&
                            selectedList.joined(separator: ",").contains("Facebook") {
                    self?.isSelectLandingSelected = false
                    self?.isSelectFormsSelected = true
                    cell.selectedLeadLandingPages.removeAll()
                    cell.showLeadSelectLanding(isShown: false)
                    cell.showleadSelectSource(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: true)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Landing Page") {
                    self?.isSelectLandingSelected = true
                    self?.isSelectFormsSelected = false
                    cell.selectedleadForms.removeAll()
                    cell.selectedLeadSourceUrl.removeAll()
                    cell.showLeadSelectLanding(isShown: true)
                    cell.showleadSelectSource(isShown: false)
                    cell.showleadLandingSelectFrom(isShown: false)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Form") {
                    self?.isSelectLandingSelected = false
                    self?.isSelectFormsSelected = true
                    cell.selectedLeadLandingPages.removeAll()
                    cell.selectedLeadSourceUrl.removeAll()
                    cell.showLeadSelectLanding(isShown: false)
                    cell.showleadSelectSource(isShown: false)
                    cell.showleadLandingSelectFrom(isShown: true)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Facebook") {
                    self?.isSelectLandingSelected = false
                    self?.isSelectFormsSelected = false
                    cell.selectedLeadLandingPages.removeAll()
                    cell.selectedleadForms.removeAll()
                    cell.showLeadSelectLanding(isShown: false)
                    cell.showleadSelectSource(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: false)
                    self?.scrollToBottom()
                } else {
                    self?.isSelectLandingSelected = false
                    self?.isSelectFormsSelected = false
                    cell.selectedLeadLandingPages.removeAll()
                    cell.selectedleadForms.removeAll()
                    cell.selectedLeadSourceUrl.removeAll()
                    cell.showLeadSelectLanding(isShown: false)
                    cell.showleadSelectSource(isShown: false)
                    cell.showleadLandingSelectFrom(isShown: false)
                    self?.scrollToBottom()
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadSourceArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadLandingButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        leadLandingPagesArray = viewModel?.getLandingPageNamesDataEdit ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadLandingPagesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: cell.selectedLeadLandingPages) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.selectedLeadLandingPages.removeAll()
                cell.leadSelectLandingTextField.text = ""
                cell.leadSelectLandingTextField.showError(message: "Please select landing page")
            } else {
                cell.selectedLeadLandingPages = selectedList
                cell.leadSelectLandingTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ",")
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadLandingPagesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadSelectFormsButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        leadFormsArray = viewModel?.getTriggerQuestionnairesDataEdit ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadFormsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: cell.selectedleadForms) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.selectedleadForms = selectedList
            cell.leadLandingSelectFromTextField.text =  selectedList.map({$0.name ?? String.blank}).joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadFormsArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadSourceButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        leadSourceUrlArray = viewModel?.getTriggerLeadSourceUrlDataEdit ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceUrlArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.sourceUrl
        }
        selectionMenu.setSelectedItems(items: cell.selectedLeadSourceUrl) { [weak self] (selectedItem, index, selected, selectedList) in
            guard let self = self else { return }
            cell.selectedLeadSourceUrl = selectedList
            cell.leadSelectSourceTextField.text = selectedList.map({$0.sourceUrl ?? String.blank}).joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadSourceUrlArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadInitialStatusButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let leadStatusArray = ["NEW","COLD","WARM","HOT","WON","DEAD"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        
        selectionMenu.setSelectedItems(items: []) { (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.leadInitialStatusTextField.text = ""
                cell.leadInitialStatusTextField.showError(message: "Please select initial status")
            } else {
                cell.leadInitialStatusTextField.text = selectedItem
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadStatusArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    func leadFinalStatusButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let leadStatusArray = ["NEW","COLD","WARM","HOT","WON","DEAD"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.leadFinalStatusTextField.text = ""
                cell.leadFinalStatusTextField.showError(message: "Please select final status")
            } else {
                cell.leadFinalStatusTextField.text = selectedItem
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadStatusArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    func leadTagButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        leadTagsTriggerArrayEdit = viewModel?.getTriggerLeadTagListDataEdit ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadTagsTriggerArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: cell.selectedLeadTags) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.leadTagTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            cell.selectedLeadTags = selectedList
            let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
            self?.selectedLeadTagIds = formattedArray
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadTagsTriggerArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    func showLeadTagButtonClicked(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        if buttonSender.isSelected {
            buttonSender.isSelected = false
            cell.leadTagTextFieldHight.constant = 0
            cell.leadTagTextField.rightImage = nil
            cell.leadTagTextField.text = ""
            cell.selectedLeadTags.removeAll()
        } else {
            buttonSender.isSelected = true
            cell.leadTagTextFieldHight.constant = 45
            cell.leadTagTextField.rightImage = UIImage(named: "dropDown")
        }
        self.triggerdDetailTableView?.performBatchUpdates(nil, completion: nil)
        self.scrollToBottom()
    }
}
