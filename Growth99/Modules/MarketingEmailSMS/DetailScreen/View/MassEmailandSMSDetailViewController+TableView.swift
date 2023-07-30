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
            moduleName = cell.massEmailSMSTextField.text ?? String.blank
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Module" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSModuleTableViewCell", for: indexPath) as? MassEmailandSMSModuleTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            smsEmailModuleSelectionType = cell.moduleTypeSelected
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSLeadActionTableViewCell", for: indexPath) as? MassEmailandSMSLeadActionTableViewCell else { return UITableViewCell()}
            cell.configureCell(tableView: emailAndSMSTableView, index: indexPath)
            cell.delegate = self
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Patient" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSPatientActionTableViewCell", for: indexPath) as? MassEmailandSMSPatientActionTableViewCell else { return UITableViewCell()}
            cell.configureCell(tableView: emailAndSMSTableView, index: indexPath)
            cell.delegate = self
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Both" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSCreateTableViewCell", for: indexPath) as? MassEmailandSMSCreateTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            networkTypeSelected = cell.networkTypeSelected
            cell.networkSelectonSMSButton.tag = indexPath.row
            cell.networkSelectonSMSButton.addTarget(self, action: #selector(networkSelectionSMSMethod), for: .touchDown)
            if cell.smsBtn.isSelected {
                if smsEmailModuleSelectionType == "patient" {
                    cell.smsEmailCountTextLabel.text = "SMS count: \(viewModel?.getMassEmailSMSPatientCountData?.smsCount ?? 0)"
                } else if smsEmailModuleSelectionType == "lead" {
                    cell.smsEmailCountTextLabel.text = "SMS count: \(viewModel?.getMassEmailSMSLeadCountData?.smsCount ?? 0)"
                } else {
                    let smsCount = (viewModel?.getmassEmailSMSLeadAllCountData?.smsCount ?? 0) + (viewModel?.getmassEmailSMSPatientsAllCountData?.smsCount ?? 0)
                    cell.smsEmailCountTextLabel.text = "SMS count: \(smsCount)"
                }
                cell.noEmailQuotaLabel.isHidden = true
                cell.createNextButton.backgroundColor = UIColor.init(hexString: "009EDE")
            } else {
                
                if smsEmailModuleSelectionType == "patient" {
                    cell.smsEmailCountTextLabel.text = "Email count: \(viewModel?.getMassEmailSMSPatientCountData?.emailCount ?? 0)"
                } else if smsEmailModuleSelectionType == "lead" {
                    cell.smsEmailCountTextLabel.text = "Email count: \(viewModel?.getMassEmailSMSLeadCountData?.emailCount ?? 0)"
                } else {
                    let emailCount = (viewModel?.getmassEmailSMSLeadAllCountData?.emailCount ?? 0) + (viewModel?.getmassEmailSMSPatientsAllCountData?.emailCount ?? 0)
                    cell.smsEmailCountTextLabel.text = "Email count: \(emailCount)"
                }
                if isResultPositive() {
                    cell.noEmailQuotaLabel.isHidden = true
                    cell.createNextButton.isEnabled = true
                    cell.createNextButton.backgroundColor = UIColor.init(hexString: "009EDE")
                } else {
                    cell.noEmailQuotaLabel.isHidden = false
                    cell.createNextButton.isEnabled = false
                    cell.createNextButton.backgroundColor = UIColor.init(hexString: "86BFE5")
                }
            }
            cell.networkSelectonEmailButton.tag = indexPath.row
            cell.networkSelectonEmailButton.addTarget(self, action: #selector(networkSelectionEmailMethod), for: .touchDown)
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Time" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSTimeTableViewCell", for: indexPath) as? MassEmailandSMSTimeTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .medium
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.string(from: currentDate)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            let timeString = timeFormatter.string(from: currentDate)
            let dateTrigger = dateString
            let timeTrigger = timeString
            
            cell.updateMassEmailDateTextField(with: dateTrigger)
            cell.updateMassEmailTimeTextField(with: timeTrigger)
            cell.configureCell(tableView: emailAndSMSTableView, index: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func networkSelectionSMSMethod(sender: UIButton) {
        if smsEmailModuleSelectionType == "lead" {
            smsTemplatesArray = viewModel?.getMassEmailDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "MassSMS" && $0.smsTarget == "Lead"}) ?? []
        } else if smsEmailModuleSelectionType == "patient" {
            smsTemplatesArray = viewModel?.getMassEmailDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "MassSMS" && $0.smsTarget == "Patient"}) ?? []
        }  else {
            smsTemplatesArray = viewModel?.getMassEmailDetailData?.smsTemplateDTOList?.filter({$0.templateFor == "MassSMS"}) ?? []
        }
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedSmsTemplates) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectNetworkSMSTextLabel.text = "Please select network"
                    createCell.selectNetworkEmptyTextLabel.isHidden = false
                } else {
                    createCell.selectNetworkEmptyTextLabel.isHidden = true
                    createCell.selectNetworkSMSTextLabel.text = selectedItem?.name
                    self?.selectedSmsTemplates = selectedList
                    self?.selectedSmsTemplateId = selectedItem?.id ?? 0
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(smsTemplatesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func networkSelectionEmailMethod(sender: UIButton) {
        if smsEmailModuleSelectionType == "lead" {
            emailTemplatesArray = viewModel?.getMassEmailDetailData?.emailTemplateDTOList?.filter({ $0.templateFor == "MassEmail" && $0.emailTarget == "Lead"}) ?? []
        } else if smsEmailModuleSelectionType == "patient" {
            emailTemplatesArray = viewModel?.getMassEmailDetailData?.emailTemplateDTOList?.filter({ $0.templateFor == "MassEmail" && $0.emailTarget == "Patient"}) ?? []
        } else {
            emailTemplatesArray = viewModel?.getMassEmailDetailData?.emailTemplateDTOList?.filter({$0.templateFor == "MassEmail"}) ?? []
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTemplatesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: selectedEmailTemplates) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let createCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSCreateTableViewCell {
                if selectedList.count == 0 {
                    createCell.selectNetworkEmailTextLabel.text = "Please select network"
                    createCell.selectNetworkEmptyTextLabel.isHidden = false
                } else {
                    createCell.selectNetworkEmptyTextLabel.isHidden = true
                    createCell.selectNetworkEmailTextLabel.text = selectedItem?.name
                    self?.selectedEmailTemplates = selectedList
                    self?.selectedemailTemplateId = selectedItem?.id ?? 0
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(emailTemplatesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.emailAndSMSDetailList.count-1, section: 0)
            self.emailAndSMSTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSDefaultCellDelegate {
    func nextButtonDefault(cell: MassEmailandSMSDefaultTableViewCell, index: IndexPath) {
        if cell.massEmailSMSTextField.text == "" {
            cell.massEmailSMSTextField.showError(message: "Please enter Mass Email or SMS name")
        } else {
            moduleName = cell.massEmailSMSTextField.text ?? String.blank
            cell.defaultNextButton.isEnabled = false
            cell.massEmailSMSTextField.isUserInteractionEnabled = false
            createNewMassEmailSMSCell(cellNameType: "Module")
        }
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSModuleCellDelegate {
    func nextButtonModule(cell: MassEmailandSMSModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "patient" {
            smsEmailModuleSelectionType = moduleType
            cell.moduleNextButton.isEnabled = false
            cell.leadBtn.isUserInteractionEnabled = false
            cell.patientBtn.isUserInteractionEnabled = false
            cell.bothBtn.isUserInteractionEnabled = false
            createNewMassEmailSMSCell(cellNameType: "Patient")
            self.scrollToBottom()
        } else if moduleType == "lead" {
            smsEmailModuleSelectionType = moduleType
            cell.moduleNextButton.isEnabled = false
            cell.leadBtn.isUserInteractionEnabled = false
            cell.patientBtn.isUserInteractionEnabled = false
            cell.bothBtn.isUserInteractionEnabled = false
            createNewMassEmailSMSCell(cellNameType: "Lead")
            self.scrollToBottom()
        } else {
            smsEmailModuleSelectionType = moduleType
            cell.moduleNextButton.isEnabled = false
            cell.leadBtn.isUserInteractionEnabled = false
            cell.patientBtn.isUserInteractionEnabled = false
            cell.bothBtn.isUserInteractionEnabled = false
            self.view.ShowSpinner()
            viewModel?.getMassEmailLeadStatusAllMethod()
            self.scrollToBottom()
        }
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSLeadCellDelegate {
    func leadStausButtonSelection(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let leadStatusArray = ["NEW", "COLD", "WARM", "HOT", "WON","DEAD"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: leadStatusSelected) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.leadStatusSelected = selectedList
            cell.leadStatusTextField.text = selectedList.joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadSourceButtonSelection(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: leadSourceSelected) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.leadSourceSelected = selectedList
            cell.leadSourceTextField.text = selectedList.joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadSourceArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadTagButtonSelection(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        leadTagsArray = viewModel?.getMassEmailLeadTagsData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadTagsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: selectedLeadTags) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.leadTagTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedLeadTags  = selectedList
            let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
            self?.selectedLeadTagIds = formattedArray
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadTagsArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func nextButtonLead(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath) {
        if cell.leadStatusTextField.text == "" {
            cell.leadStatusTextField.showError(message: "Please select lead status")
        } else {
            self.view.ShowSpinner()
            viewModel?.getMassEmailLeadStatusMethod(leadStatus: cell.leadStatusTextField.text ?? String.blank, moduleName: "MassLead", leadTagIds: selectedLeadTagIds, source: leadSource)
            cell.leadNextButton.isEnabled = false
            cell.leadStatusTextField.isUserInteractionEnabled = false
            cell.leadSourceTextField.isUserInteractionEnabled = false
            cell.leadTagTextField.isUserInteractionEnabled = false
            cell.leadStatusButton.isUserInteractionEnabled = false
            cell.showleadSourceButton.isUserInteractionEnabled = false
            cell.showleadTagButton.isUserInteractionEnabled = false
        }
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSPatientCellDelegate {
    func patientStausButtonSelection(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let leadStatusArray = ["NEW", "EXISTING"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: paymentStatusSelected) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.paymentStatusSelected = selectedList
            cell.patientStatusTextField.text = selectedList.joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func patientTagButtonSelection(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        patientTagsArray = viewModel?.getMassEmailPateintsTagsData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: patientTagsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: selectedPatientTags) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.patientTagTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedPatientTags = selectedList
            let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
            self?.selectedPatientTagIds = formattedArray
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(patientTagsArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func patientAppointmentStatusTagBtnSelection(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: appointmentStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: appointmentStatusSelected) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.appointmentStatusSelected = selectedList
            cell.patientAppointmentStatusTextField.text = selectedList.joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(appointmentStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func nextButtonPatient(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath) {
        if cell.patientStatusTextField.text == "" {
            cell.patientStatusTextField.showError(message: "Please select patient status")
        } else {
            self.view.ShowSpinner()
            viewModel?.getMassEmailPatientStatusMethod(appointmentStatus: patientAppointmentStatus, moduleName: "MassPatient", patientTagIds: selectedPatientTagIds, patientStatus: cell.patientStatusTextField.text ?? String.blank)
            cell.patientNextButton.isEnabled = false
            cell.patientStatusTextField.isUserInteractionEnabled = false
            cell.patientTagTextField.isUserInteractionEnabled = false
            cell.patientAppointmentStatusTextField.isUserInteractionEnabled = false
            cell.patientStatusButton.isUserInteractionEnabled = false
            cell.patientTagButton.isUserInteractionEnabled = false
            cell.patientAppointmentStatusButton.isUserInteractionEnabled = false
        }
    }
}


extension MassEmailandSMSDetailViewController: MassEmailandSMSCreateCellDelegate {
    func nextButtonCreate(cell: MassEmailandSMSCreateTableViewCell, index: IndexPath, networkType: String) {
        if cell.networkTypeSelected == "sms" {
            if cell.selectNetworkSMSTextLabel.text == "Please select network" {
                cell.selectNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton(networkTypeSelected: networkType, cell: cell)
                cell.createNextButton.isEnabled = false
                cell.networkSelectonSMSButton.isUserInteractionEnabled = false
                cell.smsBtn.isUserInteractionEnabled = false
                cell.emailBtn.isUserInteractionEnabled = false
            }
        } else {
            if cell.selectNetworkEmailTextLabel.text == "Please select network" {
                cell.selectNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton(networkTypeSelected: networkType, cell: cell)
                cell.createNextButton.isEnabled = false
                cell.networkSelectonEmailButton.isUserInteractionEnabled = false
                cell.smsBtn.isUserInteractionEnabled = false
                cell.emailBtn.isUserInteractionEnabled = false
            }
        }
    }
    
    func setupNetworkNextButton(networkTypeSelected: String, cell: MassEmailandSMSCreateTableViewCell) {
        self.networkTypeSelected = networkTypeSelected
        cell.createNextButton.isEnabled = false
        createNewMassEmailSMSCell(cellNameType: "Time")
        self.scrollToBottom()
    }
    
    func smsButtonClick(cell: MassEmailandSMSCreateTableViewCell) {
        cell.noEmailQuotaLabel.isHidden = true
        cell.createNextButton.isEnabled = true
        cell.createNextButton.backgroundColor = UIColor.init(hexString: "009EDE")
        if smsEmailModuleSelectionType == "patient" {
            cell.smsEmailCountTextLabel.text = "SMS count: \(viewModel?.getMassEmailSMSPatientCountData?.smsCount ?? 0)"
        } else if smsEmailModuleSelectionType == "lead" {
            cell.smsEmailCountTextLabel.text = "SMS count: \(viewModel?.getMassEmailSMSLeadCountData?.smsCount ?? 0)"
        } else {
            let smsCount = (viewModel?.getmassEmailSMSLeadAllCountData?.smsCount ?? 0) + (viewModel?.getmassEmailSMSPatientsAllCountData?.smsCount ?? 0)
            cell.smsEmailCountTextLabel.text = "SMS count: \(smsCount)"
        }
    }
    
    func emailButtonClick(cell: MassEmailandSMSCreateTableViewCell) {
        
        if isResultPositive() {
            cell.noEmailQuotaLabel.isHidden = true
            cell.createNextButton.isEnabled = true
            cell.createNextButton.backgroundColor = UIColor.init(hexString: "009EDE")
        } else {
            cell.noEmailQuotaLabel.isHidden = false
            cell.createNextButton.isEnabled = false
            cell.createNextButton.backgroundColor = UIColor.init(hexString: "86BFE5")
        }

        if smsEmailModuleSelectionType == "patient" {
            cell.smsEmailCountTextLabel.text = "Email count: \(String(viewModel?.getMassEmailSMSPatientCountData?.emailCount ?? 0))"
        } else if smsEmailModuleSelectionType == "lead" {
            cell.smsEmailCountTextLabel.text = "Email count: \(String(viewModel?.getMassEmailSMSLeadCountData?.emailCount ?? 0))"
        } else {
            let emailCount = (viewModel?.getmassEmailSMSLeadAllCountData?.emailCount ?? 0) + (viewModel?.getmassEmailSMSPatientsAllCountData?.emailCount ?? 0)
            cell.smsEmailCountTextLabel.text = "Email count: \(emailCount)"
        }
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSTimeCellDelegate {
    func submitButtonTime(cell: MassEmailandSMSTimeTableViewCell, index: IndexPath) {
        if cell.massSMSTriggerDateTextField.text == "" {
            cell.massSMSTriggerDateTextField.showError(message: "Please select trigger date")
        } else if cell.massSMSTriggerTimeTextField.text == "" {
            cell.massSMSTriggerTimeTextField.showError(message: "Please select trigger time")
        } else {
            self.view.ShowSpinner()
            if networkTypeSelected == "sms" {
                templateId = selectedSmsTemplateId
            } else {
                templateId = selectedemailTemplateId
            }
            let cellIndexPath = IndexPath(item: 0, section: 0)
            if let defaultCell = self.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSDefaultTableViewCell {
                moduleName = defaultCell.massEmailSMSTextField.text ?? ""
            }
            if smsEmailModuleSelectionType == "lead" {
                marketingTriggersData.append(MarketingTriggerData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: networkTypeSelected.uppercased(), triggerTarget: "lead", scheduledDateTime: selectedTimeSlot , triggerFrequency: "MIN", showBorder: false, orderOfCondition: 0, dateType: "NA"))
                
                let params = MarketingLeadModel(name: moduleName, moduleName: "MassLead", triggerConditions: leadStatusSelected, leadTags: selectedLeadTags, patientTags: [], patientStatus: [], triggerData: marketingTriggersData, source: leadSourceSelected)
                let parameters: [String: Any]  = params.toDict()
                viewModel?.postMassLeadDataMethod(leadDataParms: parameters)
                
            } else if smsEmailModuleSelectionType == "patient" {
                marketingTriggersData.append(MarketingTriggerData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: networkTypeSelected.uppercased(), triggerTarget: "AppointmentPatient", scheduledDateTime: selectedTimeSlot , triggerFrequency: "MIN", showBorder: false, orderOfCondition: 0, dateType: "NA"))
                
                let params = MarketingLeadModel(name: moduleName, moduleName: "MassPatient", triggerConditions: appointmentStatusSelected, leadTags: [], patientTags: selectedPatientTags, patientStatus: paymentStatusSelected, triggerData: marketingTriggersData, source: [])
                let parameters: [String: Any]  = params.toDict()
                viewModel?.postMassPatientDataMethod(patientDataParms: parameters)
                
            } else {
                marketingTriggersData.append(MarketingTriggerData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: networkTypeSelected.uppercased(), triggerTarget: "All", scheduledDateTime: selectedTimeSlot , triggerFrequency: "MIN", showBorder: false, orderOfCondition: 0, dateType: "NA"))
                
                let params = MarketingLeadModel(name: moduleName, moduleName: "All", triggerConditions: ["All"], leadTags: [], patientTags: [], patientStatus: [], triggerData: marketingTriggersData, source: [])
                let parameters: [String: Any]  = params.toDict()
                viewModel?.postMassLeadPatientDataMethod(leadPatientDataParms: parameters)
            }
        }
    }
    
    func cancelButtonTime(cell: MassEmailandSMSTimeTableViewCell, index: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func massSMSDateSelectionTapped(cell: MassEmailandSMSTimeTableViewCell) {
        cell.updateMassEmailDateTextField(with: "\(viewModel?.dateFormatterString(textField:  cell.massSMSTriggerDateTextField) ?? "")")
        scrollToBottom()
    }
    
    func massSMSTimeSelectionTapped(cell: MassEmailandSMSTimeTableViewCell) {
        cell.updateMassEmailTimeTextField(with: "\(viewModel?.timeFormatterString(textField:  cell.massSMSTriggerTimeTextField) ?? "")")
        let dateTrigger = cell.massSMSTriggerDateTextField.text ?? ""
        let timeTrigger = cell.massSMSTriggerTimeTextField.text ?? ""
        let str: String = (dateTrigger) + " " + (timeTrigger)
        selectedTimeSlot = convertDateString(inputDateString: str)
        scrollToBottom()
    }
    
    func convertDateString(inputDateString: String) -> String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        outputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputDateFormatter.timeZone = TimeZone.current
        if let date = inputDateFormatter.date(from: inputDateString) {
            let outputDateString = outputDateFormatter.string(from: date)
            return outputDateString
        } else {
            return "Invalid date format"
        }
    }
}
