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
            cell.configureCell(tableView: triggerdDetailTableView, index: indexPath, triggerListDetail: triggerDetailList)
            return cell
        } else if triggerDetailList[indexPath.row].cellType == "Appointment" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TriggerAppointmentActionTableViewCell", for: indexPath) as? TriggerAppointmentActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.patientAppointmentButton.addTarget(self, action: #selector(patientAppointmentMethod), for: .touchDown)
            cell.patientAppointmentButton.tag = indexPath.row
            cell.patientAppointmenTextLabel.text = appointmentStatusArray[0]
            cell.configureCell(index: indexPath)
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
            cell.configureCell(index: indexPath)
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
    
    @objc func patientAppointmentMethod(sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: appointmentStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
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
        taskUserListArray = viewModel?.getTriggerDetailData?.userDTOList ?? []
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
        self.smsandTimeArray = []
        
        if moduleSelectionType == "lead" {
            if selectedTriggerTarget == "Leads" {
                selectedTriggerTarget = "leads"
            }
            var triggerDataDict = [String: Any]()
            var isfromLeadStatus: String = ""
            var istoLeadStatus: String = ""
            var isTriggerForLeadContain: Bool = false
            var isModuleSelectionType: String = ""
            
            for index in 0..<(self.triggerDetailList.count) {

                let cellIndexPath = IndexPath(row: index, section: 0)
                var templateId: Int = 0
                let triggerDetailList = self.triggerDetailList[cellIndexPath.row]
                if selectedNetworkType == "SMS" {
                    templateId = Int(selectedSmsTemplateId) ?? 0
                } else if selectedNetworkType == "EMAIL" {
                    templateId = Int(selectedemailTemplateId) ?? 0
                } else {
                    templateId = selectedTaskTemplate
                }
                if triggerDetailList.cellType == "Default" {
                    guard let defaultCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerDefaultTableViewCell else { return  }
                    moduleName = defaultCreateCell.massEmailSMSTextField.text ?? String.blank
                } else if triggerDetailList.cellType == "Module" {
                    guard let moduleCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerModuleTableViewCell else { return  }
                    isModuleSelectionType = moduleCreateCell.moduleTypeSelected
                } else if triggerDetailList.cellType == "Lead" {
                    guard let leadCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadActionTableViewCell else { return  }
                    isfromLeadStatus = leadCreateCell.leadInitialStatusTextField.text ?? ""
                    istoLeadStatus = leadCreateCell.leadFinalStatusTextField.text ?? ""
                    isTriggerForLeadContain = leadCreateCell.leadStatusChangeButton.isSelected
                } else if triggerDetailList.cellType == "Both" {
                    guard let bothCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell else { return  }
                    triggerDataDict = ["actionIndex": 3,
                                       "addNew": true,
                                       "triggerTemplate": templateId,
                                       "triggerType": bothCreateCell.networkTypeSelected.uppercased(),
                                       "triggerTarget": isModuleSelectionType,
                                       "taskName": bothCreateCell.taskNameTextField.text ?? ""
                    ]
                    
                }else if triggerDetailList.cellType == "Time" {
                    guard let timeCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell else { return  }
                    if timeCell.timeHourlyTextField.text == "" {
                        isTriggerFrequency = "Min"
                    } else {
                        isTriggerFrequency = timeCell.timeHourlyTextField.text ?? ""
                    }
                    
                    let startTimeTrigegr = timeCell.timeRangeStartTimeTF.text ?? ""
                    let endTimeTrigegr = timeCell.timeRangeEndTimeTF.text ?? ""
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let formattedDate = dateFormatter.string(from: currentDate)
                    let dateStartStr: String = (formattedDate) + " " + (startTimeTrigegr)
                    let dateEndStr: String = (formattedDate) + " " + (endTimeTrigegr)
                    let scheduleStartDate = (dateFormater?.convertDateStringToStringTrigger(dateString: dateStartStr)) ?? ""
                    let scheduleEndDate = (dateFormater?.convertDateStringToStringTrigger(dateString: dateEndStr)) ?? ""
                    
                    if self.triggerDetailList.count == 4 {
                        orderOfConditionTrigger = 0
                    } else if self.triggerDetailList.count == 6 {
                        orderOfConditionTrigger = orderOfConditionTrigger + 1
                    } else {
                        orderOfConditionTrigger = orderOfConditionTrigger + 2
                    }
                    
                    let timeDict: [String : Any] = [
                        "showBorder": false,
                        "orderOfCondition": orderOfConditionTrigger,
                        "dateType": "NA",
                        "startTime": scheduleStartDate,
                        "endTime": scheduleEndDate,
                        "triggerFrequency": isTriggerFrequency.uppercased(),
                        "triggerTime": Int(timeCell.timeDurationTextField.text ?? "0") ?? 0,
                        "timerType": timeCell.timerTypeSelected
                    ]
                    triggerDataDict.merge(withDictionary: timeDict)
                    self.createTriggerInfo(triggerCreateData: triggerDataDict)
                }
            }
            
            var selectedLeadLandingPagesdict = Array<Any>()
            for item in selectedLeadLandingPages {
                let param: [String: Any] = ["name": item.name ?? "", "id": item.id ?? 0]
                selectedLeadLandingPagesdict.append(param)
            }
            
            var selectedLeadSourceUrldict = Array<Any>()
            for item in selectedLeadSourceUrl {
                let param: [String: Any] = ["sourceUrl": item.sourceUrl ?? "", "id": item.id ?? 0]
                selectedLeadSourceUrldict.append(param)
            }
            
            var selectedleadFormsdict = Array<Any>()
            for item in selectedleadForms {
                let param: [String: Any] = ["name": item.name ?? "", "id": item.id ?? 0]
                selectedleadFormsdict.append(param)
            }
            
            var urlParameter: Parameters = [String: Any]()
            if isfromLeadStatus == "" && istoLeadStatus == "" {
                urlParameter = ["name": moduleName, "moduleName": "leads", "triggeractionName": "Pending", "triggerConditions": selectedLeadSources, "triggerData": smsandTimeArray, "landingPageNames": selectedLeadLandingPagesdict, "forms": selectedleadFormsdict, "sourceUrls": selectedLeadSourceUrldict, "leadTags": [], "isTriggerForLeadStatus": isTriggerForLeadContain, "fromLeadStatus": NSNull(), "toLeadStatus": NSNull()
                ]
            } else {
                urlParameter = ["name": moduleName, "moduleName": "leads", "triggeractionName": "Pending", "triggerConditions": selectedLeadSources, "triggerData": smsandTimeArray, "landingPageNames": selectedLeadLandingPagesdict, "forms": selectedleadFormsdict, "sourceUrls": selectedLeadSourceUrldict, "leadTags": [], "isTriggerForLeadStatus": isTriggerForLeadContain, "fromLeadStatus": isfromLeadStatus, "toLeadStatus": istoLeadStatus
                ]
            }
            print(urlParameter)
            self.view.ShowSpinner()
            viewModel?.createTriggerDataMethod(triggerDataParms: urlParameter)
        } else {
            if selectedTriggerTarget == "Patient" {
                selectedTriggerTarget = "AppointmentPatient"
            } else {
                selectedTriggerTarget = "AppointmentClinic"
            }
            
            var triggerDataDictAppointment = [String: Any]()
            var isModuleSelectionTypeAppointment: String = ""
            
            for index in 0..<(self.triggerDetailList.count) {
                let cellIndexPath = IndexPath(row: index, section: 0)
                var templateId: Int = 0
                let triggerDetailList = self.triggerDetailList[cellIndexPath.row]
                if selectedNetworkType == "SMS" {
                    templateId = Int(selectedSmsTemplateId) ?? 0
                } else {
                    templateId = Int(selectedemailTemplateId) ?? 0
                }
                
                if self.triggerDetailList.count == 4 {
                    orderOfConditionTrigger = 0
                } else if self.triggerDetailList.count == 6 {
                    orderOfConditionTrigger = orderOfConditionTrigger + 1
                } else {
                    orderOfConditionTrigger = orderOfConditionTrigger + 2
                }
                
                if triggerDetailList.cellType == "Default" {
                    guard let defaultCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerDefaultTableViewCell else { return  }
                    moduleName = defaultCreateCell.massEmailSMSTextField.text ?? String.blank
                } else if triggerDetailList.cellType == "Module" {
                    guard let moduleCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerModuleTableViewCell else { return  }
                    isModuleSelectionTypeAppointment = moduleCreateCell.moduleTypeSelected
                } else if triggerDetailList.cellType == "Appointment" {
                    guard let leadCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerAppointmentActionTableViewCell else { return  }
                } else if triggerDetailList.cellType == "Both" {
                    guard let bothCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerSMSCreateTableViewCell else { return  }
                    triggerDataDictAppointment = ["actionIndex": 3,
                                                  "addNew": true,
                                                  "triggerTemplate": templateId,
                                                  "triggerType": bothCreateCell.networkTypeSelected.uppercased(),
                                                  "triggerTarget": selectedTriggerTarget,
                                                  "taskName": bothCreateCell.taskNameTextField.text ?? ""
                    ]
                    
                } else if triggerDetailList.cellType == "Time" {
                    guard let timeCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell else { return  }
                    let isTriggerFrequency = timeCell.timeHourlyTextField.text ?? ""
                    let timeDict: [String : Any] = [
                        "showBorder": false,
                        "orderOfCondition": orderOfConditionTrigger,
                        "dateType": scheduledBasedOnSelected,
                        "startTime": timeCell.timeRangeStartTimeTF.text ?? "",
                        "endTime": timeCell.timeRangeEndTimeTF.text ?? "",
                        "triggerFrequency": isTriggerFrequency.uppercased(),
                        "triggerTime": Int(timeCell.timeDurationTextField.text ?? "0") ?? 0,
                        "timerType": timeCell.timerTypeSelected
                    ]
                    triggerDataDictAppointment.merge(withDictionary: timeDict)
                    self.createTriggerInfo(triggerCreateData: triggerDataDictAppointment)
                }
            }
            
            var urlParameter: Parameters = [String: Any]()
            urlParameter = ["name": moduleName, "moduleName": "Appointment", "triggeractionName": appointmentSelectedStatus, "triggerConditions": [], "triggerData": smsandTimeArray, "landingPageNames": [], "forms": [], "sourceUrls": [], "leadTags": NSNull(), "isTriggerForLeadStatus": false, "fromLeadStatus": NSNull(), "toLeadStatus": NSNull()
            ]
            print(urlParameter)
            self.view.ShowSpinner()
            viewModel?.createAppointmentDataMethod(appointmentDataParms: urlParameter)
        }
    }
    
    func createTriggerInfo(triggerCreateData: [String: Any]) {
        smsandTimeArray.append(triggerCreateData)
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

extension TriggerDetailViewController: TriggerDefaultCellDelegate {
    func nextButtonDefault(cell: TriggerDefaultTableViewCell, index: IndexPath) {
        if cell.massEmailSMSTextField.text == "" {
            cell.massEmailSMSTextField.showError(message: "Please enter trigger name")
        } else {
            cell.moduleNextButton.isEnabled = false
            createNewTriggerCell(cellNameType: "Module")
        }
    }
}

extension TriggerDetailViewController: TriggerModuleCellDelegate {
    func nextButtonModule(cell: TriggerModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "appointment" {
            moduleSelectionType = moduleType
            cell.leadBtn.isUserInteractionEnabled = false
            cell.patientBtn.isUserInteractionEnabled = false
            cell.nextButton.isEnabled = false
            createNewTriggerCell(cellNameType: "Appointment")
        } else if moduleType == "lead" {
            moduleSelectionType = moduleType
            cell.leadBtn.isUserInteractionEnabled = false
            cell.patientBtn.isUserInteractionEnabled = false
            cell.nextButton.isEnabled = false
            createNewTriggerCell(cellNameType: "Lead")
        }
        scrollToBottom()
    }
}


extension TriggerDetailViewController: TriggerLeadTableViewCellDelegate {
    func nextButtonLead(cell: TriggerLeadActionTableViewCell, index: IndexPath) {
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
    
    func leadFormButtonSelection(cell: TriggerLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
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
                    self?.scrollToBottom()
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
    
    func leadLandingButtonSelection(cell: TriggerLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        leadLandingPagesArray = viewModel?.getLandingPageNamesData ?? []
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
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadLandingPagesArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadSelectFormsButtonSelection(cell: TriggerLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        leadFormsArray = viewModel?.getTriggerQuestionnairesData ?? []
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
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadFormsArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadSourceButtonSelection(cell: TriggerLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
        leadSourceUrlArray = viewModel?.getTriggerLeadSourceUrlData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceUrlArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.sourceUrl
        }
        selectionMenu.setSelectedItems(items: selectedLeadSourceUrl) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.selectedLeadSourceUrl = selectedList
            cell.leadSelectSourceTextField.text = selectedList.map({$0.sourceUrl ?? String.blank}).joined(separator: ",")
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: buttonSender, size: CGSize(width: buttonSender.frame.width, height: (Double(leadSourceUrlArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    func leadInitialStatusButtonSelection(cell: TriggerLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
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
    
    func leadFinalStatusButtonSelection(cell: TriggerLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton) {
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
}

extension TriggerDetailViewController: TriggerPatientCellDelegate {
    func nextButtonPatient(cell: TriggerAppointmentActionTableViewCell, index: IndexPath) {
        scrollToBottom()
        cell.appointmentNextButton.isEnabled = false
        appointmentSelectedStatus = cell.patientAppointmenTextLabel.text ?? ""
        createNewTriggerCell(cellNameType: "Both")
    }
}

extension TriggerDetailViewController: TriggerCreateCellDelegate {
    func nextButtonCreate(cell: TriggerSMSCreateTableViewCell, index: IndexPath, triggerNetworkType: String) {
        if cell.networkTypeSelected == "SMS" {
            if cell.selectSMSTargetTextLabel.text == "Select trigger target" {
                cell.selectSMSTagetEmptyTextLabel.isHidden = false
            } else if cell.selectSMSNetworkTextLabel.text == "Select network" {
                cell.selectSMSNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectSMSTagetEmptyTextLabel.isHidden = true
                cell.selectSMSNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton(selectedCell: cell, networkType: triggerNetworkType, triggerTarget: cell.selectSMSTargetTextLabel.text ?? "")
            }
        } else if cell.networkTypeSelected == "EMAIL" {
            if cell.selectEmailTargetTextLabel.text == "Select trigger target" {
                cell.selectEmailTagetEmptyTextLabel.isHidden = false
            } else if cell.selectEmailNetworkTextLabel.text == "Select network" {
                cell.selectEmailNetworkEmptyTextLabel.isHidden = false
            } else {
                cell.selectEmailTagetEmptyTextLabel.isHidden = true
                cell.selectEmailNetworkEmptyTextLabel.isHidden = true
                setupNetworkNextButton(selectedCell: cell, networkType: triggerNetworkType, triggerTarget: cell.selectEmailTargetTextLabel.text ?? "")
            }
        } else {
            if cell.taskNameTextField.text == String.blank {
                cell.taskNameTextField.showError(message: "Please enter task name")
            } else if cell.assignTaskNetworkTextLabel.text == "Select network" {
                cell.assignTaskEmptyTextLabel.isHidden = false
            } else {
                cell.assignTaskEmptyTextLabel.isHidden = true
                taskName = cell.taskNameTextField.text ?? ""
                setupNetworkNextButton(selectedCell: cell, networkType: triggerNetworkType, triggerTarget: cell.selectEmailTargetTextLabel.text ?? "")
            }
        }
    }
    
    func setupNetworkNextButton(selectedCell: TriggerSMSCreateTableViewCell, networkType: String, triggerTarget: String) {
        selectedNetworkType = networkType
        selectedTriggerTarget = triggerTarget
        scrollToBottom()
        selectedCell.smsBtn.isUserInteractionEnabled = false
        selectedCell.emailBtn.isUserInteractionEnabled = false
        selectedCell.taskBtn.isUserInteractionEnabled = false
        selectedCell.createNextButton.isEnabled = false
        createNewTriggerCell(cellNameType: "Time")
    }
}

extension TriggerDetailViewController: TriggerTimeCellDelegate {
    
    
    func hourlyNetworkButton(cell: TriggerTimeTableViewCell, index: IndexPath) {
        
    }
    
    func scheduledBasedOnButton(cell: TriggerTimeTableViewCell, index: IndexPath) {
        
    }
    
    
    func addAnotherConditionButton(cell: TriggerTimeTableViewCell, index: IndexPath) {
        
        if moduleSelectionType == "lead" {
            if cell.timerTypeSelected == "Frequency" {
                if cell.timeDurationTextField.text == "" {
                    cell.timeDurationTextField.showError(message: "Please enter time duration")
                } else if cell.timeHourlyTextField.text == "" {
                    cell.timeHourlyTextField.showError(message: "Please select duration")
                } else {
                    scrollToBottom()
                    createNewTriggerCell(cellNameType: "Both")
                    cell.nextButton.isHidden = true
                    cell.addAnotherConditionButton.isHidden = true
                    cell.orLbl.isHidden = true
                }
            } else {
                if cell.timeRangeStartTimeTF.text == "" {
                    cell.timeRangeStartTimeTF.showError(message: "Please enter start time")
                } else if cell.timeRangeEndTimeTF.text == "" {
                    cell.timeRangeEndTimeTF.showError(message: "Please select end time")
                } else {
                    scrollToBottom()
                    createNewTriggerCell(cellNameType: "Both")
                    cell.nextButton.isHidden = true
                    cell.addAnotherConditionButton.isHidden = true
                    cell.orLbl.isHidden = true
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
                cell.nextButton.isHidden = true
                cell.addAnotherConditionButton.isHidden = true
                cell.orLbl.isHidden = true
            }
        }
        cell.timeRangeButton.isUserInteractionEnabled = false
        cell.timeFrequencyButton.isUserInteractionEnabled = false
        cell.addAnotherConditionButton.isEnabled = false
    }
    
    func nextBtnAction(cell: TriggerTimeTableViewCell, index: IndexPath) {
        if moduleSelectionType == "lead" {
            if cell.timerTypeSelected == "Frequency" {
                if cell.timeDurationTextField.text == "" {
                    cell.timeDurationTextField.showError(message: "Please enter time duration")
                } else if cell.timeHourlyTextField.text == "" {
                    cell.timeHourlyTextField.showError(message: "Please select duration")
                } else {
                    selectedTriggerTime = Int(cell.timeDurationTextField.text ?? "0") ?? 0
                    selectedTriggerFrequency = cell.timeHourlyTextField.text ?? ""
                    timerTypeSelected = cell.timerTypeSelected
                    submitBtn.backgroundColor = UIColor(hexString: "#009EDE")
                    cell.nextButton.isHidden = true
                    cell.addAnotherConditionButton.isHidden = true
                    cell.orLbl.isHidden = true
                    submitBtn.isEnabled = true
                }
            } else {
                if cell.timeRangeStartTimeTF.text == "" {
                    cell.timeRangeStartTimeTF.showError(message: "Please select start time")
                } else if cell.timeRangeEndTimeTF.text == "" {
                    cell.timeRangeEndTimeTF.showError(message: "Please select end time")
                } else {
                    selectedStartTime = cell.timeRangeStartTimeTF.text ?? ""
                    selectedEndTime = cell.timeRangeEndTimeTF.text ?? ""
                    selectedTriggerTime = Int(cell.timeDurationTextField.text ?? "0") ?? 0
                    selectedTriggerFrequency = cell.timeHourlyTextField.text ?? ""
                    timerTypeSelected = cell.timerTypeSelected
                    submitBtn.backgroundColor = UIColor(hexString: "#009EDE")
                    cell.nextButton.isHidden = true
                    cell.addAnotherConditionButton.isHidden = true
                    cell.orLbl.isHidden = true
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
                selectedTriggerTime = Int(cell.timeDurationTextField.text ?? "0") ?? 0
                selectedTriggerFrequency = cell.timeHourlyTextField.text ?? ""
                timerTypeSelected = cell.timerTypeSelected
                submitBtn.backgroundColor = UIColor(hexString: "#009EDE")
                cell.nextButton.isHidden = true
                cell.addAnotherConditionButton.isHidden = true
                cell.orLbl.isHidden = true
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
