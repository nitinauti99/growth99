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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if triggerDetailList[indexPath.row].cellType == "Default" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerDefaultTableViewCell", for: indexPath) as? TriggerDefaultTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.massEmailSMSTextField.text = viewModel?.getTriggerEditListData?.name ?? ""
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Module" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerModuleTableViewCell", for: indexPath) as? TriggerModuleTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            moduleSelectionType = cell.moduleTypeSelected
            if viewModel?.getTriggerEditListData?.moduleName == "leads" {
                cell.leadBtn.isSelected = true
                cell.patientBtn.isSelected = false
            } else {
                cell.leadBtn.isSelected = false
                cell.patientBtn.isSelected = true
            }
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerLeadActionTableViewCell", for: indexPath) as? TriggerLeadActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.leadStatusSelectonButton.addTarget(self, action: #selector(leadSouceMethod), for: .touchDown)
            cell.leadStatusSelectonButton.tag = indexPath.row
            cell.leadLandingSelectonButton.addTarget(self, action: #selector(leadLandingMethod), for: .touchDown)
            cell.leadLandingSelectonButton.tag = indexPath.row
            cell.leadFormSelectonButton.addTarget(self, action: #selector(leadFormMethod), for: .touchDown)
            cell.leadFormSelectonButton.tag = indexPath.row
            cell.leadSourceUrlSelectonButton.addTarget(self, action: #selector(leadSourceUrlMethod), for: .touchDown)
            cell.leadSourceUrlSelectonButton.tag = indexPath.row
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Appointment" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerAppointmentActionTableViewCell", for: indexPath) as? TriggerAppointmentActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.patientAppointmentButton.addTarget(self, action: #selector(patientAppointmentMethod), for: .touchDown)
            cell.patientAppointmentButton.tag = indexPath.row
            cell.patientAppointmenTextLabel.text = appointmentStatusArray[0]
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Both" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerSMSCreateTableViewCell", for: indexPath) as? TriggerSMSCreateTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.networkSMSTagetSelectonButton.tag = indexPath.row
            cell.networkSMSTagetSelectonButton.addTarget(self, action: #selector(smsTargetSelectionMethod), for: .touchDown)
            cell.networkSMSNetworkSelectonButton.tag = indexPath.row
            cell.networkSMSNetworkSelectonButton.addTarget(self, action: #selector(smsNetworkSelectionMethod), for: .touchDown)
            
            cell.networkEmailTagetSelectonButton.tag = indexPath.row
            cell.networkEmailTagetSelectonButton.addTarget(self, action: #selector(emailTargetSelectionMethod), for: .touchDown)
            cell.networkEmailNetworkSelectonButton.tag = indexPath.row
            cell.networkEmailNetworkSelectonButton.addTarget(self, action: #selector(emailNetworkSelectionMethod), for: .touchDown)
            
            if moduleSelectionType == "lead" {
                cell.taskBtn.isHidden = false
                cell.taskLabel.isHidden = false
                cell.assignTaskNetworkSelectonButton.tag = indexPath.row
                cell.assignTaskNetworkSelectonButton.addTarget(self, action: #selector(taskNetworkSelectionMethod), for: .touchDown)
            } else {
                cell.taskBtn.isHidden = true
                cell.taskLabel.isHidden = true
            }
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Time" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerTimeTableViewCell", for: indexPath) as? TriggerTimeTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            if moduleSelectionType == "lead" {
                cell.timeRangeView.isHidden = false
                cell.timeFrequencyLbl.isHidden = false
                cell.timeRangeLbl.isHidden = false
                cell.scheduledBasedOnTextField.isHidden = true
                cell.scheduleBasedonLbl.isHidden = true
                cell.timeFrequencyButton.isHidden = false
                cell.timeRangeButton.isHidden = false
                cell.scheduledBasedOnButton.isEnabled = false
            } else {
                cell.timeRangeView.isHidden = true
                cell.timeFrequencyLbl.isHidden = true
                cell.timeRangeLbl.isHidden = true
                cell.scheduledBasedOnTextField.isHidden = false
                cell.scheduleBasedonLbl.isHidden = false
                cell.timeFrequencyButton.isHidden = true
                cell.timeRangeButton.isHidden = true
                cell.scheduledBasedOnButton.isEnabled = true
            }
            cell.timeHourlyButton.tag = indexPath.row
            cell.timeHourlyButton.addTarget(self, action: #selector(timeHourlyButtonMethod), for: .touchDown)
            cell.scheduledBasedOnButton.tag = indexPath.row
            cell.scheduledBasedOnButton.addTarget(self, action: #selector(scheduledBasedOnButtonMethod), for: .touchDown)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func leadSouceMethod(sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedLeadSources) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadSourceTextLabel.text = "Select source"
                    leadCell.leadSourceEmptyTextLabel.isHidden = false
                    leadCell.leadLandingView.isHidden = true
                    leadCell.leadFormView.isHidden = true
                    leadCell.leadSourceURLView.isHidden = true
                    self?.selectedLeadSources.removeAll()
                    self?.landingPage = ""
                    self?.landingForm = ""
                } else {
                    leadCell.leadSourceEmptyTextLabel.isHidden = true
                    leadCell.leadSourceTextLabel.text = selectedList.joined(separator: ",")
                    self?.selectedLeadSources = selectedList
                    if selectedList.joined(separator: ",").contains("Landing Page") && selectedList.joined(separator: ",").contains("Form") && selectedList.joined(separator: ",").contains("Facebook") {
                        leadCell.leadLandingView.isHidden = false
                        leadCell.leadFormView.isHidden = false
                        leadCell.leadSourceURLView.isHidden = false
                        self?.landingPage = "landingPage"
                        self?.landingForm = "landingForm"
                    }
                    else if selectedList.joined(separator: ",").contains("Landing Page") && selectedList.joined(separator: ",").contains("Form") {
                        leadCell.leadLandingView.isHidden = false
                        leadCell.leadFormView.isHidden = false
                        leadCell.leadSourceURLView.isHidden = true
                        self?.landingPage = "landingPage"
                        self?.landingForm = "landingForm"
                    }
                    else if selectedList.joined(separator: ",").contains("Landing Page") && selectedList.joined(separator: ",").contains("Facebook") {
                        leadCell.leadLandingView.isHidden = false
                        leadCell.leadSourceURLView.isHidden = false
                        leadCell.leadFormView.isHidden = true
                        self?.landingPage = "landingPage"
                    }
                    else if selectedList.joined(separator: ",").contains("Form") && selectedList.joined(separator: ",").contains("Facebook") {
                        leadCell.leadLandingView.isHidden = true
                        leadCell.leadSourceURLView.isHidden = false
                        leadCell.leadFormView.isHidden = false
                        self?.landingForm = "landingForm"
                    }
                    else if selectedList.joined(separator: ",").contains("Landing Page") {
                        leadCell.leadLandingView.isHidden = false
                        leadCell.leadSourceURLView.isHidden = true
                        leadCell.leadFormView.isHidden = true
                        self?.landingPage = "landingPage"
                    }
                    else if selectedList.joined(separator: ",").contains("Form") {
                        leadCell.leadLandingView.isHidden = true
                        leadCell.leadSourceURLView.isHidden = true
                        leadCell.leadFormView.isHidden = false
                        self?.landingForm = "landingForm"
                    }
                    else if selectedList.joined(separator: ",").contains("Facebook") {
                        leadCell.leadLandingView.isHidden = true
                        leadCell.leadSourceURLView.isHidden = false
                        leadCell.leadFormView.isHidden = true
                    }
                    else {
                        leadCell.leadLandingView.isHidden = true
                        leadCell.leadFormView.isHidden = true
                        leadCell.leadSourceURLView.isHidden = true
                    }
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadSourceArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadLandingMethod(sender: UIButton) {
        leadLandingPagesArray = viewModel?.getLandingPageNamesDataEdit ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadLandingPagesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedLeadLandingPages) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                if selectedList.count == 0 {
                    self?.selectedLeadLandingPages.removeAll()
                    leadCell.leadLandingTextLabel.text = "Please select landing page"
                    leadCell.leadLandingEmptyTextLabel.isHidden = false
                } else {
                    leadCell.leadLandingEmptyTextLabel.isHidden = true
                    self?.selectedLeadLandingPages = selectedList
                    leadCell.leadLandingTextLabel.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ",")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadLandingPagesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadFormMethod(sender: UIButton) {
        leadFormsArray = viewModel?.getTriggerQuestionnairesDataEdit ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadFormsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedleadForms) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                if selectedList.count == 0 {
                    self?.selectedleadForms.removeAll()
                    leadCell.leadFormTextLabel.text = "Please select form"
                    leadCell.leadFormEmptyTextLabel.isHidden = false
                } else {
                    leadCell.leadFormEmptyTextLabel.isHidden = true
                    self?.selectedleadForms = selectedList
                    leadCell.leadFormTextLabel.text =  selectedList.map({$0.name ?? String.blank}).joined(separator: ",")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadFormsArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadSourceUrlMethod(sender: UIButton) {
        leadSourceUrlArray = viewModel?.getTriggerLeadSourceUrlDataEdit ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceUrlArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.sourceUrl
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedLeadSourceUrl) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                if selectedList.count == 0 {
                    self?.selectedLeadSourceUrl.removeAll()
                    leadCell.leadSourceUrlTextLabel.text = "Please select source url"
                    leadCell.leadSourceUrlEmptyTextLabel.isHidden = false
                } else {
                    leadCell.leadSourceUrlEmptyTextLabel.isHidden = true
                    self?.selectedLeadSourceUrl = selectedList
                    leadCell.leadSourceUrlTextLabel.text = selectedList.map({$0.sourceUrl ?? String.blank}).joined(separator: ",")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadSourceUrlArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func patientAppointmentMethod(sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: appointmentStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedAppointmentStatus) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerAppointmentActionTableViewCell {
                if selectedList.count == 0 {
                    self?.selectedAppointmentStatus.removeAll()
                    patientCell.patientAppointmenTextLabel.text = "Select appointment status"
                    patientCell.patientAppointmentEmptyTextLbl.isHidden = false
                } else {
                    patientCell.patientAppointmentEmptyTextLbl.isHidden = true
                    self?.selectedAppointmentStatus = selectedList
                    patientCell.patientAppointmenTextLabel.text = selectedList.joined(separator: ",")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(appointmentStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func smsTargetSelectionMethod(sender: UIButton) {
        if moduleSelectionType == "lead" {
            smsTargetArray = ["Leads", "Clinic"]
            
        } else {
            smsTargetArray = ["Patient", "Clinic"]
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTargetArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectSMSTargetTextLabel.text = "Select trigger target"
                    createCell.selectSMSNetworkTextLabel.text = "Select network"
                    createCell.selectSMSTagetEmptyTextLabel.isHidden = false
                } else {
                    createCell.selectSMSTagetEmptyTextLabel.isHidden = true
                    createCell.selectSMSNetworkTextLabel.text = "Select network"
                    createCell.selectSMSTargetTextLabel.text = selectedItem
                    self?.smsTargetSelectionType = selectedItem ?? String.blank
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(smsTargetArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func smsNetworkSelectionMethod(sender: UIButton) {
        if moduleSelectionType == "lead" && smsTargetSelectionType == "Leads" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.smsTarget == "Lead"}) ?? []
        } else  if moduleSelectionType == "lead" && smsTargetSelectionType == "Clinic" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.smsTarget == "Clinic"}) ?? []
        } else if moduleSelectionType == "appointment" && smsTargetSelectionType == "Patient" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.smsTarget == "Patient"}) ?? []
        } else if moduleSelectionType == "appointment" && smsTargetSelectionType == "Clinic" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.smsTarget == "Clinic"}) ?? []
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectSMSNetworkTextLabel.text = "Select network"
                    createCell.selectSMSNetworkEmptyTextLabel.isHidden = false
                } else {
                    createCell.selectSMSNetworkEmptyTextLabel.isHidden = true
                    createCell.selectSMSNetworkTextLabel.text = selectedItem?.name
                    self?.selectedSmsTemplates = selectedList
                    self?.selectedSmsTemplateId = String(selectedItem?.id ?? 0)
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(smsTemplatesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func emailTargetSelectionMethod(sender: UIButton) {
        if moduleSelectionType == "lead" {
            emailTargetArray = ["Leads", "Clinic"]
            
        } else {
            emailTargetArray = ["Patient", "Clinic"]
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTargetArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectEmailTargetTextLabel.text = "Select trigger target"
                    createCell.selectEmailTagetEmptyTextLabel.isHidden = false
                    createCell.selectEmailNetworkTextLabel.text = "Select network"
                } else {
                    createCell.selectEmailTagetEmptyTextLabel.isHidden = true
                    createCell.selectEmailNetworkTextLabel.text = "Select network"
                    createCell.selectEmailTargetTextLabel.text = selectedItem
                    self?.emailTargetSelectionType = selectedItem ?? String.blank
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(emailTargetArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func emailNetworkSelectionMethod(sender: UIButton) {
        if moduleSelectionType == "lead" && emailTargetSelectionType == "Leads" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.emailTarget == "Lead"}) ?? []
        } else  if moduleSelectionType == "lead" && emailTargetSelectionType == "Clinic" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.emailTarget == "Clinic"}) ?? []
        } else if moduleSelectionType == "appointment" && emailTargetSelectionType == "Patient" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.emailTarget == "Patient"}) ?? []
        } else if moduleSelectionType == "appointment" && emailTargetSelectionType == "Clinic" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.emailTarget == "Clinic"}) ?? []
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectEmailNetworkTextLabel.text = "Select network"
                    createCell.selectEmailNetworkEmptyTextLabel.isHidden = false
                } else {
                    createCell.selectEmailNetworkEmptyTextLabel.isHidden = true
                    createCell.selectEmailNetworkTextLabel.text = selectedItem?.name
                    self?.selectedEmailTemplates = selectedList
                    self?.selectedemailTemplateId = String(selectedItem?.id ?? 0)
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(emailTemplatesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func taskNetworkSelectionMethod(sender: UIButton) {
        taskUserListArray = viewModel?.getTriggerDetailDataEdit?.userDTOList ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: taskUserListArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = "\(allClinics.firstName ?? "") \(allClinics.lastName ?? "")"
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.assignTaskNetworkTextLabel.text = "Select network"
                    createCell.assignTaskEmptyTextLabel.isHidden = false
                } else {
                    createCell.assignTaskEmptyTextLabel.isHidden = true
                    self?.selectedTaskTemplate = selectedItem?.id ?? 0
                    createCell.assignTaskNetworkTextLabel.text = "\(selectedItem?.firstName ?? "") \(selectedItem?.lastName ?? "")"
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(taskUserListArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func timeHourlyButtonMethod(sender: UIButton) {
        let timeHourlyArray = ["Min", "Hour", "Day"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: timeHourlyArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell {
                if selectedList.count == 0 {
                    createCell.timeHourlyTextField.showError(message: "Please enter time duration")
                } else {
                    createCell.timeHourlyTextField.text = selectedItem
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(timeHourlyArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func scheduledBasedOnButtonMethod(sender: UIButton) {
        let scheduledBasedOnArray = ["Appointment Created Date", "Before Appointment Date", "After Appointment Date"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: scheduledBasedOnArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell {
                createCell.scheduledBasedOnTextField.text = selectedItem
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(scheduledBasedOnArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @IBAction func submitButtonAction(sender: UIButton) {
        self.view.ShowSpinner()
        if moduleSelectionType == "lead" {
            if selectedTriggerTarget == "Leads" {
                selectedTriggerTarget = "lead"
            }
            if selectedNetworkType == "sms" {
                templateId = Int(selectedSmsTemplateId) ?? 0
                triggersCreateData.append(TriggerEditCreateData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: selectedNetworkType.uppercased(), triggerTarget: selectedTriggerTarget , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: "", showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: "NA", timerType: timerTypeSelected, startTime: "", endTime: "", deadline: ""))
            } else if selectedNetworkType == "email" {
                templateId = Int(selectedemailTemplateId) ?? 0
                triggersCreateData.append(TriggerEditCreateData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: selectedNetworkType.uppercased(), triggerTarget: selectedTriggerTarget , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: "", showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: "NA", timerType: timerTypeSelected, startTime: "", endTime: "", deadline: ""))
            } else {
                triggersCreateData.append(TriggerEditCreateData(actionIndex: 3, addNew: false, triggerTemplate: selectedTaskTemplate, triggerType: selectedNetworkType.uppercased(), triggerTarget: "lead" , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: taskName, showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: "NA", timerType: timerTypeSelected, startTime: "", endTime: "", deadline: ""))
            }
            let params = TriggerEditCreateModel(name: moduleName, moduleName: "leads", triggeractionName: "Pending", triggerConditions: selectedLeadSources, triggerData: triggersCreateData, landingPageNames: selectedLeadLandingPages, forms: selectedleadForms, sourceUrls: [])
            let parameters: [String: Any]  = params.toDict()
            viewModel?.createTriggerDataMethodEdit(triggerDataParms: parameters)
        } else {
            
            if selectedTriggerTarget == "Patient" {
                selectedTriggerTarget = "AppointmentPatient"
            } else {
                selectedTriggerTarget = "AppointmentClinic"
            }
            if selectedNetworkType == "sms" {
                templateId = Int(selectedSmsTemplateId) ?? 0
                triggersAppointmentCreateData.append(TriggerEditAppointmentCreateData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: selectedNetworkType.uppercased(), triggerTarget: selectedTriggerTarget , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: "", showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: scheduledBasedOnSelected))
            } else {
                templateId = Int(selectedemailTemplateId) ?? 0
                triggersAppointmentCreateData.append(TriggerEditAppointmentCreateData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: selectedNetworkType.uppercased(), triggerTarget: selectedTriggerTarget , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: "", showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: scheduledBasedOnSelected))
            }
            let params = TriggerEditAppointmentCreateModel(name: moduleName, moduleName: "Appointment", triggeractionName: appointmentSelectedStatus, triggerConditions: [], triggerData: triggersAppointmentCreateData, landingPageNames: [], forms: [], sourceUrls: [])
            let parameters: [String: Any]  = params.toDict()
            viewModel?.createAppointmentDataMethodEdit(appointmentDataParms: parameters)
        }
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

extension TriggerEditDetailViewController: TriggerDefaultCellDelegate {
    func nextButtonDefault(cell: TriggerDefaultTableViewCell, index: IndexPath) {
        if cell.massEmailSMSTextField.text == "" {
            cell.massEmailSMSTextField.showError(message: "Please enter trigger name")
        } else {
            moduleName = cell.massEmailSMSTextField.text ?? String.blank
            cell.moduleNextButton.isEnabled = false
            createNewTriggerCell(cellNameType: "Module")
        }
    }
}

extension TriggerEditDetailViewController: TriggerModuleCellDelegate {
    func nextButtonModule(cell: TriggerModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "appointment" {
            moduleSelectionType = moduleType
            createNewTriggerCell(cellNameType: "Appointment")
        } else if moduleType == "lead" {
            moduleSelectionType = moduleType
            createNewTriggerCell(cellNameType: "Lead")
        }
        cell.nextButton.isEnabled = false
        scrollToBottom()
    }
}

extension TriggerEditDetailViewController: TriggerLeadCellDelegate {
    func nextButtonLead(cell: TriggerLeadActionTableViewCell, index: IndexPath) {
        if cell.leadSourceTextLabel.text == "Select source" {
            cell.leadSourceEmptyTextLabel.isHidden = false
        }
        else if landingPage == "landingPage" && cell.leadLandingTextLabel.text == "Select landing page" {
            cell.leadLandingEmptyTextLabel.isHidden = false
        }
        else if landingForm == "landingForm" && cell.leadFormTextLabel.text == "Select form" {
            cell.leadFormEmptyTextLabel.isHidden = false
        }
        else {
            cell.leadNextButton.isEnabled = false
            cell.leadSourceEmptyTextLabel.isHidden = true
            cell.leadLandingEmptyTextLabel.isHidden = true
            cell.leadFormEmptyTextLabel.isHidden = true
            scrollToBottom()
            createNewTriggerCell(cellNameType: "Both")
        }
    }
}

extension TriggerEditDetailViewController: TriggerPatientCellDelegate {
    func nextButtonPatient(cell: TriggerAppointmentActionTableViewCell, index: IndexPath) {
        scrollToBottom()
        cell.appointmentNextButton.isEnabled = false
        appointmentSelectedStatus = cell.patientAppointmenTextLabel.text ?? ""
        createNewTriggerCell(cellNameType: "Both")
    }
}

extension TriggerEditDetailViewController: TriggerCreateCellDelegate {
    func nextButtonCreate(cell: TriggerSMSCreateTableViewCell, index: IndexPath, triggerNetworkType: String) {
        if cell.networkTypeSelected == "sms" {
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
        } else if cell.networkTypeSelected == "email" {
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
                cell.createNextButton.isEnabled = false
                cell.assignTaskEmptyTextLabel.isHidden = true
                taskName = cell.taskNameTextField.text ?? ""
                setupNetworkNextButton(networkType: triggerNetworkType, triggerTarget: "lead")
            }
        }
    }
    
    func setupNetworkNextButton(networkType: String, triggerTarget: String) {
        selectedNetworkType = networkType
        selectedTriggerTarget = triggerTarget
        scrollToBottom()
        createNewTriggerCell(cellNameType: "Time")
    }
}

extension TriggerEditDetailViewController: TriggerTimeCellDelegate {
    
    func addAnotherConditionButton(cell: TriggerTimeTableViewCell, index: IndexPath) {
        
        if triggerDetailList.count == 4 {
            orderOfConditionTrigger = orderOfConditionTrigger + 2
        } else {
            orderOfConditionTrigger = orderOfConditionTrigger + 1
        }
        
        if moduleSelectionType == "lead" {
            if cell.timerTypeSelected == "Frequency" {
                if cell.timeDurationTextField.text == "" {
                    cell.timeDurationTextField.showError(message: "Please enter time duration")
                } else if cell.timeHourlyTextField.text == "" {
                    cell.timeHourlyTextField.showError(message: "Please select duration")
                } else {
                    scrollToBottom()
                    createNewTriggerCell(cellNameType: "Both")
                }
            } else {
                if cell.timeRangeStartTimeTF.text == "" {
                    cell.timeRangeStartTimeTF.showError(message: "Please enter start time")
                } else if cell.timeRangeEndTimeTF.text == "" {
                    cell.timeRangeEndTimeTF.showError(message: "Please select end time")
                } else {
                    scrollToBottom()
                    createNewTriggerCell(cellNameType: "Both")
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
                createNewTriggerCell(cellNameType: "Both")
            }
        }
    }
    
    func nextBtnAction(cell: TriggerTimeTableViewCell, index: IndexPath) {
        if moduleSelectionType == "lead" {
            if cell.timerTypeSelected == "Frequency" {
                if cell.timeDurationTextField.text == "" {
                    cell.timeDurationTextField.showError(message: "Please enter time duration")
                } else if cell.timeHourlyTextField.text == "" {
                    cell.timeHourlyTextField.showError(message: "Please select duration")
                } else {
                    selectedTriggerTime = cell.timeDurationTextField.text ?? ""
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
                    selectedTriggerTime = cell.timeDurationTextField.text ?? ""
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
                selectedTriggerTime = cell.timeDurationTextField.text ?? ""
                selectedTriggerFrequency = cell.timeHourlyTextField.text ?? ""
                timerTypeSelected = cell.timerTypeSelected
                submitBtn.backgroundColor = UIColor(hexString: "#009EDE")
                submitBtn.isEnabled = true
            }
        }
    }
    
    func buttontimeRangeStartTapped(cell: TriggerTimeTableViewCell) {
        guard let indexPath = self.triggerdDetailTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let  triggerTimeCell = self.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell {
            triggerTimeCell.updateTimeRangeStartTextField(with: self.viewModel?.timeFormatterStringEdit(textField: cell.timeRangeStartTimeTF) ?? String.blank)
        }
    }
    
    func buttontimeRangeEndTapped(cell: TriggerTimeTableViewCell) {
        guard let indexPath = self.triggerdDetailTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let triggerTimeCell = self.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell {
            triggerTimeCell.updateTimeRangeEndTextField(with: self.viewModel?.timeFormatterStringEdit(textField: cell.timeRangeEndTimeTF) ?? String.blank)
        }
    }
}
