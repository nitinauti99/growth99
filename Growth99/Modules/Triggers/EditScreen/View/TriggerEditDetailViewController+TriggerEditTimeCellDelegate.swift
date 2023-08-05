//
//  TriggerEditDetailViewController+TriggerEditTimeCellDelegate.swift
//  Growth99
//
//  Created by Sravan Goud on 17/07/23.
//

import Foundation
import UIKit

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
        if moduleSelectionType == "leads" {
            if cell.timerTypeSelected == "Frequency" {
                if cell.timeDurationTextField.text == "" {
                    cell.timeDurationTextField.showError(message: "Please enter time duration")
                } else if cell.timeHourlyTextField.text == "" {
                    cell.timeHourlyTextField.showError(message: "Please select duration")
                } else {
                    scrollToBottom()
                    addTriggerEditDetailModelCreate()
                }
            } else {
                if cell.timeRangeStartTimeTF.text == "" {
                    cell.timeRangeStartTimeTF.showError(message: "Please enter start time")
                } else if cell.timeRangeEndTimeTF.text == "" {
                    cell.timeRangeEndTimeTF.showError(message: "Please select end time")
                } else {
                    scrollToBottom()
                    addTriggerEditDetailModelCreate()
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
                addTriggerEditDetailModelCreate()
                cell.addAnotherConditionButton.isHidden = true
            }
        }
        cell.timeRangeButton.isUserInteractionEnabled = false
        cell.timeFrequencyButton.isUserInteractionEnabled = false
        cell.addAnotherConditionButton.isEnabled = false
    }
    
    func nextBtnAction(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
        if moduleSelectionType == "leads" {
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
                    submitBtn.isEnabled = true
                }
            }
        } else {
            if cell.timeDurationTextField.text == "" {
                cell.timeDurationTextField.showError(message: "Please enter time duration")
            } else if cell.timeHourlyTextField.text == "" {
                cell.timeHourlyTextField.showError(message: "Please select duration")
            } else if cell.scheduledBasedOnTextField.text == "" {
                cell.scheduledBasedOnTextField.showError(message: "Please select scheduled")
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
    
    func canelBtnAction(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
        self.navigationController?.popViewController(animated: true)

    }
    
    func submitBtnAction(cell: TriggerEditTimeTableViewCell, index: IndexPath) {
        self.smsandTimeArray = []
        self.view.ShowSpinner()
        if moduleSelectionType == "leads" {
            var triggerDataDict = [String: Any]()
            var timeDict = [String : Any]()
            var isfromLeadStatus: String = ""
            var istoLeadStatus: String = ""
            var isTriggerForLeadContain: Bool = false
            var isModuleSelectionType: String = ""
            var leadCreateCell: TriggerLeadEditActionTableViewCell?
            
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
                    guard let defaultCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditDefaultTableViewCell else { return  }
                    moduleName = defaultCreateCell.massEmailSMSTextField.text ?? ""
                } else if triggerDetailList.cellType == "Module" {
                    guard let moduleCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditModuleTableViewCell else { return  }
                    isModuleSelectionType = moduleCreateCell.moduleTypeSelected
                } else if triggerDetailList.cellType == "Lead" {
                    if let cell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadEditActionTableViewCell {
                        leadCreateCell = cell
                        isfromLeadStatus = cell.leadInitialStatusTextField.text ?? ""
                        istoLeadStatus = cell.leadFinalStatusTextField.text ?? ""
                        isTriggerForLeadContain = cell.leadStatusChangeButton.isSelected
                    }
                }
                else if triggerDetailList.cellType == "Create" {
                    guard let childCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditSMSCreateTableViewCell else { return  }
                    
                    var selectedTrigger: String = ""
                    if childCreateCell.triggerTargetName == "Clinic" {
                        selectedTrigger = "Clinic"
                    } else {
                        selectedTrigger = "lead"
                    }
                    if childCreateCell.isNewCellCreated == true {
                        addNewcheckCreate = true
                        showBordercheckCreate = false
                        let orderCount = orderOfConditionTriggerCheckCreate
                        if orderCount == 0 {
                            orderOfConditionTriggerCheckCreate = orderOfConditionTriggerCheckCreate + 2
                        } else {
                            orderOfConditionTriggerCheckCreate = orderOfConditionTriggerCheckCreate + 1
                        }
                    } else {
                        addNewcheckCreate = childCreateCell.addNewcheck
                        if manageBorder == true {
                            showBordercheckCreate = true
                        } else {
                            showBordercheckCreate = childCreateCell.showBordercheck
                        }
                        orderOfConditionTriggerCheckCreate = childCreateCell.orderOfConditionTriggerCheck
                    }
                    
                    triggerDataDict = ["actionIndex": 3,
                                       "addNew": addNewcheckCreate,
                                       "triggerTemplate": childCreateCell.templateId,
                                       "triggerType": childCreateCell.networkTypeSelected,
                                       "triggerTarget": selectedTrigger,
                                       "taskName": childCreateCell.taskNameTextField.text ?? "",
                                       "showBorder": showBordercheckCreate,
                                       "orderOfCondition": orderOfConditionTriggerCheckCreate,
                                       "deadline": NSNull()
                    ]
                }
                else if triggerDetailList.cellType == "Time" {
                    guard let timeCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditTimeTableViewCell else { return  }
                    let isTriggerFrequency = timeCell.timeHourlyTextField.text ?? ""
                    if timeCell.scheduledBasedOnTextField.text == "Appointment Created Date" {
                        scheduledBasedOnSelected = "APPOINTMENT_CREATED"
                    } else if timeCell.scheduledBasedOnTextField.text == "Before Appointment Date" {
                        scheduledBasedOnSelected = "APPOINTMENT_BEFORE"
                    } else {
                        scheduledBasedOnSelected = "APPOINTMENT_AFTER"
                    }
                    let startTime = timeCell.timeRangeStartTimeTF.text ?? ""
                    let endTime = timeCell.timeRangeEndTimeTF.text ?? ""
                    if startTime == "" && endTime == "" {
                        timeDict = [
                            "dateType": "NA",
                            "startTime": NSNull(),
                            "endTime": NSNull(),
                            "triggerFrequency": isTriggerFrequency.uppercased(),
                            "triggerTime": Int(timeCell.timeDurationTextField.text ?? "0") ?? 0,
                            "timerType": timeCell.timerTypeSelected,
                        ]
                    } else {
                        timeDict = [
                            "dateType": "NA",
                            "startTime": timeCell.timeRangeStartTimeTF.text ?? NSNull(),
                            "endTime": timeCell.timeRangeEndTimeTF.text ?? NSNull(),
                            "triggerFrequency": isTriggerFrequency.uppercased(),
                            "triggerTime": Int(timeCell.timeDurationTextField.text ?? "0") ?? 0,
                            "timerType": timeCell.timerTypeSelected,
                        ]
                    }
                    
                    triggerDataDict.merge(withDictionary: timeDict)
                    self.createTriggerInfo(triggerCreateData: triggerDataDict)
                }
            }
            
            var selectedLeadLandingPagesdict = Array<Any>()
            if let leadCreateCell = leadCreateCell {
                for item in leadCreateCell.selectedLeadLandingPages {
                    let param: [String: Any] = ["name": item.name ?? "", "id": item.id ?? 0]
                    selectedLeadLandingPagesdict.append(param)
                }
            }
            
            var selectedLeadSourceUrldict = Array<Any>()
            if let leadCreateCell = leadCreateCell {
                for item in leadCreateCell.selectedLeadSourceUrl {
                    let param: [String: Any] = ["sourceUrl": item.sourceUrl ?? "", "id": item.id ?? 0]
                    selectedLeadSourceUrldict.append(param)
                }
            }
            
            var selectedLeadTagsUrldict = Array<Any>()
            if let leadCreateCell = leadCreateCell {
                for item in leadCreateCell.selectedLeadTags {
                    let param: [String: Any] = ["name": item.name ?? "", "id": item.id ?? 0, "isDefault": item.isDefault ?? false]
                    selectedLeadTagsUrldict.append(param)
                }
            }
            
            var selectedleadFormsdict = Array<Any>()
            if let leadCreateCell = leadCreateCell {
                for item in leadCreateCell.selectedleadForms {
                    let param: [String: Any] = ["name": item.name ?? "", "id": item.id ?? 0]
                    selectedleadFormsdict.append(param)
                }
            }
            
            var urlParameter: Parameters = [String: Any]()
            if isfromLeadStatus == "" && istoLeadStatus == "" {
                urlParameter = ["name": moduleName, "moduleName": "leads", "triggeractionName": "Pending", "triggerConditions": leadCreateCell?.selectedLeadSources ?? [], "triggerData": smsandTimeArray, "landingPageNames": selectedLeadLandingPagesdict, "forms": selectedleadFormsdict , "sourceUrls": selectedLeadSourceUrldict , "leadTags": selectedLeadTagsUrldict , "isTriggerForLeadStatus": isTriggerForLeadContain, "fromLeadStatus": NSNull(), "toLeadStatus": NSNull()
                ]
            } else {
                urlParameter = ["name": moduleName, "moduleName": "leads", "triggeractionName": "Pending", "triggerConditions": leadCreateCell?.selectedLeadSources ?? [], "triggerData": smsandTimeArray, "landingPageNames": selectedLeadLandingPagesdict, "forms": selectedleadFormsdict, "sourceUrls": selectedLeadSourceUrldict , "leadTags": selectedLeadTagsUrldict , "isTriggerForLeadStatus": isTriggerForLeadContain, "fromLeadStatus": isfromLeadStatus, "toLeadStatus": istoLeadStatus
                ]
            }
            print(urlParameter)
            self.view.ShowSpinner()
            viewModel?.createTriggerDataMethodEdit(triggerDataParms: urlParameter, selectedTriggerid: triggerId ?? 0)
        } else {
            var triggerDataDictAppointment = [String: Any]()
            var isModuleSelectionTypeAppointment: String = ""
            var selectedAppointmentStatus: String = ""
            for index in 0..<(self.triggerDetailList.count) {
                let cellIndexPath = IndexPath(row: index, section: 0)
                let triggerDetailList = self.triggerDetailList[cellIndexPath.row]
                if triggerDetailList.cellType == "Default" {
                    guard let defaultCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditDefaultTableViewCell else { return  }
                    patientModuleName = defaultCreateCell.massEmailSMSTextField.text ?? ""
                } else if triggerDetailList.cellType == "Module" {
                    guard let moduleCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditModuleTableViewCell else { return  }
                    isModuleSelectionTypeAppointment = moduleCreateCell.moduleTypeSelected
                } else if triggerDetailList.cellType == "Appointment" {
                    guard let appointmentCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditAppointmentActionTableViewCell else { return  }
                    selectedAppointmentStatus = appointmentCreateCell.appointmentSelectedStatus
                }
                else if triggerDetailList.cellType == "Create" {
                    guard let childCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditSMSCreateTableViewCell else { return  }
                    
                    var selectedTrigger: String = ""
                    if childCreateCell.triggerTargetName == "Patient" {
                        selectedTrigger = "AppointmentPatient"
                    } else {
                        selectedTrigger = "AppointmentClinic"
                    }
                    if childCreateCell.isNewCellCreated == true {
                        addNewcheckCreate = true
                        showBordercheckCreate = false
                        let orderCount = orderOfConditionTriggerCheckCreate
                        if orderCount == 0 {
                            orderOfConditionTriggerCheckCreate = orderOfConditionTriggerCheckCreate + 2
                        } else {
                            orderOfConditionTriggerCheckCreate = orderOfConditionTriggerCheckCreate + 1
                        }
                    } else {
                        addNewcheckCreate = childCreateCell.addNewcheck
                        if manageBorder == true {
                            showBordercheckCreate = true
                        } else {
                            showBordercheckCreate = childCreateCell.showBordercheck
                        }
                        orderOfConditionTriggerCheckCreate = childCreateCell.orderOfConditionTriggerCheck
                    }
                    triggerDataDictAppointment = ["actionIndex": 3,
                                                  "addNew": addNewcheckCreate,
                                                  "triggerTemplate": childCreateCell.templateId,
                                                  "triggerType": childCreateCell.networkTypeSelected,
                                                  "triggerTarget": selectedTrigger,
                                                  "taskName": childCreateCell.taskNameTextField.text ?? "",
                                                  "showBorder": showBordercheckCreate,
                                                  "orderOfCondition": orderOfConditionTriggerCheckCreate,
                                                  "deadline": NSNull()
                    ]
                }
                else if triggerDetailList.cellType == "Time" {
                    guard let timeCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditTimeTableViewCell else { return  }
                    let isTriggerFrequency = timeCell.timeHourlyTextField.text ?? ""
                    if timeCell.scheduledBasedOnTextField.text == "Appointment Created Date" {
                        scheduledBasedOnSelected = "APPOINTMENT_CREATED"
                    } else if timeCell.scheduledBasedOnTextField.text == "Before Appointment Date" {
                        scheduledBasedOnSelected = "APPOINTMENT_BEFORE"
                    } else {
                        scheduledBasedOnSelected = "APPOINTMENT_AFTER"
                    }
                    let timeDict: [String : Any] = [
                        "dateType": scheduledBasedOnSelected,
                        "startTime": timeCell.timeRangeStartTimeTF.text ?? NSNull(),
                        "endTime": timeCell.timeRangeEndTimeTF.text ?? NSNull(),
                        "triggerFrequency": isTriggerFrequency.uppercased(),
                        "triggerTime": Int(timeCell.timeDurationTextField.text ?? "0") ?? 0,
                        "timerType": timeCell.timerTypeSelected,
                    ]
                    triggerDataDictAppointment.merge(withDictionary: timeDict)
                    self.createTriggerInfo(triggerCreateData: triggerDataDictAppointment)
                }
            }
            
            var urlParameter: Parameters = [String: Any]()
            let landingPageNames: [String] = []
            let forms: [String] = []
            let sourceUrls: [String] = []
            let leadTags: [String] = []
            urlParameter = ["name": patientModuleName, "moduleName": "Appointment", "triggeractionName": selectedAppointmentStatus, "triggerConditions": NSNull(), "triggerData": smsandTimeArray, "landingPageNames": landingPageNames, "forms": forms, "sourceUrls": sourceUrls, "leadTags": leadTags, "isTriggerForLeadStatus": false, "fromLeadStatus": NSNull(), "toLeadStatus": NSNull()
            ]
            print(urlParameter)
            self.view.ShowSpinner()
            viewModel?.createAppointmentDataMethodEdit(appointmentDataParms: urlParameter, selectedTriggerid: triggerId ?? 0)
        }
    }
}
