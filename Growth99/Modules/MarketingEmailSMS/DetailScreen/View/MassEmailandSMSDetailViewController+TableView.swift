//
//  MassEmailandSMSDetailViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation
import UIKit

extension MassEmailandSMSDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailAndSMSDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if emailAndSMSDetailList[indexPath.row].cellType == "Default" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSDefaultTableViewCell", for: indexPath) as? MassEmailandSMSDefaultTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Module" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSModuleTableViewCell", for: indexPath) as? MassEmailandSMSModuleTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSLeadActionTableViewCell", for: indexPath) as? MassEmailandSMSLeadActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.leadStatusSelectonButton.addTarget(self, action: #selector(leadStatusMethod), for: .touchDown)
            cell.leadStatusSelectonButton.tag = indexPath.row
            cell.leadSourceSelectonButton.addTarget(self, action: #selector(leadSourceMethod), for: .touchDown)
            cell.leadSourceSelectonButton.tag = indexPath.row
            cell.leadTagSelectonButton.addTarget(self, action: #selector(leadTagMethod), for: .touchDown)
            cell.leadTagSelectonButton.tag = indexPath.row
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Patient" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSPatientActionTableViewCell", for: indexPath) as? MassEmailandSMSPatientActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.patientStatusSelectonButton.addTarget(self, action: #selector(patientStatusMethod), for: .touchDown)
            cell.patientStatusSelectonButton.tag = indexPath.row
            cell.patientTagSelectonButton.addTarget(self, action: #selector(patientTagMethod), for: .touchDown)
            cell.patientTagSelectonButton.tag = indexPath.row
            cell.patientAppointmentButton.addTarget(self, action: #selector(patientAppointmentMethod), for: .touchDown)
            cell.patientAppointmentButton.tag = indexPath.row
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Both" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSCreateTableViewCell", for: indexPath) as? MassEmailandSMSCreateTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.networkSelectonSMSButton.tag = indexPath.row
            cell.networkSelectonSMSButton.addTarget(self, action: #selector(networkSelectionSMSMethod), for: .touchDown)
            cell.networkSelectonEmailButton.tag = indexPath.row
            cell.networkSelectonEmailButton.addTarget(self, action: #selector(networkSelectionEmailMethod), for: .touchDown)
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Time" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSTimeTableViewCell", for: indexPath) as? MassEmailandSMSTimeTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func leadStatusMethod(sender: UIButton) {
        let leadStatusArray = ["NEW", "COLD", "WARM", "HOT", "WON","DEAD"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadStatusTextLabel.text = "Select lead status"
                    leadCell.leadStatusEmptyTextLabel.isHidden = false
                } else {
                    leadCell.leadStatusEmptyTextLabel.isHidden = true
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
        let leadSourceArray = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSLeadActionTableViewCell {
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
        leadTagsArray = viewModel?.getMassEmailLeadTagsData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadTagsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSLeadActionTableViewCell {
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
    
    @objc func patientStatusMethod(sender: UIButton) {
        let leadStatusArray = ["NEW", "EXISTING"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSPatientActionTableViewCell {
                if selectedList.count == 0 {
                    patientCell.patientStatusTextLabel.text = "Select patient status"
                    patientCell.patientStatusEmptyTextLabel.isHidden = false
                } else {
                    patientCell.patientStatusEmptyTextLabel.isHidden = true
                    patientCell.patientStatusTextLabel.text = selectedList.joined(separator: ", ")
                }
            }
        }
        
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func patientAppointmentMethod(sender: UIButton) {
        let statusArray = ["Pending", "Confirmed", "Completed", "Cancelled", "Updated"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: statusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSPatientActionTableViewCell {
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
    
    @objc func patientTagMethod(sender: UIButton) {
        patientTagsArray = viewModel?.getMassEmailPateintsTagsData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: patientTagsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSPatientActionTableViewCell {
                if selectedList.count == 0 {
                    patientCell.patientTagTextLabel.text = "Select patient tag"
                } else {
                    patientCell.patientTagTextLabel.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
                    self?.selectedPatientTags = selectedList
                    let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
                    self?.selectedPatientTagIds = formattedArray
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(patientTagsArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func networkSelectionSMSMethod(sender: UIButton) {
        smsTemplatesArray = viewModel?.getMassEmailDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "MassSMS"}) ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSCreateTableViewCell {
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
        emailTemplatesArray = viewModel?.getMassEmailDetailData?.emailTemplateDTOList?.filter({ $0.templateFor == "MassEmail"}) ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSCreateTableViewCell {
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

extension MassEmailandSMSDetailViewController: MassEmailandSMSDefaultCellDelegate {
    func nextButtonDefault(cell: MassEmailandSMSDefaultTableViewCell, index: IndexPath) {
        if cell.massEmailSMSTextField.text == "" {
            cell.massEmailSMSTextField.showError(message: "Please enter Mass Email or SMS name")
        } else {
            let emailSMS = MassEmailandSMSDetailModel(cellType: "Module", LastName: "")
            emailAndSMSDetailList.append(emailSMS)
            emailAndSMSTableView.beginUpdates()
            let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
            emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
            emailAndSMSTableView.endUpdates()
        }
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSModuleCellDelegate {
    func nextButtonModule(cell: MassEmailandSMSModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "patient" {
            let emailSMS = MassEmailandSMSDetailModel(cellType: "Patient", LastName: "")
            emailAndSMSDetailList.append(emailSMS)
            emailAndSMSTableView.beginUpdates()
            let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
            emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
            emailAndSMSTableView.endUpdates()
        } else if moduleType == "lead" {
            let emailSMS = MassEmailandSMSDetailModel(cellType: "Lead", LastName: "")
            emailAndSMSDetailList.append(emailSMS)
            emailAndSMSTableView.beginUpdates()
            let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
            emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
            emailAndSMSTableView.endUpdates()
        } else {
            self.view.ShowSpinner()
            viewModel?.getMassEmailLeadStatusAllMethod()
        }
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSCreateCellDelegate {
    func nextButtonCreate(cell: MassEmailandSMSCreateTableViewCell, index: IndexPath) {
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
        let emailSMS = MassEmailandSMSDetailModel(cellType: "Time", LastName: "")
        emailAndSMSDetailList.append(emailSMS)
        emailAndSMSTableView.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
        emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableView.endUpdates()
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSLeadCellDelegate {
    func nextButtonLead(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath) {
        if cell.leadStatusTextLabel.text == "Select lead status" {
            cell.leadStatusEmptyTextLabel.isHidden = false
        } else {
            cell.leadStatusEmptyTextLabel.isHidden = true
            leadActionApiCallMethod(selectedCell: cell)
        }
    }
    
    func leadActionApiCallMethod(selectedCell: MassEmailandSMSLeadActionTableViewCell) {
        self.view.ShowSpinner()
        if selectedCell.leadSourceTextLabel.text ?? String.blank == "Select lead source" {
            leadSource = String.blank
        } else {
            leadSource = selectedCell.leadSourceTextLabel.text ?? String.blank
        }
        viewModel?.getMassEmailLeadStatusMethod(leadStatus: selectedCell.leadStatusTextLabel.text ?? String.blank, moduleName: "MassLead", leadTagIds: selectedLeadTagIds, source: leadSource)
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSPatientCellDelegate {
    func nextButtonPatient(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath) {
        if cell.patientStatusTextLabel.text == "Select patient status" {
            cell.patientStatusEmptyTextLabel.isHidden = false
        } else {
            cell.patientStatusEmptyTextLabel.isHidden = true
            patientActionApiCallMethod(selectedCell: cell)
        }
    }
    
    func patientActionApiCallMethod(selectedCell: MassEmailandSMSPatientActionTableViewCell) {
        self.view.ShowSpinner()
        if selectedCell.patientAppointmenTextLabel.text ?? String.blank == "Select appointment status" {
            patientAppointmentStatus = String.blank
        } else {
            patientAppointmentStatus = selectedCell.patientAppointmenTextLabel.text ?? String.blank
        }
        viewModel?.getMassEmailPatientStatusMethod(appointmentStatus: patientAppointmentStatus, moduleName: "MassPatient", patientTagIds: selectedPatientTagIds, patientStatus: selectedCell.patientStatusTextLabel.text ?? String.blank)
    }
}


extension MassEmailandSMSDetailViewController: MassEmailandSMSTimeCellDelegate {
    func nextButtonTime(cell: MassEmailandSMSTimeTableViewCell, index: IndexPath) {
        
    }
    
    func massEmailTimeFromTapped(cell: MassEmailandSMSTimeTableViewCell) {
        guard let indexPath = emailAndSMSTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSTimeTableViewCell {
            vacationCell.updateMassEmailTimeFromTextField(with: "\(viewModel?.localToServerWithDate(date: cell.massEmailTimeFromTextField.text ?? String.blank) ?? "")")
            vacationCell.massEmailTimeFromTextField.resignFirstResponder()
        }
    }
}