//
//  TriggerEditDetailViewController+Submit.swift
//  Growth99
//
//  Created by Sravan Goud on 17/07/23.
//

import Foundation
import UIKit

extension TriggerEditDetailViewController: BottomTableViewCellProtocol {
    
    func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func submitButtonPressed() {
        self.smsandTimeArray = []
        self.view.ShowSpinner()
        if moduleSelectionType == "leads" {
            var triggerDataDict = [String: Any]()
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
                    moduleName = defaultCreateCell.userModuleName
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
                    if childCreateCell.triggerTargetName == "Patient" {
                        selectedTrigger = "AppointmentPatient"
                    } else {
                        selectedTrigger = "AppointmentClinic"
                    }
                    if isAddanotherClicked == true {
                        addNewcheckCreate = true
                        showBordercheckCreate = false
                        let orderCount = childCreateCell.orderOfConditionTriggerCheck
                        if orderCount == 0 {
                            orderOfConditionTriggerCheckCreate = orderOfConditionTrigger + 2
                        } else {
                            orderOfConditionTriggerCheckCreate = orderOfConditionTrigger + 1
                        }
                    } else {
                        addNewcheckCreate = childCreateCell.addNewcheck
                        showBordercheckCreate = childCreateCell.showBordercheck
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
                    let timeDict: [String : Any] = [
                        "dateType": "NA",
                        "startTime": timeCell.timeRangeStartTimeTF.text ?? "",
                        "endTime": timeCell.timeRangeEndTimeTF.text ?? "",
                        "triggerFrequency": isTriggerFrequency.uppercased(),
                        "triggerTime": Int(timeCell.timeDurationTextField.text ?? "0") ?? 0,
                        "timerType": timeCell.timerTypeSelected,
                    ]
                    triggerDataDict.merge(withDictionary: timeDict)
                    self.createTriggerInfo(triggerCreateData: triggerDataDict)
                }            }
            
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
                    patientModuleName = defaultCreateCell.userModuleName
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
                    if isAddanotherClicked == true {
                        addNewcheckCreate = true
                        showBordercheckCreate = false
                        let orderCount = childCreateCell.orderOfConditionTriggerCheck
                        if orderCount == 0 {
                            orderOfConditionTriggerCheckCreate = orderOfConditionTrigger + 2
                        } else {
                            orderOfConditionTriggerCheckCreate = orderOfConditionTrigger + 1
                        }
                    } else {
                        addNewcheckCreate = childCreateCell.addNewcheck
                        showBordercheckCreate = childCreateCell.showBordercheck
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
                        "startTime": NSNull(),
                        "endTime": NSNull(),
                        "triggerFrequency": isTriggerFrequency.uppercased(),
                        "triggerTime": Int(timeCell.timeDurationTextField.text ?? "0") ?? 0,
                        "timerType": timeCell.timerTypeSelected,
                    ]
                    triggerDataDictAppointment.merge(withDictionary: timeDict)
                    self.createTriggerInfo(triggerCreateData: triggerDataDictAppointment)
                }
            }
            
            var urlParameter: Parameters = [String: Any]()
            let triggerConditions: [String] = []
            let landingPageNames: [String] = []
            let forms: [String] = []
            let sourceUrls: [String] = []
            let leadTags: [String] = []
            urlParameter = ["name": patientModuleName, "moduleName": "Appointment", "triggeractionName": selectedAppointmentStatus, "triggerConditions": triggerConditions, "triggerData": smsandTimeArray, "landingPageNames": landingPageNames, "forms": forms, "sourceUrls": sourceUrls, "leadTags": leadTags, "isTriggerForLeadStatus": false, "fromLeadStatus": NSNull(), "toLeadStatus": NSNull()
            ]
            print(urlParameter)
            self.view.ShowSpinner()
            viewModel?.createAppointmentDataMethodEdit(appointmentDataParms: urlParameter, selectedTriggerid: triggerId ?? 0)
        }
    }
}
