//
//  MassEmailandSMSEditDetailViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation
import UIKit

extension MassEmailandSMSEditDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailAndSMSDetailListEdit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if emailAndSMSDetailListEdit[indexPath.row].cellType == "Default" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditDefaultTableViewCell", for: indexPath) as? MassEmailandSMSEditDefaultTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            moduleNameEdit = cell.massEmailSMSTextField.text ?? String.blank
            return cell
        } else if emailAndSMSDetailListEdit[indexPath.row].cellType == "Module" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditModuleTableViewCell", for: indexPath) as? MassEmailandSMSEditModuleTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            smsEmailModuleSelectionTypeEdit = cell.moduleTypeSelected
            return cell
        } else if emailAndSMSDetailListEdit[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditLeadActionTableViewCell", for: indexPath) as? MassEmailandSMSEditLeadActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.leadStatusSelectonButton.addTarget(self, action: #selector(leadStatusMethod), for: .touchDown)
            cell.leadStatusSelectonButton.tag = indexPath.row
            cell.leadSourceSelectonButton.addTarget(self, action: #selector(leadSourceMethod), for: .touchDown)
            cell.leadSourceSelectonButton.tag = indexPath.row
            cell.leadTagSelectonButton.addTarget(self, action: #selector(leadTagMethod), for: .touchDown)
            cell.leadTagSelectonButton.tag = indexPath.row
            return cell
        } else if emailAndSMSDetailListEdit[indexPath.row].cellType == "Patient" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditPatientActionTableViewCell", for: indexPath) as? MassEmailandSMSEditPatientActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.patientStatusSelectonButton.addTarget(self, action: #selector(patientStatusMethod), for: .touchDown)
            cell.patientStatusSelectonButton.tag = indexPath.row
            cell.patientTagSelectonButton.addTarget(self, action: #selector(patientTagMethod), for: .touchDown)
            cell.patientTagSelectonButton.tag = indexPath.row
            cell.patientAppointmentButton.addTarget(self, action: #selector(patientAppointmentMethod), for: .touchDown)
            cell.patientAppointmentButton.tag = indexPath.row
            return cell
        } else if emailAndSMSDetailListEdit[indexPath.row].cellType == "Both" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditCreateTableViewCell", for: indexPath) as? MassEmailandSMSEditCreateTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            networkTypeSelectedEdit = cell.networkTypeSelected
            cell.networkSelectonSMSButton.tag = indexPath.row
            cell.networkSelectonSMSButton.addTarget(self, action: #selector(networkSelectionSMSMethod), for: .touchDown)
            if cell.smsBtn.isSelected {
                cell.smsEmailCountTextLabel.text = "SMS count: \(viewModelEdit?.getMassEmailSMSLeadCountDataEdit?.smsCount ?? 0)"
            } else {
                cell.smsEmailCountTextLabel.text = "Email count: \(String(viewModelEdit?.getMassEmailSMSLeadCountDataEdit?.emailCount ?? 0))"
            }
            cell.networkSelectonEmailButton.tag = indexPath.row
            cell.networkSelectonEmailButton.addTarget(self, action: #selector(networkSelectionEmailMethod), for: .touchDown)
            
            return cell
        } else if emailAndSMSDetailListEdit[indexPath.row].cellType == "Time" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditTimeTableViewCell", for: indexPath) as? MassEmailandSMSEditTimeTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.updateMassEmailTimeFromTextField(with: "\(viewModelEdit?.dateFormatterStringEdit(textField:  cell.massEmailTimeFromTextField) ?? "") \(viewModelEdit?.timeFormatterStringEdit(textField:  cell.massEmailTimeFromTextField) ?? "")")
            selectedTimeSlotEdit = viewModelEdit?.localInputToServerInputEdit(date: "\(viewModelEdit?.dateFormatterStringEdit(textField:  cell.massEmailTimeFromTextField) ?? "") \(viewModelEdit?.timeFormatterStringEdit(textField:  cell.massEmailTimeFromTextField) ?? "")") ?? String.blank
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
            cell.textLabel?.text = allClinics
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: leadStatusSelectedEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSEditLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadStatusTextLabel.text = "Select lead status"
                    leadCell.leadStatusEmptyTextLabel.isHidden = false
                } else {
                    leadCell.leadStatusEmptyTextLabel.isHidden = true
                    self?.leadStatusSelectedEdit = selectedList
                    leadCell.leadStatusTextLabel.text = selectedList.joined(separator: ",")
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
            cell.textLabel?.text = allClinics
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: leadSourceSelectedEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSEditLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadSourceTextLabel.text = "Select lead source"
                } else {
                    self?.leadSourceSelectedEdit = selectedList
                    leadCell.leadSourceTextLabel.text = selectedList.joined(separator: ",")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadSourceArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadTagMethod(sender: UIButton) {
        leadTagsArrayEdit = viewModelEdit?.getMassEmailLeadTagsDataEdit ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadTagsArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedLeadTagsEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSEditLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadTagTextLabel.text = "Select lead tag"
                } else {
                    leadCell.leadTagTextLabel.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
                    self?.selectedLeadTagsEdit  = selectedList
                    let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
                    self?.selectedLeadTagIdsEdit = formattedArray
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadTagsArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func patientStatusMethod(sender: UIButton) {
        let leadStatusArray = ["NEW", "EXISTING"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: paymentStatusSelectedEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSEditPatientActionTableViewCell {
                if selectedList.count == 0 {
                    patientCell.patientStatusTextLabel.text = "Select patient status"
                    patientCell.patientStatusEmptyTextLabel.isHidden = false
                } else {
                    patientCell.patientStatusEmptyTextLabel.isHidden = true
                    self?.paymentStatusSelectedEdit = selectedList
                    patientCell.patientStatusTextLabel.text = selectedList.joined(separator: ",")
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
            cell.textLabel?.text = allClinics
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: appointmentStatusSelectedEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSEditPatientActionTableViewCell {
                if selectedList.count == 0 {
                    patientCell.patientAppointmenTextLabel.text = "Select patient appointment"
                } else {
                    self?.appointmentStatusSelectedEdit = selectedList
                    patientCell.patientAppointmenTextLabel.text = selectedList.joined(separator: ",")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(statusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func patientTagMethod(sender: UIButton) {
        patientTagsArrayEdit = viewModelEdit?.getMassEmailPateintsTagsDataEdit ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: patientTagsArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedPatientTagsEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSEditPatientActionTableViewCell {
                if selectedList.count == 0 {
                    patientCell.patientTagTextLabel.text = "Select patient tag"
                } else {
                    patientCell.patientTagTextLabel.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
                    self?.selectedPatientTagsEdit = selectedList
                    let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
                    self?.selectedPatientTagIdsEdit = formattedArray
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(patientTagsArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func networkSelectionSMSMethod(sender: UIButton) {
        if smsEmailModuleSelectionTypeEdit == "lead" {
            smsTemplatesArrayEdit = viewModelEdit?.getMassEmailDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "MassSMS" && $0.smsTarget == "Lead"}) ?? []
        } else if smsEmailModuleSelectionTypeEdit == "patient" {
            smsTemplatesArrayEdit = viewModelEdit?.getMassEmailDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "MassSMS" && $0.smsTarget == "Patient"}) ?? []
        }  else {
            smsTemplatesArrayEdit = viewModelEdit?.getMassEmailDetailDataEdit?.smsTemplateDTOList?.filter({$0.templateFor == "MassSMS"}) ?? []
        }
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTemplatesArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedSmsTemplatesEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSEditCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectNetworkSMSTextLabel.text = "Please select network"
                    createCell.selectNetworkEmptyTextLabel.isHidden = false
                } else {
                    createCell.selectNetworkEmptyTextLabel.isHidden = true
                    createCell.selectNetworkSMSTextLabel.text = selectedItem?.name
                    self?.selectedSmsTemplatesEdit = selectedList
                    self?.selectedSmsTemplateIdEdit = String(selectedItem?.id ?? 0)
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(smsTemplatesArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func networkSelectionEmailMethod(sender: UIButton) {
        if smsEmailModuleSelectionTypeEdit == "lead" {
            emailTemplatesArrayEdit = viewModelEdit?.getMassEmailDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "MassEmail" && $0.emailTarget == "Lead"}) ?? []
        } else if smsEmailModuleSelectionTypeEdit == "patient" {
            emailTemplatesArrayEdit = viewModelEdit?.getMassEmailDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "MassEmail" && $0.emailTarget == "Patient"}) ?? []
        } else {
            emailTemplatesArrayEdit = viewModelEdit?.getMassEmailDetailDataEdit?.emailTemplateDTOList?.filter({$0.templateFor == "MassEmail"}) ?? []
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTemplatesArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedEmailTemplatesEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSEditCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectNetworkEmailTextLabel.text = "Please select network"
                    createCell.selectNetworkEmptyTextLabel.isHidden = false
                } else {
                    createCell.selectNetworkEmptyTextLabel.isHidden = true
                    createCell.selectNetworkEmailTextLabel.text = selectedItem?.name
                    self?.selectedEmailTemplatesEdit = selectedList
                    self?.selectedemailTemplateIdEdit = String(selectedItem?.id ?? 0)
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(emailTemplatesArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditDefaultCellDelegate {
    func nextButtonDefault(cell: MassEmailandSMSEditDefaultTableViewCell, index: IndexPath) {
        if cell.massEmailSMSTextField.text == "" {
            cell.massEmailSMSTextField.showError(message: "Please enter Mass Email or SMS name")
        } else {
            moduleNameEdit = cell.massEmailSMSTextField.text ?? String.blank
            cell.defaultNextButton.isEnabled = false
            createNewMassEmailSMSCell(cellNameType: "Module")
        }
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditModuleCellDelegate {
    func nextButtonModule(cell: MassEmailandSMSEditModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "patient" {
            smsEmailModuleSelectionTypeEdit = moduleType
            cell.moduleNextButton.isEnabled = false
            createNewMassEmailSMSCell(cellNameType: "Patient")
        } else if moduleType == "lead" {
            smsEmailModuleSelectionTypeEdit = moduleType
            cell.moduleNextButton.isEnabled = false
            createNewMassEmailSMSCell(cellNameType: "Lead")
        } else {
            smsEmailModuleSelectionTypeEdit = moduleType
            self.view.ShowSpinner()
            viewModelEdit?.getMassEmailLeadStatusAllMethodEdit()
        }
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditCreateCellDelegate {
    func nextButtonCreate(cell: MassEmailandSMSEditCreateTableViewCell, index: IndexPath, networkType: String) {
        if cell.networkTypeSelected == "sms" {
            if cell.selectNetworkSMSTextLabel.text == "Please select network" {
                cell.selectNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton(networkTypeSelected: networkType, cell: cell)
            }
        } else {
            if cell.selectNetworkEmailTextLabel.text == "Please select network" {
                cell.selectNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton(networkTypeSelected: networkType, cell: cell)
            }
        }
    }
    
    func setupNetworkNextButton(networkTypeSelected: String, cell: MassEmailandSMSEditCreateTableViewCell) {
        self.networkTypeSelectedEdit = networkTypeSelected
        cell.createNextButton.isEnabled = false
        createNewMassEmailSMSCell(cellNameType: "Time")
    }
    
    func smsButtonClick(cell: MassEmailandSMSEditCreateTableViewCell) {
        cell.smsEmailCountTextLabel.text = "SMS count: \(viewModelEdit?.getMassEmailSMSLeadCountDataEdit?.smsCount ?? 0)"
    }
    
    func emailButtonClick(cell: MassEmailandSMSEditCreateTableViewCell) {
        cell.smsEmailCountTextLabel.text = "Email count: \(String(viewModelEdit?.getMassEmailSMSLeadCountDataEdit?.emailCount ?? 0))"
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditLeadCellDelegate {
    func nextButtonLead(cell: MassEmailandSMSEditLeadActionTableViewCell, index: IndexPath) {
        if cell.leadStatusTextLabel.text == "Select lead status" {
            cell.leadStatusEmptyTextLabel.isHidden = false
        } else {
            cell.leadStatusEmptyTextLabel.isHidden = true
            cell.leadNextButton.isEnabled = false
            leadActionApiCallMethod(selectedCell: cell)
        }
    }
    
    func leadActionApiCallMethod(selectedCell: MassEmailandSMSEditLeadActionTableViewCell) {
        self.view.ShowSpinner()
        if selectedCell.leadSourceTextLabel.text ?? String.blank == "Select lead source" {
            leadSourceEdit = String.blank
        } else {
            leadSourceEdit = selectedCell.leadSourceTextLabel.text ?? String.blank
        }
        viewModelEdit?.getMassEmailLeadStatusMethodEdit(leadStatus: selectedCell.leadStatusTextLabel.text ?? String.blank, moduleName: "MassLead", leadTagIds: selectedLeadTagIdsEdit, source: leadSourceEdit)
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditPatientCellDelegate {
    func nextButtonPatient(cell: MassEmailandSMSEditPatientActionTableViewCell, index: IndexPath) {
        if cell.patientStatusTextLabel.text == "Select patient status" {
            cell.patientStatusEmptyTextLabel.isHidden = false
        } else {
            cell.patientStatusEmptyTextLabel.isHidden = true
            cell.patientNextButton.isEnabled = false
            patientActionApiCallMethod(selectedCell: cell)
        }
    }
    
    func patientActionApiCallMethod(selectedCell: MassEmailandSMSEditPatientActionTableViewCell) {
        self.view.ShowSpinner()
        if selectedCell.patientAppointmenTextLabel.text ?? String.blank == "Select appointment status" {
            patientAppointmentStatusEdit = String.blank
        } else {
            patientAppointmentStatusEdit = selectedCell.patientAppointmenTextLabel.text ?? String.blank
        }
        viewModelEdit?.getMassEmailPatientStatusMethodEdit(appointmentStatus: patientAppointmentStatusEdit, moduleName: "MassPatient", patientTagIds: selectedPatientTagIdsEdit, patientStatus: selectedCell.patientStatusTextLabel.text ?? String.blank)
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditTimeCellDelegate {
    func submitButtonTime(cell: MassEmailandSMSEditTimeTableViewCell, index: IndexPath) {
        self.view.ShowSpinner()
        if networkTypeSelectedEdit == "sms" {
            templateIdEdit = Int(selectedSmsTemplateIdEdit) ?? 0
        } else {
            templateIdEdit = Int(selectedemailTemplateIdEdit) ?? 0
        }
        
        if smsEmailModuleSelectionTypeEdit == "lead" {
            
            marketingTriggersDataEdit.append(MarketingTriggerDataEdit(actionIndex: 3, addNew: true, triggerTemplate: templateIdEdit, triggerType: networkTypeSelectedEdit.uppercased(), triggerTarget: "lead", scheduledDateTime: selectedTimeSlotEdit, triggerFrequency: "MIN", showBorder: false, orderOfCondition: 0, dateType: "NA"))
            
            let params = MarketingLeadModelEdit(name: moduleNameEdit, moduleName: "MassLead", triggerConditions: leadStatusSelectedEdit, leadTags: selectedLeadTagsEdit, patientTags: [], patientStatus: [], triggerData: marketingTriggersDataEdit, source: leadSourceSelectedEdit)
            
            let parameters: [String: Any]  = params.toDict()
            viewModelEdit?.postMassLeadDataMethodEdit(leadDataParms: parameters)
            
        } else if smsEmailModuleSelectionTypeEdit == "patient" {
   
            marketingTriggersDataEdit.append(MarketingTriggerDataEdit(actionIndex: 3, addNew: true, triggerTemplate: templateIdEdit, triggerType: networkTypeSelectedEdit.uppercased(), triggerTarget: "AppointmentPatient", scheduledDateTime: selectedTimeSlotEdit, triggerFrequency: "MIN", showBorder: false, orderOfCondition: 0, dateType: "NA"))
            
            let params = MarketingLeadModelEdit(name: moduleNameEdit, moduleName: "MassPatient", triggerConditions: appointmentStatusSelectedEdit, leadTags: [], patientTags: selectedPatientTagsEdit, patientStatus: paymentStatusSelectedEdit, triggerData: marketingTriggersDataEdit, source: [])
            let parameters: [String: Any]  = params.toDict()
            viewModelEdit?.postMassPatientDataMethodEdit(patientDataParms: parameters)
            
        } else {
            marketingTriggersDataEdit.append(MarketingTriggerDataEdit(actionIndex: 3, addNew: true, triggerTemplate: templateIdEdit, triggerType: networkTypeSelectedEdit.uppercased(), triggerTarget: "All", scheduledDateTime: selectedTimeSlotEdit, triggerFrequency: "MIN", showBorder: false, orderOfCondition: 0, dateType: "NA"))
            
            let params = MarketingLeadModelEdit(name: moduleNameEdit, moduleName: "All", triggerConditions: ["All"], leadTags: [], patientTags: [], patientStatus: [], triggerData: marketingTriggersDataEdit, source: [])
            let parameters: [String: Any]  = params.toDict()

            viewModelEdit?.postMassLeadPatientDataMethodEdit(leadPatientDataParms: parameters)
        }
    }
    
    func cancelButtonTime(cell: MassEmailandSMSEditTimeTableViewCell, index: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func massEmailTimeFromTapped(cell: MassEmailandSMSEditTimeTableViewCell) {
        guard let indexPath = emailAndSMSTableViewEdit.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSEditTimeTableViewCell {
            vacationCell.updateMassEmailTimeFromTextField(with: "\(viewModelEdit?.dateFormatterStringEdit(textField:  cell.massEmailTimeFromTextField) ?? "") \(viewModelEdit?.timeFormatterStringEdit(textField:  cell.massEmailTimeFromTextField) ?? "")")
            selectedTimeSlotEdit = viewModelEdit?.localInputToServerInputEdit(date: "\(viewModelEdit?.dateFormatterStringEdit(textField:  cell.massEmailTimeFromTextField) ?? "") \(viewModelEdit?.timeFormatterStringEdit(textField:  cell.massEmailTimeFromTextField) ?? "")") ?? String.blank
        }
    }
}
