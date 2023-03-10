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
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerLeadActionTableViewCell", for: indexPath) as? TriggerLeadActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.leadStatusSelectonButton.addTarget(self, action: #selector(leadStatusMethod), for: .touchDown)
            cell.leadStatusSelectonButton.tag = indexPath.row
            cell.leadSourceTriggerSelectonButton.addTarget(self, action: #selector(leadSourceMethod), for: .touchDown)
            cell.leadSourceTriggerSelectonButton.tag = indexPath.row
            cell.leadTagSelectonButton.addTarget(self, action: #selector(leadTagMethod), for: .touchDown)
            cell.leadTagSelectonButton.tag = indexPath.row
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
            cell.networkSelectonSMSButton.tag = indexPath.row
            cell.networkSelectonSMSButton.addTarget(self, action: #selector(networkSelectionSMSMethod), for: .touchDown)
            cell.networkSelectonEmailButton.tag = indexPath.row
            cell.networkSelectonEmailButton.addTarget(self, action: #selector(networkSelectionEmailMethod), for: .touchDown)
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Time" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerTimeTableViewCell", for: indexPath) as? TriggerTimeTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func leadStatusMethod(sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadStatusTextLabel.text = "Select lead status"
                } else {
                    leadCell.leadStatusTextLabel.text = selectedList.joined(separator: ", ")
                }
            }
        }
        
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadSourceMethod(sender: UIButton) {
        let leadSourceArray = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook", "Integrately"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadSourceTextLabel.text = "Select lead source"
                } else {
                    leadCell.leadSourceTextLabel.text = selectedList.joined(separator: ", ")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadSourceArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadTagMethod(sender: UIButton) {
        leadTagsArray = viewModel?.getTriggerLeadTagsData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadTagsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedLeadTags) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadTagTextLabel.text = "Select lead tag"
                } else {
                    leadCell.leadTagTextLabel.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
                    self?.selectedLeadTags  = selectedList
                    let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
                    self?.selectedLeadTagIds = formattedArray
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadTagsArray.count * 30))), arrowDirection: .up), from: self)
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
    
    @objc func networkSelectionSMSMethod(sender: UIButton) {
        smsTemplatesArray = viewModel?.getTriggerDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "Appointment"}) ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedSmsTemplates) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectNetworkSMSTextLabel.text = "Please select network"
                    createCell.selectNetworkEmptyTextLabel.isHidden = false
                } else {
                    createCell.selectNetworkEmptyTextLabel.isHidden = true
                    createCell.selectNetworkSMSTextLabel.text = selectedItem?.name
                    self?.selectedSmsTemplates = selectedList
                    self?.selectedSmsTemplateId = String(selectedItem?.id ?? 0)
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(smsTemplatesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func networkSelectionEmailMethod(sender: UIButton) {
        emailTemplatesArray = viewModel?.getTriggerDetailData?.emailTemplateDTOList?.filter({ $0.templateFor == "MassEmail"}) ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedEmailTemplates) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectNetworkEmailTextLabel.text = "Please select network"
                    createCell.selectNetworkEmptyTextLabel.isHidden = false
                } else {
                    createCell.selectNetworkEmptyTextLabel.isHidden = true
                    createCell.selectNetworkEmailTextLabel.text = selectedItem?.name
                    self?.selectedEmailTemplates = selectedList
                    self?.selectedemailTemplateId = String(selectedItem?.id ?? 0)
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(emailTemplatesArray.count * 30))), arrowDirection: .up), from: self)
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
            let emailSMS = TriggerDetailModel(cellType: "Appointment", LastName: "")
            triggerDetailList.append(emailSMS)
            triggerdDetailTableView.beginUpdates()
            let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
            triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
            triggerdDetailTableView.endUpdates()
        } else if moduleType == "lead" {
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
            if cell.selectNetworkSMSTextLabel.text == "Please select network" {
                cell.selectNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton()
            }
        } else {
            if cell.selectNetworkEmailTextLabel.text == "Please select network" {
                cell.selectNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectNetworkEmptyTextLabel.isHidden = true
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
        let emailSMS = TriggerDetailModel(cellType: "Both", LastName: "")
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
    
    func leadActionApiCallMethod(selectedCell: TriggerLeadActionTableViewCell) {
        self.view.ShowSpinner()
        if selectedCell.leadSourceTextLabel.text ?? String.blank == "Select lead source" {
            leadSource = String.blank
        } else {
            leadSource = selectedCell.leadSourceTextLabel.text ?? String.blank
        }
        viewModel?.getTriggerLeadStatusMethod(leadStatus: selectedCell.leadStatusTextLabel.text ?? String.blank, moduleName: "MassLead", leadTagIds: selectedLeadTagIds, source: leadSource)
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
    func nextButtonTime(cell: TriggerTimeTableViewCell, index: IndexPath) {
        
    }
    
    func triggerTimeFromTapped(cell: TriggerTimeTableViewCell) {
        guard let indexPath = triggerdDetailTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell {
            vacationCell.updatetriggerTimeFromTextField(with: "\(viewModel?.localToServerWithDate(date: cell.triggerTimeFromTextField.text ?? String.blank) ?? "")")
            vacationCell.triggerTimeFromTextField.resignFirstResponder()
        }
    }
}
