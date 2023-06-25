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
        return massSMSDetailListEdit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if massSMSDetailListEdit[indexPath.row].cellType == "Default" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditDefaultTableViewCell", for: indexPath) as? MassEmailandSMSEditDefaultTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            moduleNameEdit = viewModelEdit?.getMassSMSTriggerEditListData?.name ?? ""
            cell.massEmailSMSTextField.text = viewModelEdit?.getMassSMSTriggerEditListData?.name ?? ""
            return cell
        } else if massSMSDetailListEdit[indexPath.row].cellType == "Module" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditModuleTableViewCell", for: indexPath) as? MassEmailandSMSEditModuleTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            if defaultNextSelected != true {
                smsEmailModuleSelectionTypeEdit = cell.moduleTypeSelected
                if viewModelEdit?.getMassSMSTriggerEditListData?.moduleName == "MassLead" {
                    cell.leadBtn.isSelected = true
                    cell.patientBtn.isSelected = false
                    cell.bothBtn.isSelected = false
                } else if viewModelEdit?.getMassSMSTriggerEditListData?.moduleName == "MassPatient" {
                    cell.leadBtn.isSelected = false
                    cell.patientBtn.isSelected = true
                    cell.bothBtn.isSelected = false
                } else {
                    cell.leadBtn.isSelected = false
                    cell.patientBtn.isSelected = false
                    cell.bothBtn.isSelected = true
                }
            } else {
                smsEmailModuleSelectionTypeEdit = "lead"
                cell.moduleTypeSelected = "lead"
                cell.leadBtn.isSelected = true
                cell.patientBtn.isSelected = false
                cell.bothBtn.isSelected = false
            }
            return cell
        } else if massSMSDetailListEdit[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditLeadActionTableViewCell", for: indexPath) as? MassEmailandSMSEditLeadActionTableViewCell else { return UITableViewCell()}
            cell.configureCell(tableView: emailAndSMSTableViewEdit, index: indexPath)
            cell.delegate = self
            
            let leadStatusData = viewModelEdit?.getMassSMSTriggerEditListData?.triggerConditions ?? []
            cell.leadStatusTextField.text = leadStatusData.joined(separator: ",")
            leadStatusSelectedEdit = leadStatusData
            
            let leadSourceData = viewModelEdit?.getMassSMSTriggerEditListData?.source ?? []
            if leadSourceData.count > 0 {
                cell.showleadSourceButton.isSelected = true
                cell.leadSourceTextFieldHight.constant = 45
                cell.leadSourceTextField.rightImage = UIImage(named: "dropDown")
                cell.leadSourceTextField.text = leadSourceData.joined(separator: ",")
                leadSourceSelectedEdit = leadSourceData
            }
            if viewModelEdit?.getMassSMSTriggerEditListData?.leadTags?.count ?? 0 > 0 {
                var leadTagsArrayEdit = [MassEmailSMSTagListModelEdit]()
                for landingItem in viewModelEdit?.getMassSMSTriggerEditListData?.leadTags ?? [] {
                    let getLandingData = viewModelEdit?.getMassSMSEditLeadTagsListData?.filter({ $0.id == landingItem})
                    for landingChildItem in getLandingData ?? [] {
                        let landArr = MassEmailSMSTagListModelEdit(name: landingChildItem.name ?? "", isDefault:  landingChildItem.isDefault ?? false, id: landingChildItem.id ?? 0)
                        leadTagsArrayEdit.append(landArr)
                    }
                }
                cell.showleadTagButton.isSelected = true
                cell.leadTagTextFieldHight.constant = 45
                cell.leadTagTextField.rightImage = UIImage(named: "dropDown")
                cell.leadTagTextField.text = leadTagsArrayEdit.map({$0.name ?? ""}).joined(separator: ",")
                selectedLeadTagsEdit = leadTagsArrayEdit
            }
            
            return cell
        } else if massSMSDetailListEdit[indexPath.row].cellType == "Appointment" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditPatientActionTableViewCell", for: indexPath) as? MassEmailandSMSEditPatientActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.configureCell(tableView: emailAndSMSTableViewEdit, index: indexPath)
            let patientStatusData = viewModelEdit?.getMassSMSTriggerEditListData?.patientStatus ?? []
            cell.patientStatusTextField.text = patientStatusData.joined(separator: ",")
            paymentStatusSelectedEdit = patientStatusData
            
            if patientTypeSelected != true {
                let patientAppointmentStatusData = viewModelEdit?.getMassSMSTriggerEditListData?.triggerConditions ?? []
                if patientAppointmentStatusData.count > 0 {
                    cell.showPatientAppointmentStatusButton.isSelected = true
                    cell.patientAppointmentStatusTextFieldHight.constant = 45
                    cell.patientAppointmentStatusTextField.rightImage = UIImage(named: "dropDown")
                    cell.patientAppointmentStatusTextField.text = patientAppointmentStatusData.joined(separator: ",")
                    appointmentStatusSelectedEdit = patientAppointmentStatusData
                }
            }
            
            if viewModelEdit?.getMassSMSTriggerEditListData?.patientTags?.count ?? 0 > 0 {
                var patientTagsArrayEdit = [MassEmailSMSTagListModelEdit]()
                for landingItem in viewModelEdit?.getMassSMSTriggerEditListData?.patientTags ?? [] {
                    let getLandingData = viewModelEdit?.getMassSMSEditPateintsTagsListData?.filter({ $0.id == landingItem})
                    for landingChildItem in getLandingData ?? [] {
                        let landArr = MassEmailSMSTagListModelEdit(name: landingChildItem.name ?? "", isDefault:  landingChildItem.isDefault ?? false, id: landingChildItem.id ?? 0)
                        patientTagsArrayEdit.append(landArr)
                    }
                }
                cell.showPatientTagButton.isSelected = true
                cell.patientTagTextFieldHight.constant = 45
                cell.patientTagTextField.rightImage = UIImage(named: "dropDown")
                cell.patientTagTextField.text = patientTagsArrayEdit.map({$0.name ?? ""}).joined(separator: ",")
                selectedPatientTagsEdit = patientTagsArrayEdit
            }
            
            return cell
        } else if massSMSDetailListEdit[indexPath.row].cellType == "Both" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditCreateTableViewCell", for: indexPath) as? MassEmailandSMSEditCreateTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            if smsEmailModuleSelectionTypeEdit == "both" {
                if cell.smsBtn.isSelected {
                    let leadSMSCount = viewModelEdit?.getMassSMSEditAllLeadCountData?.smsCount ?? 0
                    let patientSMSCount = viewModelEdit?.getMassSMSEditAllPatientCountData?.smsCount ?? 0
                    let totalSMSCount = leadSMSCount + patientSMSCount
                    cell.smsEmailCountLabel.text = "SMS count: \(totalSMSCount)"
                } else {
                    let leadEmailCount = viewModelEdit?.getMassSMSEditAllLeadCountData?.emailCount ?? 0
                    let patientEmailCount = viewModelEdit?.getMassSMSEditAllPatientCountData?.emailCount ?? 0
                    let totalEmailCount = leadEmailCount + patientEmailCount
                    cell.smsEmailCountLabel.text = "Email count: \(totalEmailCount)"
                }
            } else if smsEmailModuleSelectionTypeEdit == "lead"{
                if cell.smsBtn.isSelected {
                    let smsLeadCount = viewModelEdit?.getMassSMSEditLeadCountData?.smsCount ?? 0
                    cell.smsEmailCountLabel.text = "SMS count: \(smsLeadCount)"
                } else {
                    let emailLeadCount = viewModelEdit?.getMassSMSEditLeadCountData?.emailCount ?? 0
                    cell.smsEmailCountLabel.text = "Email count: \(emailLeadCount)"
                }
            } else {
                if cell.smsBtn.isSelected {
                    let smsPatientCount = viewModelEdit?.getMassSMSEditPatientCountData?.smsCount ?? 0
                    cell.smsEmailCountLabel.text = "SMS count: \(smsPatientCount)"
                } else {
                    let emailPatientCount = viewModelEdit?.getMassSMSEditPatientCountData?.emailCount ?? 0
                    cell.smsEmailCountLabel.text = "Email count: \(emailPatientCount)"
                }
            }
            
            if viewModelEdit?.getMassSMSTriggerEditListData?.executionStatus == "COMPLETED" || viewModelEdit?.getMassSMSTriggerEditListData?.executionStatus == "FAILED" {
                cell.smsEmailCountLabel.isHidden = true
            } else {
                cell.smsEmailCountLabel.isHidden = false
            }
            
            if viewModelEdit?.getMassSMSTriggerEditListData?.triggerData?[0].triggerType == "SMS" {
                cell.smsBtn.isSelected = true
                cell.emailBtn.isSelected = false
                networkTypeSelectedEdit = "sms"
                selectedSmsTemplateIdEdit = viewModelEdit?.getMassSMSTriggerEditListData?.triggerData?[0].triggerTemplate ?? 0
                let selectedSMSTemplate = viewModelEdit?.getMassEmailEditDetailData?.smsTemplateDTOList ?? []
                let selectEmailNetworkName = selectedSMSTemplate.filter({ $0.id == viewModelEdit?.getMassSMSTriggerEditListData?.triggerData?[0].triggerTemplate ?? 0})
                if selectEmailNetworkName.count > 0 {
                    cell.selectNetworkTextField.text = selectEmailNetworkName[0].name ?? String.blank
                } else {
                    cell.selectNetworkTextField.text = ""
                }
            } else {
                networkTypeSelectedEdit = "email"
                cell.smsBtn.isSelected = false
                cell.emailBtn.isSelected = true
                selectedemailTemplateIdEdit = viewModelEdit?.getMassSMSTriggerEditListData?.triggerData?[0].triggerTemplate ?? 0
                let selectedEmailTemplate = viewModelEdit?.getMassEmailEditDetailData?.emailTemplateDTOList ?? []
                let selectEmailNetworkName = selectedEmailTemplate.filter({ $0.id == viewModelEdit?.getMassSMSTriggerEditListData?.triggerData?[0].triggerTemplate ?? 0})
                if selectEmailNetworkName.count > 0 {
                    cell.selectNetworkTextField.text = selectEmailNetworkName[0].name ?? String.blank
                } else {
                    cell.selectNetworkTextField.text = ""
                }
            }
            return cell
        } else if massSMSDetailListEdit[indexPath.row].cellType == "Time" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSEditTimeTableViewCell", for: indexPath) as? MassEmailandSMSEditTimeTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            let dateTrigger = "\(viewModelEdit?.convertDateFormat(dateString: viewModelEdit?.getMassSMSTriggerEditListData?.triggerData?[0].scheduledDateTime ?? "") ?? "")"
            let timeTrigger = "\(viewModelEdit?.convertTimeFormat(dateString: viewModelEdit?.getMassSMSTriggerEditListData?.triggerData?[0].scheduledDateTime ?? "") ?? "")"
            
            cell.updateMassEmailDateTextField(with: dateTrigger)
            cell.updateMassEmailTimeTextField(with: timeTrigger)
            selectedTimeSlotEdit = viewModelEdit?.localInputToServerInputEdit(date: dateTrigger + timeTrigger) ?? ""
            cell.configureCell(massSMSTriggerEditListData: viewModelEdit?.getMassSMSTriggerEditListData, tableView: emailAndSMSTableViewEdit, index: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.massSMSDetailListEdit.count-1, section: 0)
            self.emailAndSMSTableViewEdit.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditDefaultCellDelegate {
    func nextButtonDefault(cell: MassEmailandSMSEditDefaultTableViewCell, index: IndexPath) {
        if cell.massEmailSMSTextField.text == "" {
            cell.massEmailSMSTextField.showError(message: "Please enter Mass Email or SMS name")
        } else {
            moduleNameEdit = cell.massEmailSMSTextField.text ?? String.blank
            if massSMSDetailListEdit.count > 2 {
                massSMSDetailListEdit.removeSubrange(2..<massSMSDetailListEdit.count)
            }
            defaultNextSelected = true
            emailAndSMSTableViewEdit.reloadData()
        }
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditModuleCellDelegate {
    func leadButtonModule(cell: MassEmailandSMSEditModuleTableViewCell, index: IndexPath, moduleType: String) {
        let hasLead = massSMSDetailListEdit.contains(where: { $0.cellType == "Lead" })
        if !hasLead {
            DispatchQueue.main.async {
                self.emailAndSMSTableViewEdit.beginUpdates()
                if self.massSMSDetailListEdit.count > 2 {
                    let indexPathsToDelete = (2..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                    self.massSMSDetailListEdit.removeSubrange(2..<self.massSMSDetailListEdit.count)
                    self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                }
                self.leadTypeSelected = true
                self.smsEmailModuleSelectionTypeEdit = moduleType
                self.emailAndSMSTableViewEdit.endUpdates()
            }
        }
    }
    
    func patientButtonModule(cell: MassEmailandSMSEditModuleTableViewCell, index: IndexPath, moduleType: String) {
        let hasPatient = massSMSDetailListEdit.contains(where: { $0.cellType == "Appointment" })
        if !hasPatient {
            DispatchQueue.main.async {
                self.emailAndSMSTableViewEdit.beginUpdates()
                if self.massSMSDetailListEdit.count > 2 {
                    let indexPathsToDelete = (2..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                    self.massSMSDetailListEdit.removeSubrange(2..<self.massSMSDetailListEdit.count)
                    self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                }
                self.patientTypeSelected = true
                self.smsEmailModuleSelectionTypeEdit = moduleType
                self.emailAndSMSTableViewEdit.endUpdates()
            }
        }
    }
    
    func bothButtonModule(cell: MassEmailandSMSEditModuleTableViewCell, index: IndexPath, moduleType: String) {
        let hasBoth = massSMSDetailListEdit.contains(where: { $0.cellType == "Both" })
        if  hasBoth {
            DispatchQueue.main.async {
                self.emailAndSMSTableViewEdit.beginUpdates()
                if self.massSMSDetailListEdit.count > 2 {
                    let indexPathsToDelete = (2..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                    self.massSMSDetailListEdit.removeSubrange(2..<self.massSMSDetailListEdit.count)
                    self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                }
                self.leadPatientBothSelected = true
                self.smsEmailModuleSelectionTypeEdit = moduleType
                self.emailAndSMSTableViewEdit.endUpdates()
            }
        }
    }
    
    func nextButtonModule(cell: MassEmailandSMSEditModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "patient" {
            let hasPatient = massSMSDetailListEdit.contains(where: { $0.cellType == "Appointment" })
            if !hasPatient {
                DispatchQueue.main.async {
                    self.emailAndSMSTableViewEdit.beginUpdates()
                    
                    if self.massSMSDetailListEdit.count > 2 {
                        let indexPathsToDelete = (2..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                        self.massSMSDetailListEdit.removeSubrange(2..<self.massSMSDetailListEdit.count)
                        self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                    }
                    self.smsEmailModuleSelectionTypeEdit = moduleType
                    let emailSMS = MassEmailandSMSDetailModelEdit(cellType: "Appointment", LastName: "")
                    self.massSMSDetailListEdit.append(emailSMS)
                    let indexPathToInsert = IndexPath(row: self.massSMSDetailListEdit.count - 1, section: 0)
                    self.emailAndSMSTableViewEdit.insertRows(at: [indexPathToInsert], with: .fade)
                    self.emailAndSMSTableViewEdit.endUpdates()
                    self.scrollToBottom()
                }
            }
        } else if moduleType == "lead" {
            let hasLead = massSMSDetailListEdit.contains(where: { $0.cellType == "Lead" })
            if !hasLead {
                DispatchQueue.main.async {
                    self.emailAndSMSTableViewEdit.beginUpdates()
                    
                    if self.massSMSDetailListEdit.count > 2 {
                        let indexPathsToDelete = (2..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                        self.massSMSDetailListEdit.removeSubrange(2..<self.massSMSDetailListEdit.count)
                        self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                    }
                    
                    self.smsEmailModuleSelectionTypeEdit = moduleType
                    let emailSMS = MassEmailandSMSDetailModelEdit(cellType: "Lead", LastName: "")
                    self.massSMSDetailListEdit.append(emailSMS)
                    
                    let indexPathToInsert = IndexPath(row: self.massSMSDetailListEdit.count - 1, section: 0)
                    self.emailAndSMSTableViewEdit.insertRows(at: [indexPathToInsert], with: .fade)
                    
                    self.emailAndSMSTableViewEdit.endUpdates()
                    self.scrollToBottom()
                }
            }
        } else {
            let hasBoth = massSMSDetailListEdit.contains(where: { $0.cellType == "Both" })
            if !hasBoth {
                DispatchQueue.main.async {
                    self.emailAndSMSTableViewEdit.beginUpdates()
                    
                    if self.massSMSDetailListEdit.count > 2 {
                        let indexPathsToDelete = (2..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                        self.massSMSDetailListEdit.removeSubrange(2..<self.massSMSDetailListEdit.count)
                        self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                    }
                    
                    self.smsEmailModuleSelectionTypeEdit = moduleType
                    self.view.ShowSpinner()
                    self.viewModelEdit?.getMassSMSEditAllLeadMethod()
                    let emailSMS = MassEmailandSMSDetailModelEdit(cellType: "Both", LastName: "")
                    self.massSMSDetailListEdit.append(emailSMS)
                    let indexPathToInsert = IndexPath(row: self.massSMSDetailListEdit.count - 1, section: 0)
                    self.emailAndSMSTableViewEdit.insertRows(at: [indexPathToInsert], with: .fade)
                    
                    self.emailAndSMSTableViewEdit.endUpdates()
                    
                    self.scrollToBottom()
                }
            }
        }
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditLeadCellDelegate {
    func leadStausButtonSelection(cell: MassEmailandSMSEditLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let leadStatusArray = ["NEW", "COLD", "WARM", "HOT", "WON","DEAD"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: leadStatusSelectedEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.leadStatusSelectedEdit = selectedList
            cell.leadStatusTextField.text = selectedList.joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadSourceButtonSelection(cell: MassEmailandSMSEditLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: leadSourceSelectedEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.leadSourceSelectedEdit = selectedList
            cell.leadSourceTextField.text = selectedList.joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadSourceArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadTagButtonSelection(cell: MassEmailandSMSEditLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        leadTagsArrayEdit = viewModelEdit?.getMassSMSEditLeadTagsListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadTagsArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: selectedLeadTagsEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.leadTagTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedLeadTagsEdit  = selectedList
            let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
            self?.selectedLeadTagIdsEdit = formattedArray
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadTagsArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    func nextButtonLead(cell: MassEmailandSMSEditLeadActionTableViewCell, index: IndexPath) {
        if cell.leadStatusTextField.text == "" {
            cell.leadStatusTextField.showError(message: "Please select lead status")
        } else {
            if massSMSDetailListEdit.count < 4 {
                self.view.ShowSpinner()
                viewModelEdit?.getMassSMSEditLeadCountsMethod(leadStatus: cell.leadStatusTextField.text ?? String.blank, moduleName: "MassLead", leadTagIds: selectedLeadTagIdsEdit, source: cell.leadSourceTextField.text ?? String.blank)
            }
        }
    }
    
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditPatientCellDelegate {
    func patientStausButtonSelection(cell: MassEmailandSMSEditPatientActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let leadStatusArray = ["NEW", "EXISTING"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: paymentStatusSelectedEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.paymentStatusSelectedEdit = selectedList
            cell.patientStatusTextField.text = selectedList.joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func patientTagButtonSelection(cell: MassEmailandSMSEditPatientActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        patientTagsArrayEdit = viewModelEdit?.getMassSMSEditPateintsTagsListData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: patientTagsArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: selectedPatientTagsEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.patientTagTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedPatientTagsEdit = selectedList
            let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
            self?.selectedPatientTagIdsEdit = formattedArray
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(patientTagsArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    func patientAppointmentStatusTagBtnSelection(cell: MassEmailandSMSEditPatientActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: appointmentStatusArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: appointmentStatusSelectedEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.appointmentStatusSelectedEdit = selectedList
            cell.patientAppointmentStatusTextField.text = selectedList.joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(appointmentStatusArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    func nextButtonPatient(cell: MassEmailandSMSEditPatientActionTableViewCell, index: IndexPath) {
        if cell.patientStatusTextField.text == "" {
            cell.patientStatusTextField.showError(message: "Select patient status")
        } else {
            if massSMSDetailListEdit.count < 4 {
                viewModelEdit?.getMassSMSEditPatientCountMethod(appointmentStatus: patientAppointmentStatusEdit, moduleName: "MassPatient", patientTagIds: selectedPatientTagIdsEdit, patientStatus: cell.patientStatusTextField.text ?? String.blank)
            }
        }
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditCreateCellDelegate {
    func smsNetworkButtonSelected(cell: MassEmailandSMSEditCreateTableViewCell, index: IndexPath, buttonSender: UIButton, networkType: String) {
        if smsEmailModuleSelectionTypeEdit == "lead" {
            let filteredArray = viewModelEdit?.getMassEmailEditDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "MassSMS" && $0.smsTarget == "Lead"})
            smsTemplatesArrayEdit = filteredArray ?? []
        } else if smsEmailModuleSelectionTypeEdit == "patient" {
            let filteredArray = viewModelEdit?.getMassEmailEditDetailData?.smsTemplateDTOList?.filter({ $0.templateFor == "MassSMS" && $0.smsTarget == "Patient"})
            smsTemplatesArrayEdit = filteredArray ?? []
        } else {
            let filteredArray = viewModelEdit?.getMassEmailEditDetailData?.smsTemplateDTOList?.filter({$0.templateFor == "MassSMS"})
            smsTemplatesArrayEdit = filteredArray ?? []
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: smsTemplatesArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: selectedSmsTemplatesEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.selectNetworkTextField.text = selectedItem?.name
            self?.selectedSmsTemplatesEdit = selectedList
            self?.selectedSmsTemplateIdEdit = selectedItem?.id ?? 0
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(smsTemplatesArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    func emailNetworkButtonSelected(cell: MassEmailandSMSEditCreateTableViewCell, index: IndexPath, buttonSender: UIButton, networkType: String) {
        if smsEmailModuleSelectionTypeEdit == "lead" {
            var filteredArray = viewModelEdit?.getMassEmailEditDetailData?.emailTemplateDTOList ?? []
            filteredArray = filteredArray.filter({ $0.templateFor == "MassEmail" && $0.emailTarget == "Lead" })
            emailTemplatesArrayEdit = filteredArray
        } else if smsEmailModuleSelectionTypeEdit == "patient" {
            var filteredArray = viewModelEdit?.getMassEmailEditDetailData?.emailTemplateDTOList ?? []
            filteredArray = filteredArray.filter({ $0.templateFor == "MassEmail" && $0.emailTarget == "Patient" })
            emailTemplatesArrayEdit = filteredArray
        } else {
            var filteredArray = viewModelEdit?.getMassEmailEditDetailData?.emailTemplateDTOList ?? []
            filteredArray = filteredArray.filter({ $0.templateFor == "MassEmail" })
            emailTemplatesArrayEdit = filteredArray
        }
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: emailTemplatesArrayEdit, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: selectedEmailTemplatesEdit) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.selectNetworkTextField.text = selectedItem?.name
            self?.selectedEmailTemplatesEdit = selectedList
            self?.selectedemailTemplateIdEdit = selectedItem?.id ?? 0
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(emailTemplatesArrayEdit.count * 30))), arrowDirection: .up), from: self)
    }
    
    func nextButtonCreate(cell: MassEmailandSMSEditCreateTableViewCell, index: IndexPath, networkType: String) {
        if cell.selectNetworkTextField.text == "" {
            cell.selectNetworkTextField.showError(message: "Please select network")
        } else {
            if self.smsEmailModuleSelectionTypeEdit == "both" {
                if massSMSDetailListEdit.count < 4 {
                    self.networkTypeSelectedEdit = networkType
                    createNewMassEmailSMSCell(cellNameType: "Time")
                    scrollToBottom()
                }
            } else {
                if massSMSDetailListEdit.count < 5 {
                    self.networkTypeSelectedEdit = networkType
                    createNewMassEmailSMSCell(cellNameType: "Time")
                    scrollToBottom()
                }
            }
        }
    }
    
    func smsButtonClick(cell: MassEmailandSMSEditCreateTableViewCell) {
        let hasTime = massSMSDetailListEdit.contains(where: { $0.cellType == "Time" })
        if  hasTime {
            DispatchQueue.main.async {
                self.emailAndSMSTableViewEdit.beginUpdates()
                if self.smsEmailModuleSelectionTypeEdit == "both" {
                    if self.massSMSDetailListEdit.count > 3 {
                        let indexPathsToDelete = (3..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                        self.massSMSDetailListEdit.removeSubrange(3..<self.massSMSDetailListEdit.count)
                        self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                    }
                } else {
                    if self.massSMSDetailListEdit.count > 4 {
                        let indexPathsToDelete = (4..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                        self.massSMSDetailListEdit.removeSubrange(4..<self.massSMSDetailListEdit.count)
                        self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                    }
                }
                
                if self.smsEmailModuleSelectionTypeEdit == "both" {
                    let leadSMSCount = self.viewModelEdit?.getMassSMSEditAllLeadCountData?.smsCount ?? 0
                    let patientSMSCount = self.viewModelEdit?.getMassSMSEditAllPatientCountData?.smsCount ?? 0
                    let totalSMSCount = leadSMSCount + patientSMSCount
                    cell.smsEmailCountLabel.text = "SMS count: \(totalSMSCount)"
                } else if self.smsEmailModuleSelectionTypeEdit == "lead"{
                    let smsLeadCount = self.viewModelEdit?.getMassSMSEditLeadCountData?.smsCount ?? 0
                    cell.smsEmailCountLabel.text = "SMS count: \(smsLeadCount)"
                } else {
                    let smsPatientCount = self.viewModelEdit?.getMassSMSEditPatientCountData?.smsCount ?? 0
                    cell.smsEmailCountLabel.text = "SMS count: \(smsPatientCount)"
                }
                self.emailAndSMSTableViewEdit.endUpdates()
            }
        }
    }
    
    func emailButtonClick(cell: MassEmailandSMSEditCreateTableViewCell) {
        
        let hasTime = massSMSDetailListEdit.contains(where: { $0.cellType == "Time" })
        if  hasTime {
            DispatchQueue.main.async {
                self.emailAndSMSTableViewEdit.beginUpdates()
                if self.smsEmailModuleSelectionTypeEdit == "both" {
                    if self.massSMSDetailListEdit.count > 3 {
                        let indexPathsToDelete = (3..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                        self.massSMSDetailListEdit.removeSubrange(3..<self.massSMSDetailListEdit.count)
                        self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                    }
                } else {
                    if self.massSMSDetailListEdit.count > 4 {
                        let indexPathsToDelete = (4..<self.massSMSDetailListEdit.count).map { IndexPath(row: $0, section: 0) }
                        self.massSMSDetailListEdit.removeSubrange(4..<self.massSMSDetailListEdit.count)
                        self.emailAndSMSTableViewEdit.deleteRows(at: indexPathsToDelete, with: .fade)
                    }
                }
                if self.smsEmailModuleSelectionTypeEdit == "both" {
                    let leadEmailCount = self.viewModelEdit?.getMassSMSEditAllLeadCountData?.emailCount ?? 0
                    let patientEmailCount = self.viewModelEdit?.getMassSMSEditAllPatientCountData?.emailCount ?? 0
                    let totalEmailCount = leadEmailCount + patientEmailCount
                    cell.smsEmailCountLabel.text = "Email count: \(totalEmailCount)"
                } else if self.smsEmailModuleSelectionTypeEdit == "lead"{
                    let emailLeadCount = self.viewModelEdit?.getMassSMSEditLeadCountData?.emailCount ?? 0
                    cell.smsEmailCountLabel.text = "Email count: \(emailLeadCount)"
                } else {
                    let emailPatientCount = self.viewModelEdit?.getMassSMSEditPatientCountData?.emailCount ?? 0
                    cell.smsEmailCountLabel.text = "Email count: \(emailPatientCount)"
                }
                self.emailAndSMSTableViewEdit.endUpdates()
            }
        }
    }
}

extension MassEmailandSMSEditDetailViewController: MassEmailandSMSEditTimeCellDelegate {
    func submitButtonTime(cell: MassEmailandSMSEditTimeTableViewCell, index: IndexPath) {
        self.view.ShowSpinner()
        if networkTypeSelectedEdit == "sms" {
            templateIdEdit = selectedSmsTemplateIdEdit
        } else {
            templateIdEdit = selectedemailTemplateIdEdit
        }
        let cellIndexPath = IndexPath(item: 0, section: 0)
        if let defaultCell = self.emailAndSMSTableViewEdit.cellForRow(at: cellIndexPath) as? MassEmailandSMSDefaultTableViewCell {
            moduleNameEdit = defaultCell.massEmailSMSTextField.text ?? ""
        }
        if smsEmailModuleSelectionTypeEdit == "lead" {
            marketingTriggersDataEdit.append(MarketingTriggerDataEdit(actionIndex: 3, addNew: true, triggerTemplate: templateIdEdit, triggerType: networkTypeSelectedEdit.uppercased(), triggerTarget: "lead", scheduledDateTime: selectedTimeSlotEdit , triggerFrequency: "MIN", showBorder: false, orderOfCondition: 0, dateType: "NA"))
            
            let params = MarketingLeadModelEdit(name: moduleNameEdit, moduleName: "MassLead", triggerConditions: leadStatusSelectedEdit, leadTags: selectedLeadTagsEdit, patientTags: [], patientStatus: [], triggerData: marketingTriggersDataEdit, source: leadSourceSelectedEdit)
            let parameters: [String: Any]  = params.toDict()
            viewModelEdit?.editMassSMSLeadDataMethod(selectedMassSMSId: massSMStriggerId ?? 0, leadDataParms: parameters)
            
        } else if smsEmailModuleSelectionTypeEdit == "patient" {
            marketingTriggersDataEdit.append(MarketingTriggerDataEdit(actionIndex: 3, addNew: true, triggerTemplate: templateIdEdit, triggerType: networkTypeSelectedEdit.uppercased(), triggerTarget: "AppointmentPatient", scheduledDateTime: selectedTimeSlotEdit , triggerFrequency: "MIN", showBorder: false, orderOfCondition: 0, dateType: "NA"))
            
            let params = MarketingLeadModelEdit(name: moduleNameEdit, moduleName: "MassPatient", triggerConditions: appointmentStatusSelectedEdit, leadTags: [], patientTags: selectedPatientTagsEdit, patientStatus: paymentStatusSelectedEdit, triggerData: marketingTriggersDataEdit, source: [])
            let parameters: [String: Any]  = params.toDict()
            viewModelEdit?.editMassSMSPatientDataMethod(selectedMassSMSId: massSMStriggerId ?? 0, patientDataParms: parameters)
            
        } else {
            marketingTriggersDataEdit.append(MarketingTriggerDataEdit(actionIndex: 3, addNew: true, triggerTemplate: templateIdEdit, triggerType: networkTypeSelectedEdit.uppercased(), triggerTarget: "All", scheduledDateTime: selectedTimeSlotEdit , triggerFrequency: "MIN", showBorder: false, orderOfCondition: 0, dateType: "NA"))
            
            let params = MarketingLeadModelEdit(name: moduleNameEdit, moduleName: "All", triggerConditions: ["All"], leadTags: [], patientTags: [], patientStatus: [], triggerData: marketingTriggersDataEdit, source: [])
            let parameters: [String: Any]  = params.toDict()
            viewModelEdit?.editMassSMSLeadPatientDataMethod(selectedMassSMSId: massSMStriggerId ?? 0, leadPatientDataParms: parameters)
        }
    }
    
    func cancelButtonTime(cell: MassEmailandSMSEditTimeTableViewCell, index: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func massSMSDateSelectionTapped(cell: MassEmailandSMSEditTimeTableViewCell) {
        cell.updateMassEmailDateTextField(with: "\(viewModelEdit?.dateFormatterStringEdit(textField:  cell.massSMSTriggerDateTextField) ?? "")")
        selectedTimeSlotEdit = viewModelEdit?.localInputToServerInputEdit(date: "\(viewModelEdit?.dateFormatterStringEdit(textField:  cell.massSMSTriggerDateTextField) ?? "") \(viewModelEdit?.timeFormatterStringEdit(textField:  cell.massSMSTriggerTimeTextField) ?? "")") ?? String.blank
        scrollToBottom()
    }
    
    func massSMSTimeSelectionTapped(cell: MassEmailandSMSEditTimeTableViewCell) {
        cell.updateMassEmailTimeTextField(with: "\(viewModelEdit?.timeFormatterStringEdit(textField:  cell.massSMSTriggerTimeTextField) ?? "")")
        selectedTimeSlotEdit = viewModelEdit?.localInputToServerInputEdit(date: "\(viewModelEdit?.dateFormatterStringEdit(textField:  cell.massSMSTriggerDateTextField) ?? "") \(viewModelEdit?.timeFormatterStringEdit(textField:  cell.massSMSTriggerTimeTextField) ?? "")") ?? String.blank
        scrollToBottom()
    }
}
