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
            if selectedTriggerTarget == "Leads" {
                selectedTriggerTarget = "leads"
            }
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
                } else if triggerDetailList.cellType == "Both" {
                    guard let bothCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerParentCreateTableViewCell else { return  }
                    let parentTableView = bothCreateCell.getTableView()
                    
                    for childIndex in 0..<(bothCreateCell.finalArray.count)  {
                        let cellChildIndexPath = IndexPath(row: childIndex, section: 0)
                        let item = bothCreateCell.finalArray[cellChildIndexPath.row]
                        if item.type == "Create" {
                            guard let childCreateCell = parentTableView.cellForRow(at: cellChildIndexPath) as? TriggerEditSMSCreateTableViewCell else { return  }
                            addNewcheck = item.addNew ?? false
                            triggerTypeCheck = item.triggerType ?? ""
                            triggerTargetCheck = item.triggerTarget ?? ""
                            triggerDataDict = ["actionIndex": 3,
                                               "addNew": addNewcheck,
                                               "triggerTemplate": templateId,
                                               "triggerType": triggerTypeCheck,
                                               "triggerTarget": triggerTargetCheck,
                                               "taskName": childCreateCell.taskNameTextField.text ?? ""
                            ]
                        } else {
                            guard let timeCell = parentTableView.cellForRow(at: cellChildIndexPath) as? TriggerEditTimeTableViewCell else { return  }
                            let isTriggerFrequency = timeCell.timeHourlyTextField.text ?? ""
                            showBordercheck = item.showBorder ?? false
                            orderOfConditionTrigger = item.orderOfCondition ?? orderOfConditionTrigger
                            dateTypeCheck = item.dateType ?? "NA"
                            let timeDict: [String : Any] = [
                                "showBorder": showBordercheck,
                                "orderOfCondition": orderOfConditionTrigger,
                                "dateType": dateTypeCheck,
                                "startTime": timeCell.timeRangeStartTimeTF.text ?? "",
                                "endTime": timeCell.timeRangeEndTimeTF.text ?? "",
                                "triggerFrequency": isTriggerFrequency.uppercased(),
                                "triggerTime": Int(timeCell.timeDurationTextField.text ?? "0") ?? 0,
                                "timerType": timeCell.timerTypeSelected,
                                "deadline": NSNull()
                            ]
                            triggerDataDict.merge(withDictionary: timeDict)
                            self.createTriggerInfo(triggerCreateData: triggerDataDict)
                        }
                    }
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
            
            if selectedTriggerTarget == "Patient" {
                selectedTriggerTarget = "AppointmentPatient"
            } else {
                selectedTriggerTarget = "AppointmentClinic"
            }
            
            var triggerDataDictAppointment = [String: Any]()
            var isModuleSelectionTypeAppointment: String = ""
            var triggerDataDict: Parameters = [String: Any]()
            var selectedAppointmentStatus: String = ""
            for index in 0..<(self.triggerDetailList.count) {
                let cellIndexPath = IndexPath(row: index, section: 0)
                var templateId: Int = 0
                let triggerDetailList = self.triggerDetailList[cellIndexPath.row]
                if selectedNetworkType == "SMS" {
                    templateId = Int(selectedSmsTemplateId) ?? 0
                } else {
                    templateId = Int(selectedemailTemplateId) ?? 0
                }
                if triggerDetailList.cellType == "Default" {
                    guard let defaultCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditDefaultTableViewCell else { return  }
                    patientModuleName = defaultCreateCell.userModuleName
                } else if triggerDetailList.cellType == "Module" {
                    guard let moduleCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditModuleTableViewCell else { return  }
                    isModuleSelectionTypeAppointment = moduleCreateCell.moduleTypeSelected
                } else if triggerDetailList.cellType == "Appointment" {
                    guard let appointmentCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditAppointmentActionTableViewCell else { return  }
                    selectedAppointmentStatus = appointmentCreateCell.appointmentSelectedStatus
                } else if triggerDetailList.cellType == "Both" {
                    guard let bothCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerParentCreateTableViewCell else { return  }
                    let parentTableView = bothCreateCell.getTableView()
                    for childIndex in 0..<(bothCreateCell.finalArray.count)  {
                        let cellChildIndexPath = IndexPath(row: childIndex, section: 0)
                        let item = bothCreateCell.finalArray[cellChildIndexPath.row]
                        if item.type == "Create" {
                            guard let childCreateCell = parentTableView.cellForRow(at: cellChildIndexPath) as? TriggerEditSMSCreateTableViewCell else { return  }
                            addNewcheck = item.addNew ?? false
                            triggerTargetCheck = item.triggerTarget ?? ""
                            triggerTypeCheck = item.triggerType ?? ""
                            triggerDataDict = ["actionIndex": 3,
                                               "addNew": addNewcheck,
                                               "triggerTemplate": templateId,
                                               "triggerType": triggerTypeCheck,
                                               "triggerTarget": triggerTargetCheck,
                                               "taskName": childCreateCell.taskNameTextField.text ?? ""
                            ]
                        } else {
                            guard let timeCell = parentTableView.cellForRow(at: cellChildIndexPath) as? TriggerEditTimeTableViewCell else { return  }
                            let isTriggerFrequency = timeCell.timeHourlyTextField.text ?? ""
                            orderOfConditionTrigger = item.orderOfCondition ?? 0
                            showBordercheck = item.showBorder ?? false
                            dateTypeCheck = item.dateType ?? "NA"
                            let timeDict: [String : Any] = [
                                "showBorder": showBordercheck,
                                "orderOfCondition": orderOfConditionTrigger,
                                "dateType": dateTypeCheck,
                                "startTime": NSNull(),
                                "endTime": NSNull(),
                                "triggerFrequency": isTriggerFrequency.uppercased(),
                                "triggerTime": Int(timeCell.timeDurationTextField.text ?? "0") ?? 0,
                                "timerType": timeCell.timerTypeSelected,
                                "deadline": NSNull()
                            ]
                            triggerDataDict.merge(withDictionary: timeDict)
                            self.createTriggerInfo(triggerCreateData: triggerDataDict)
                        }
                    }
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
