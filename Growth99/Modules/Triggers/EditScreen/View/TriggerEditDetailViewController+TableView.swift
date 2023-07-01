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
        let cell = UITableViewCell()
        
        if triggerDetailList[indexPath.row].cellType == "Default" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerDefaultTableViewCell", for: indexPath) as? TriggerDefaultTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            moduleName = viewModel?.getTriggerEditListData?.name ?? ""
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerLeadEditActionTableViewCell", for: indexPath) as? TriggerLeadEditActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            
            cell.configureCell(tableView: triggerdDetailTableView, index: indexPath, triggerListEdit: triggerDetailList)
            cell.leadFromTextField.text = viewModel?.getTriggerEditListData?.triggerConditions?.joined(separator: ",")
            var landingArray = [EditLandingPageNamesModel]()
            var formArray = [EditLandingPageNamesModel]()
            var sourceUrlArray = [LeadSourceUrlListModel]()
            var ledTagArray = [MassEmailSMSTagListModelEdit]()
            
            if viewModel?.getTriggerEditListData?.landingPages?.count ?? 0 > 0 {
                for landingItem in viewModel?.getTriggerEditListData?.landingPages ?? [] {
                    let getLandingData = viewModel?.getLandingPageNamesDataEdit.filter({ $0.id == landingItem})
                    for landingChildItem in getLandingData ?? [] {
                        let landArr = EditLandingPageNamesModel(name: landingChildItem.name ?? "", id: landingChildItem.id ?? 0)
                        landingArray.append(landArr)
                    }
                }
                cell.leadSelectLandingTextField.text = landingArray.map({$0.name ?? ""}).joined(separator: ",")
                selectedLeadLandingPages = landingArray
                cell.showLeadSelectLanding(isShown: true)
            }
            
            if viewModel?.getTriggerEditListData?.forms?.count ?? 0 > 0 {
                for formsItem in viewModel?.getTriggerEditListData?.forms ?? [] {
                    let getLandingForm = viewModel?.getTriggerQuestionnairesDataEdit.filter({ $0.id == formsItem})
                    for landingChildItem in getLandingForm ?? [] {
                        let formArr = EditLandingPageNamesModel(name: landingChildItem.name ?? "", id: landingChildItem.id ?? 0)
                        formArray.append(formArr)
                    }
                }
                cell.leadLandingSelectFromTextField.text = formArray.map({$0.name ?? ""}).joined(separator: ",")
                selectedleadForms = formArray
                cell.showleadLandingSelectFrom(isShown: true)
            }
            
            if viewModel?.getTriggerEditListData?.sourceUrls?.count ?? 0 > 0 {
                for formsItem in viewModel?.getTriggerEditListData?.sourceUrls ?? [] {
                    let getLandingForm = viewModel?.getTriggerLeadSourceUrlDataEdit.filter({ $0.id == formsItem})
                    for landingChildItem in getLandingForm ?? [] {
                        let soureUrlArr = LeadSourceUrlListModel(sourceUrl: landingChildItem.sourceUrl ?? "", id: landingChildItem.id ?? 0)
                        sourceUrlArray.append(soureUrlArr)
                    }
                }
                cell.leadSelectSourceTextField.text = sourceUrlArray.map({$0.sourceUrl ?? ""}).joined(separator: ",")
                selectedLeadSourceUrl = sourceUrlArray
                cell.showleadSelectSource(isShown: true)
            }
            
            if viewModel?.getTriggerEditListData?.isTriggerForLeadStatus == true {
                cell.leadStatusChangeButton.isSelected = true
                isInitialStatusContain = viewModel?.getTriggerEditListData?.fromLeadStatus ?? ""
                isFinalStatusContain = viewModel?.getTriggerEditListData?.toLeadStatus ?? ""
                isTriggerForLeadContain = viewModel?.getTriggerEditListData?.isTriggerForLeadStatus ?? false
                cell.showLeadStatusChange(isShown: true)
                cell.leadInitialStatusTextField.text = viewModel?.getTriggerEditListData?.fromLeadStatus ?? ""
                cell.leadFinalStatusTextField.text = viewModel?.getTriggerEditListData?.toLeadStatus ?? ""
            }
            
            if viewModel?.getTriggerEditListData?.leadTags?.count ?? 0 > 0 {
                for formsItem in viewModel?.getTriggerEditListData?.leadTags ?? [] {
                    let getLandingForm = viewModel?.getTriggerLeadTagListDataEdit.filter({ $0.id == formsItem})
                    for landingChildItem in getLandingForm ?? [] {
                        let formArr = MassEmailSMSTagListModelEdit(name: landingChildItem.name ?? "", isDefault: landingChildItem.isDefault ?? false, id: landingChildItem.id ?? 0)
                        ledTagArray.append(formArr)
                    }
                }
                cell.leadTagTextField.text = ledTagArray.map({$0.name ?? ""}).joined(separator: ",")
                selectedLeadTags = ledTagArray
                cell.showleadTagButton.isSelected = true
                cell.showleadTagTectField(isShown: true)
            }
            
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Appointment" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerAppointmentActionTableViewCell", for: indexPath) as? TriggerAppointmentActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.patientAppointmentButton.addTarget(self, action: #selector(patientAppointmentMethod), for: .touchDown)
            cell.patientAppointmentButton.tag = indexPath.row
            cell.patientAppointmenTextLabel.text = viewModel?.getTriggerEditListData?.triggerActionName
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Both" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerParentCreateTableViewCell", for: indexPath) as? TriggerParentCreateTableViewCell else { return UITableViewCell()}
            
            
            for item in viewModel?.getTriggerEditListData?.triggerData ?? [] {
                let creatChild = TriggerEditData(id: item.id, timerType: item.timerType, triggerTarget: item.triggerTarget, triggerFrequency: item.triggerFrequency, actionIndex: item.actionIndex, dateType: item.dateType, triggerTime: item.triggerTime, showBorder: item.showBorder, userId: item.userId, scheduledDateTime: item.scheduledDateTime, triggerTemplate: item.triggerTemplate, addNew: item.addNew, endTime: item.endTime, triggerType: item.triggerType, taskName: item.taskName, startTime: item.endTime, orderOfCondition: item.orderOfCondition, type: "Create")
                
                let createTimechild =  TriggerEditData(id: item.id, timerType: item.timerType, triggerTarget: item.triggerTarget, triggerFrequency: item.triggerFrequency, actionIndex: item.actionIndex, dateType: item.dateType, triggerTime: item.triggerTime, showBorder: item.showBorder, userId: item.userId, scheduledDateTime: item.scheduledDateTime, triggerTemplate: item.triggerTemplate, addNew: item.addNew, endTime: item.endTime, triggerType: item.triggerType, taskName: item.taskName, startTime: item.startTime, orderOfCondition: item.orderOfCondition, type: "Time")
                finalArray.append(creatChild)
                finalArray.append(createTimechild)
                isTaskName = item.taskName ?? ""
            }
            cell.configureCell(triggerEditData: finalArray, index: indexPath, moduleSelectionTypeTrigger: moduleSelectionType, selectedNetworkType: selectedNetworkType, parentViewModel: viewModel, viewController: self)
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func patientAppointmentMethod(sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: appointmentStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
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
    
    @IBAction func submitButtonAction(sender: UIButton) {
        self.view.ShowSpinner()
        if moduleSelectionType == "lead" {
            if selectedTriggerTarget == "Leads" {
                selectedTriggerTarget = "lead"
            }
            if selectedNetworkType == "SMS" {
                templateId = Int(selectedSmsTemplateId) ?? 0
                triggersCreateData.append(TriggerEditCreateData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: selectedNetworkType.uppercased(), triggerTarget: selectedTriggerTarget , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: "", showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: "NA", timerType: timerTypeSelected, startTime: "", endTime: "", deadline: ""))
            } else if selectedNetworkType == "EMAIL" {
                templateId = Int(selectedemailTemplateId) ?? 0
                triggersCreateData.append(TriggerEditCreateData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: selectedNetworkType.uppercased(), triggerTarget: selectedTriggerTarget , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: "", showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: "NA", timerType: timerTypeSelected, startTime: "", endTime: "", deadline: ""))
            } else {
                triggersCreateData.append(TriggerEditCreateData(actionIndex: 3, addNew: false, triggerTemplate: selectedTaskTemplate, triggerType: selectedNetworkType.uppercased(), triggerTarget: "lead" , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: taskName, showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: "NA", timerType: timerTypeSelected, startTime: "", endTime: "", deadline: ""))
            }
            let params = TriggerEditCreateModel(name: moduleName, moduleName: "leads", triggeractionName: "Pending", triggerConditions: selectedLeadSources, triggerData: triggersCreateData, landingPageNames: selectedLeadLandingPages, forms: selectedleadForms, sourceUrls: [], leadTags: selectedLeadTags, isTriggerForLeadStatus: isTriggerForLeadContain, fromLeadStatus: isInitialStatusContain, toLeadStatus: isFinalStatusContain)
            let parameters: [String: Any]  = params.toDict()
            viewModel?.createTriggerDataMethodEdit(triggerDataParms: parameters, selectedTriggerid: triggerId ?? 0)
        } else {
            
            if selectedTriggerTarget == "Patient" {
                selectedTriggerTarget = "AppointmentPatient"
            } else {
                selectedTriggerTarget = "AppointmentClinic"
            }
            if selectedNetworkType == "SMS" {
                templateId = Int(selectedSmsTemplateId) ?? 0
                triggersAppointmentCreateData.append(TriggerEditAppointmentCreateData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: selectedNetworkType.uppercased(), triggerTarget: selectedTriggerTarget , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: "", showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: scheduledBasedOnSelected))
            } else {
                templateId = Int(selectedemailTemplateId) ?? 0
                triggersAppointmentCreateData.append(TriggerEditAppointmentCreateData(actionIndex: 3, addNew: true, triggerTemplate: templateId, triggerType: selectedNetworkType.uppercased(), triggerTarget: selectedTriggerTarget , triggerTime: selectedTriggerTime, triggerFrequency: selectedTriggerFrequency.uppercased(), taskName: "", showBorder: false, orderOfCondition: orderOfConditionTrigger, dateType: scheduledBasedOnSelected))
            }
            let params = TriggerEditAppointmentCreateModel(name: moduleName, moduleName: "Appointment", triggeractionName: appointmentSelectedStatus, triggerConditions: [], triggerData: triggersAppointmentCreateData, landingPageNames: [], forms: [], sourceUrls: [], leadTags: [], isTriggerForLeadStatus: false, fromLeadStatus: nil, toLeadStatus: nil)
            let parameters: [String: Any]  = params.toDict()
            viewModel?.createAppointmentDataMethodEdit(appointmentDataParms: parameters, selectedTriggerid: triggerId ?? 0)
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
            if triggerDetailList.count > 2 {
                triggerDetailList.removeSubrange(2..<triggerDetailList.count)
                finalArray.removeAll()
            }
            triggerdDetailTableView.reloadData()
        }
    }
}

extension TriggerEditDetailViewController: TriggerModuleCellDelegate {
    func nextButtonModule(cell: TriggerModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "appointment" {
            if triggerDetailList.count < 3 {
                moduleSelectionType = moduleType
                createNewTriggerCell(cellNameType: "Appointment")
                scrollToBottom()
            } else {
                triggerDetailList.removeSubrange(2..<triggerDetailList.count)
                triggerdDetailTableView.reloadData()
                moduleSelectionType = moduleType
                createNewTriggerCell(cellNameType: "Appointment")
            }
        } else if moduleType == "lead" {
            if triggerDetailList.count < 3 {
                moduleSelectionType = moduleType
                createNewTriggerCell(cellNameType: "Lead")
                scrollToBottom()
            } else {
                triggerDetailList.removeSubrange(2..<triggerDetailList.count)
                triggerdDetailTableView.reloadData()
                moduleSelectionType = moduleType
                createNewTriggerCell(cellNameType: "Lead")
            }
        }
    }
}

extension TriggerEditDetailViewController: TriggerLeadEdiTableViewCellDelegate {
    func nextButtonLead(cell: TriggerLeadEditActionTableViewCell, index: IndexPath) {
        if cell.leadFromTextField.text == "" {
            cell.leadFromTextField.showError(message: "Please select source")
        }
        else if isSelectLandingSelected == true && cell.leadSelectLandingTextField.text == "" {
            cell.leadSelectLandingTextField.showError(message: "Please select landing page")
        }
        else if isSelectFormsSelected == true && cell.leadLandingSelectFromTextField.text == "" {
            cell.leadLandingSelectFromTextField.showError(message: "Please select form")
        }
        else if isLeadStatusChangeSelected == true && isInitialStatusSelected == true && cell.leadInitialStatusTextField.text == "" {
            cell.leadInitialStatusTextField.showError(message: "Please select initial status")
        }
        else if isLeadStatusChangeSelected == true && isFinalStatusSelected == true && cell.leadFinalStatusTextField.text == "" {
            cell.leadFinalStatusTextField.showError(message: "Please select final status")
        }
        else {
            if triggerDetailList.count < 4 {
                isInitialStatusContain = cell.leadInitialStatusTextField.text ?? ""
                isFinalStatusContain = cell.leadFinalStatusTextField.text ?? ""
                isTriggerForLeadContain = cell.leadStatusChangeButton.isSelected
                scrollToBottom()
                createNewTriggerCell(cellNameType: "Both")
            }
        }
    }
    
    func leadFormButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: selectedLeadSources) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.leadFromTextField.showError(message: "Please select source")
                cell.leadFromTextField.text = ""
                self?.isSelectLandingSelected = false
                self?.isSelectFormsSelected = false
                self?.selectedLeadLandingPages.removeAll()
                self?.selectedleadForms.removeAll()
                self?.selectedLeadSourceUrl.removeAll()
                self?.selectedLeadSources.removeAll()
                cell.showLeadSelectLanding(isShown: false)
                cell.showleadLandingSelectFrom(isShown: false)
                cell.showleadSelectSource(isShown: false)
                
            } else {
                cell.leadFromTextField.text = selectedList.joined(separator: ",")
                self?.selectedLeadSources = selectedList
                if selectedList.joined(separator: ",").contains("Landing Page") &&
                    selectedList.joined(separator: ",").contains("Form") &&
                    selectedList.joined(separator: ",").contains("Facebook") {
                    self?.isSelectLandingSelected = true
                    self?.isSelectFormsSelected = true
                    cell.showLeadSelectLanding(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: true)
                    cell.showleadSelectSource(isShown: true)
                }
                else if selectedList.joined(separator: ",").contains("Landing Page") &&
                            selectedList.joined(separator: ",").contains("Form"){
                    self?.isSelectLandingSelected = true
                    self?.isSelectFormsSelected = true
                    self?.selectedLeadSourceUrl.removeAll()
                    cell.showLeadSelectLanding(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: true)
                    cell.showleadSelectSource(isShown: false)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Landing Page") &&
                            selectedList.joined(separator: ",").contains("Facebook") {
                    self?.isSelectLandingSelected = true
                    self?.isSelectFormsSelected = false
                    self?.selectedleadForms.removeAll()
                    cell.showLeadSelectLanding(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: false)
                    cell.showleadSelectSource(isShown: true)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Form") &&
                            selectedList.joined(separator: ",").contains("Facebook") {
                    self?.isSelectLandingSelected = false
                    self?.isSelectFormsSelected = true
                    self?.selectedLeadLandingPages.removeAll()
                    cell.showLeadSelectLanding(isShown: false)
                    cell.showleadSelectSource(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: true)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Landing Page") {
                    self?.isSelectLandingSelected = true
                    self?.isSelectFormsSelected = false
                    self?.selectedleadForms.removeAll()
                    self?.selectedLeadSourceUrl.removeAll()
                    cell.showLeadSelectLanding(isShown: true)
                    cell.showleadSelectSource(isShown: false)
                    cell.showleadLandingSelectFrom(isShown: false)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Form") {
                    self?.isSelectLandingSelected = false
                    self?.isSelectFormsSelected = true
                    self?.selectedLeadLandingPages.removeAll()
                    self?.selectedLeadSourceUrl.removeAll()
                    cell.showLeadSelectLanding(isShown: false)
                    cell.showleadSelectSource(isShown: false)
                    cell.showleadLandingSelectFrom(isShown: true)
                    self?.scrollToBottom()
                }
                else if selectedList.joined(separator: ",").contains("Facebook") {
                    self?.isSelectLandingSelected = false
                    self?.isSelectFormsSelected = false
                    self?.selectedLeadLandingPages.removeAll()
                    self?.selectedleadForms.removeAll()
                    cell.showLeadSelectLanding(isShown: false)
                    cell.showleadSelectSource(isShown: true)
                    cell.showleadLandingSelectFrom(isShown: false)
                    self?.scrollToBottom()
                } else {
                    self?.isSelectLandingSelected = false
                    self?.isSelectFormsSelected = false
                    self?.selectedLeadLandingPages.removeAll()
                    self?.selectedleadForms.removeAll()
                    self?.selectedLeadSourceUrl.removeAll()
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
        selectionMenu.setSelectedItems(items: selectedLeadLandingPages) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                self?.selectedLeadLandingPages.removeAll()
                cell.leadSelectLandingTextField.text = ""
                cell.leadSelectLandingTextField.showError(message: "Please select landing page")
            } else {
                self?.selectedLeadLandingPages = selectedList
                cell.leadSelectLandingTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ",")
                selectionMenu.dismiss()
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
        selectionMenu.setSelectedItems(items: selectedleadForms) { [weak self] (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                self?.selectedleadForms.removeAll()
                cell.leadLandingSelectFromTextField.text = ""
                cell.leadLandingSelectFromTextField.showError(message: "Please select form")
            } else {
                self?.selectedleadForms = selectedList
                cell.leadLandingSelectFromTextField.text =  selectedList.map({$0.name ?? String.blank}).joined(separator: ",")
                selectionMenu.dismiss()
            }
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
        selectionMenu.setSelectedItems(items: selectedLeadSourceUrl) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.selectedLeadSourceUrl = selectedList
            cell.leadSelectSourceTextField.text = selectedList.map({$0.sourceUrl ?? String.blank}).joined(separator: ",")
            selectionMenu.dismiss()
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
                selectionMenu.dismiss()
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
                selectionMenu.dismiss()
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
        selectionMenu.setSelectedItems(items: selectedLeadTags) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.leadTagTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedLeadTags = selectedList
            let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
            self?.selectedLeadTagIds = formattedArray
            selectionMenu.dismiss()
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
            self.selectedLeadTags.removeAll()
        } else {
            buttonSender.isSelected = true
            cell.leadTagTextFieldHight.constant = 45
            cell.leadTagTextField.rightImage = UIImage(named: "dropDown")
        }
        self.triggerdDetailTableView?.performBatchUpdates(nil, completion: nil)
        self.scrollToBottom()
    }
}

extension TriggerEditDetailViewController: TriggerPatientCellDelegate {
    func nextButtonPatient(cell: TriggerAppointmentActionTableViewCell, index: IndexPath) {
        appointmentSelectedStatus = cell.patientAppointmenTextLabel.text ?? ""
        createNewTriggerCell(cellNameType: "Both")
        scrollToBottom()
    }
}

extension TriggerEditDetailViewController: TriggerEditTimeCellDelegate {
    func hourlyNetworkButton(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
        let timeHourlyArray = ["Min", "Hour", "Day"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: timeHourlyArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { (selectedItem, index, selected, selectedList) in
            if selectedList.count == 0 {
                cell.timeHourlyTextField.showError(message: "Please enter time duration")
            } else {
                cell.timeHourlyTextField.text = selectedItem
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.timeHourlyButton, size: CGSize(width:  cell.timeHourlyButton.frame.width, height: (Double(timeHourlyArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func scheduledBasedOnButton(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
        let scheduledBasedOnArray = ["Appointment Created Date", "Before Appointment Date", "After Appointment Date"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: scheduledBasedOnArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { (selectedItem, index, selected, selectedList) in
            cell.scheduledBasedOnTextField.text = selectedItem
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: cell.scheduledBasedOnButton, size: CGSize(width: cell.scheduledBasedOnButton.frame.width, height: (Double(scheduledBasedOnArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func addAnotherConditionButton(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
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
                    finalArray.removeAll()
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
                finalArray.removeAll()
                scrollToBottom()
                createNewTriggerCell(cellNameType: "Both")
            }
        }
    }
    
    func nextBtnAction(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
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
    
    func buttontimeRangeStartTapped(cell: TriggerEditTimeTableViewCell) {
        cell.updateTimeRangeStartTextField(with: self.viewModel?.timeFormatterStringEdit(textField: cell.timeRangeStartTimeTF) ?? String.blank)
    }
    
    func buttontimeRangeEndTapped(cell: TriggerEditTimeTableViewCell) {
        cell.updateTimeRangeEndTextField(with: self.viewModel?.timeFormatterStringEdit(textField: cell.timeRangeEndTimeTF) ?? String.blank)
    }
}

extension TriggerEditDetailViewController: TriggerEditCreateCellDelegate {
    func nextButtonCreate(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, triggerNetworkType: String) {
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
                isTaskName = cell.taskNameTextField.text ?? ""
                isAssignedToTask = cell.assignTaskNetworkTextLabel.text ?? ""
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
    }
    
    /// set cell drop dwon action
    func smsTargetButton(cell: TriggerEditSMSCreateTableViewCell, index: IndexPath, sender: UIButton) {
        if moduleSelectionType == "lead" {
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
        if moduleSelectionType == "lead" && smsTargetType == "Leads" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.smsTarget == "Lead"}) ?? []
        } else if moduleSelectionType == "lead" && smsTargetType == "Clinic" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.smsTarget == "Clinic"}) ?? []
        } else if moduleSelectionType == "appointment" && smsTargetType == "Patient" {
            smsTemplatesArray = viewModel?.getTriggerDetailDataEdit?.smsTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.smsTarget == "Patient"}) ?? []
        } else if moduleSelectionType == "appointment" && smsTargetType == "Clinic" {
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
        if moduleSelectionType == "lead" {
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
        if moduleSelectionType == "lead" && emailTargetType == "Leads" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.emailTarget == "Lead"}) ?? []
        } else if moduleSelectionType == "lead" && emailTargetType == "Clinic" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Lead" && $0.emailTarget == "Clinic"}) ?? []
        } else if moduleSelectionType == "appointment" && emailTargetType == "Patient" {
            emailTemplatesArray = viewModel?.getTriggerDetailDataEdit?.emailTemplateDTOList?.filter({ $0.templateFor == "Appointment" && $0.emailTarget == "Patient"}) ?? []
        } else if moduleSelectionType == "appointment" && emailTargetType == "Clinic" {
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
