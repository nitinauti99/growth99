//
//  TriggerDetailViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation
import UIKit

extension TriggerDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
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
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Module" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerModuleTableViewCell", for: indexPath) as? TriggerModuleTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            moduleSelectionType = cell.moduleTypeSelected
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerLeadActionTableViewCell", for: indexPath) as? TriggerLeadActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.leadStatusSelectonButton.addTarget(self, action: #selector(leadStatusMethod), for: .touchDown)
            cell.leadStatusSelectonButton.tag = indexPath.row
            cell.leadLandingSelectonButton.addTarget(self, action: #selector(leadLandingMethod), for: .touchDown)
            cell.leadLandingSelectonButton.tag = indexPath.row
            cell.leadFormSelectonButton.addTarget(self, action: #selector(leadFormMethod), for: .touchDown)
            cell.leadFormSelectonButton.tag = indexPath.row
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Appointment" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerAppointmentActionTableViewCell", for: indexPath) as? TriggerAppointmentActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.patientAppointmentButton.addTarget(self, action: #selector(patientAppointmentMethod), for: .touchDown)
            cell.patientAppointmentButton.tag = indexPath.row
            cell.patientAppointmenTextLabel.text = statusArray[0]
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
                cell.timeRangeView.isHidden = true
                cell.timeFrequencyLbl.isHidden = true
                cell.timeRangeLbl.isHidden = true
                cell.scheduledBasedOnTextField.isHidden = true
                cell.scheduleBasedonLbl.isHidden = true
                cell.timeFrequencyButton.isHidden = true
                cell.timeRangeButton.isHidden = true
            } else {
                cell.timeRangeView.isHidden = false
                cell.timeFrequencyLbl.isHidden = false
                cell.timeRangeLbl.isHidden = false
                cell.scheduledBasedOnTextField.isHidden = false
                cell.scheduleBasedonLbl.isHidden = false
                cell.timeFrequencyButton.isHidden = false
                cell.timeRangeButton.isHidden = false
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
    
    @objc func leadStatusMethod(sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedLeadStatusArray) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                self?.selectedLeadStatusArray = selectedList
                leadCell.leadStatusTextLabel.text = selectedList.joined(separator: ", ")
                if selectedList.joined(separator: ", ").contains("Landing Page") && selectedList.joined(separator: ", ").contains("Form") {
                    leadCell.leadLandingView.isHidden = false
                    leadCell.leadFormView.isHidden = false
                }
                else if selectedList.joined(separator: ", ").contains("Landing Page") {
                    leadCell.leadLandingView.isHidden = false
                    leadCell.leadFormView.isHidden = true
                }
                else if selectedList.joined(separator: ", ").contains("Form") {
                    leadCell.leadFormView.isHidden = false
                    leadCell.leadLandingView.isHidden = true
                }
                else {
                    leadCell.leadLandingView.isHidden = true
                    leadCell.leadFormView.isHidden = true
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadSourceArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadLandingMethod(sender: UIButton) {
        landingPagesArray = viewModel?.getLandingPageNamesData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: landingPagesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadLandingTextLabel.text = "Please select landing page"
                    leadCell.leadLandingEmptyTextLabel.isHidden = false
                } else {
                    leadCell.leadLandingEmptyTextLabel.isHidden = true
                    leadCell.leadLandingTextLabel.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(landingPagesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadFormMethod(sender: UIButton) {
        landingFormsArray = viewModel?.getTriggerQuestionnairesData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: landingFormsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadFormTextLabel.text = "Please select form"
                    leadCell.leadFormEmptyTextLabel.isHidden = false
                } else {
                    leadCell.leadFormEmptyTextLabel.isHidden = true
                    leadCell.leadFormTextLabel.text =  selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(landingFormsArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func patientAppointmentMethod(sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: statusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerAppointmentActionTableViewCell {
                if selectedList.count == 0 {
                    patientCell.patientAppointmenTextLabel.text = "Select patient appointment"
                } else {
                    patientCell.patientAppointmenTextLabel.text = selectedList.joined(separator: ", ")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(statusArray.count * 30))), arrowDirection: .up), from: self)
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
                createCell.selectSMSTargetTextLabel.text = selectedItem
                self?.smsTargetSelectionType = selectedItem ?? String.blank
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(smsTargetArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func smsNetworkSelectionMethod(sender: UIButton) {
        if moduleSelectionType == "lead" && smsTargetSelectionType == "Leads" {
            smsTemplatesArray = viewModel?.getTriggerDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.smsTarget == "Lead"}) ?? []
        } else  if moduleSelectionType == "lead" && smsTargetSelectionType == "Clinic" {
            smsTemplatesArray = viewModel?.getTriggerDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.smsTarget == "Clinic"}) ?? []
        } else if moduleSelectionType == "appointment" && smsTargetSelectionType == "Patient" {
            smsTemplatesArray = viewModel?.getTriggerDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.smsTarget == "Patient"}) ?? []
        } else if moduleSelectionType == "appointment" && smsTargetSelectionType == "Clinic" {
            smsTemplatesArray = viewModel?.getTriggerDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.smsTarget == "Clinic"}) ?? []
        }

        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                createCell.selectSMSNetworkTextLabel.text = selectedItem?.name
                self?.selectedSmsTemplates = selectedList
                self?.selectedSmsTemplateId = String(selectedItem?.id ?? 0)
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
                createCell.selectEmailTargetTextLabel.text = selectedItem
                self?.emailTargetSelectionType = selectedItem ?? String.blank
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(emailTargetArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func emailNetworkSelectionMethod(sender: UIButton) {
        if moduleSelectionType == "lead" && emailTargetSelectionType == "Leads" {
            emailTemplatesArray = viewModel?.getTriggerDetailData?.emailTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.emailTarget == "Lead"}) ?? []
        } else  if moduleSelectionType == "lead" && emailTargetSelectionType == "Clinic" {
            emailTemplatesArray = viewModel?.getTriggerDetailData?.emailTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.emailTarget == "Clinic"}) ?? []
        } else if moduleSelectionType == "appointment" && emailTargetSelectionType == "Patient" {
            emailTemplatesArray = viewModel?.getTriggerDetailData?.emailTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.emailTarget == "Patient"}) ?? []
        } else if moduleSelectionType == "appointment" && emailTargetSelectionType == "Clinic" {
            emailTemplatesArray = viewModel?.getTriggerDetailData?.emailTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.emailTarget == "Clinic"}) ?? []
        }

        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                createCell.selectEmailNetworkTextLabel.text = selectedItem?.name
                self?.selectedEmailTemplates = selectedList
                self?.selectedemailTemplateId = String(selectedItem?.id ?? 0)
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(emailTemplatesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func taskNetworkSelectionMethod(sender: UIButton) {
        taskUserListArray = viewModel?.getTriggerDetailData?.userDTOList ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: taskUserListArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = "\(allClinics.firstName ?? "") \(allClinics.lastName ?? "")"
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                createCell.assignTaskNetworkTextLabel.text = "\(selectedItem?.firstName ?? "") \(selectedItem?.lastName ?? "")"
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
                createCell.timeHourlyTextField.text = selectedItem
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
}

extension TriggerDetailViewController: TriggerDefaultCellDelegate {
    func nextButtonDefault(cell: TriggerDefaultTableViewCell, index: IndexPath) {
        if cell.massEmailSMSTextField.text == "" {
            cell.massEmailSMSTextField.showError(message: "Please enter trigger name")
        } else {
            let emailSMS = TriggerDetailModel(cellType: "Module", LastName: "")
            triggerDetailList.append(emailSMS)
            triggerdDetailTableView.beginUpdates()
            let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
            triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
            triggerdDetailTableView.endUpdates()
        }
    }
}

extension TriggerDetailViewController: TriggerModuleCellDelegate {
    func nextButtonModule(cell: TriggerModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "appointment" {
            moduleSelectionType = moduleType
            let emailSMS = TriggerDetailModel(cellType: "Appointment", LastName: "")
            triggerDetailList.append(emailSMS)
            triggerdDetailTableView.beginUpdates()
            let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
            triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
            triggerdDetailTableView.endUpdates()
        } else if moduleType == "lead" {
            moduleSelectionType = moduleType
            let emailSMS = TriggerDetailModel(cellType: "Lead", LastName: "")
            triggerDetailList.append(emailSMS)
            triggerdDetailTableView.beginUpdates()
            let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
            triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
            triggerdDetailTableView.endUpdates()
        }
    }
}

extension TriggerDetailViewController: TriggerCreateCellDelegate {
    func nextButtonCreate(cell: TriggerSMSCreateTableViewCell, index: IndexPath) {
        if cell.networkTypeSelected == "sms" {
            if cell.selectSMSTargetTextLabel.text == "Select trigger target" {
                cell.selectSMSTagetEmptyTextLabel.isHidden = false
            } else if cell.selectSMSNetworkTextLabel.text == "Select network" {
                cell.selectSMSNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectSMSTagetEmptyTextLabel.isHidden = true
                cell.selectSMSNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton()
            }
        } else if cell.networkTypeSelected == "email" {
            if cell.selectEmailTargetTextLabel.text == "Select trigger target" {
                cell.selectEmailTagetEmptyTextLabel.isHidden = false
            } else if cell.selectEmailNetworkTextLabel.text == "Select network" {
                cell.selectEmailNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectEmailTagetEmptyTextLabel.isHidden = true
                cell.selectEmailNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton()
            }
        } else {
            if cell.taskNameTextField.text == String.blank {
                cell.taskNameTextField.showError(message: "Please enter task name")
            } else if cell.assignTaskNetworkTextLabel.text == "Select network" {
                cell.assignTaskEmptyTextLabel.isHidden = false
            } else {
                cell.assignTaskEmptyTextLabel.isHidden = true
                setupNetworkNextButton()
            }
        }
    }
    
    func setupNetworkNextButton() {
        let emailSMS = TriggerDetailModel(cellType: "Time", LastName: "")
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
}

extension TriggerDetailViewController: TriggerLeadCellDelegate {
    func nextButtonLead(cell: TriggerLeadActionTableViewCell, index: IndexPath) {
        if cell.leadStatusTextLabel.text == "Select source" {
            cell.leadStatusEmptyTextLabel.isHidden = false
        } else {
            cell.leadStatusEmptyTextLabel.isHidden = true
            let emailSMS = TriggerDetailModel(cellType: "Both", LastName: "")
            triggerDetailList.append(emailSMS)
            triggerdDetailTableView.beginUpdates()
            let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
            triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
            triggerdDetailTableView.endUpdates()
        }
    }
}

extension TriggerDetailViewController: TriggerPatientCellDelegate {
    func nextButtonPatient(cell: TriggerAppointmentActionTableViewCell, index: IndexPath) {
        let emailSMS = TriggerDetailModel(cellType: "Both", LastName: "")
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
}

extension TriggerDetailViewController: TriggerTimeCellDelegate {
    
    func addAnotherConditionButton(cell: TriggerTimeTableViewCell, index: IndexPath) {
        
    }
    
    func buttontimeRangeStartTapped(cell: TriggerTimeTableViewCell) {
        guard let indexPath = self.triggerdDetailTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let  triggerTimeCell = self.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell {
            triggerTimeCell.updateTimeRangeStartTextField(with: self.viewModel?.timeFormatterString(textField: cell.timeRangeStartTimeTF) ?? String.blank)
        }
    }
    
    func buttontimeRangeEndTapped(cell: TriggerTimeTableViewCell) {
        guard let indexPath = self.triggerdDetailTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let triggerTimeCell = self.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell {
            triggerTimeCell.updateTimeRangeEndTextField(with: self.viewModel?.timeFormatterString(textField: cell.timeRangeEndTimeTF) ?? String.blank)
        }
    }
}
