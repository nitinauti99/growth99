//
//  TriggerEditDetailViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerEditDetailViewControlProtocol: AnyObject {
    func triggerEditDetailDataRecived()
    func triggerEditLandingPageNamesDataRecived()
    func triggerEditQuestionnairesDataRecived()
    func triggerEditLeadSourceUrlDataRecived()
    func triggerEditLeadTagsDataRecived()
    func errorReceived(error: String)
    func triggerEditSelectedDataRecived()
    func createEditTriggerDataReceived()
    func createEditAppointmentDataReceived()
}

class TriggerEditDetailViewController: UIViewController, TriggerEditDetailViewControlProtocol {
    
    @IBOutlet weak var triggerdDetailTableView: UITableView!
    
    @IBOutlet weak var submitBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet var triggerCreateScrollview: UIScrollView!
    @IBOutlet var triggerCreateScrollviewHeight: NSLayoutConstraint!

    var triggerDetailList = [TriggerEditDetailModel]()
    var viewModel: TriggerEditDetailViewModelProtocol?
    var leadTagsArray = [TriggerEditTagListModel]()
    var patientTagsArray = [TriggerEditTagListModel]()
    
    var leadTagsTriggerArrayEdit = [MassEmailSMSTagListModelEdit]()
    var selectedLeadTags = [MassEmailSMSTagListModelEdit]()
    var selectedLeadTagIds: String = String.blank
    
    var selectedPatientTags = [TriggerEditTagListModel]()
    var selectedPatientTagIds: String = String.blank
    
    var emailTemplatesArray = [EmailEditTemplateDTOListTrigger]()
    var selectedEmailTemplates = [EmailEditTemplateDTOListTrigger]()
    var selectedemailTemplateId: String = String.blank
    
    var smsTemplatesArray = [SmsTemplateEditDTOListTrigger]()
    var selectedSmsTemplates = [SmsTemplateEditDTOListTrigger]()
    var selectedSmsTemplateId: String = String.blank
    
    var dateFormater: DateFormaterProtocol?
    var patientAppointmentStatus: String = String.blank
    var leadSource: String = String.blank
    
    var leadSourceArray: [String] = []
    var selectedLeadSources: [String] = []
    var leadLandingPagesArray = [EditLandingPageNamesModel]()
    var selectedLeadLandingPages: [EditLandingPageNamesModel] = []
    var leadFormsArray = [EditLandingPageNamesModel]()
    var selectedleadForms: [EditLandingPageNamesModel] = []
    var appointmentStatusArray: [String] = []
    var selectedAppointmentStatus: [String] = []
    var selectedSMSNetwork = [SmsTemplateEditDTOListTrigger]()
    var selectedEmailNetwork = [EmailEditTemplateDTOListTrigger]()
    
    var leadSourceUrlArray = [LeadSourceUrlListModel]()
    var selectedLeadSourceUrl = [LeadSourceUrlListModel]()
    
    var triggersCreateData = [TriggerEditCreateData]()
    var triggersAppointmentCreateData = [TriggerEditAppointmentCreateData]()
    
    var moduleSelectionType: String = String.blank
    var smsTargetArray: [String] = []
    var emailTargetArray: [String] = []
    var smsTargetSelectionType: String = String.blank
    var emailTargetSelectionType: String = String.blank
    var taskUserListArray: [UserDTOListEditTrigger] = []
    var selectedTaskTemplate: Int = 0
    
    var moduleName: String = String.blank
    var selectedNetworkType: String = String.blank
    var templateId: Int = 0
    
    var selectedTriggerTime: Int = 0
    var selectedTriggerFrequency: String = String.blank
    var taskName: String = String.blank
    var selectedTriggerTarget: String = String.blank
    var leadTriggerTarget: String = String.blank
    var cinicTriggerTarget: String = String.blank
    var timerTypeSelected: String = String.blank
    
    var appointmentSelectedStatus: String = String.blank
    var scheduledBasedOnSelected: String = String.blank
    var orderOfConditionTrigger: Int = 0
    var addAnotherClicked: String = String.blank
    
    var isSelectLandingSelected: Bool = false
    var isSelectFormsSelected: Bool = false
    var isLeadStatusChangeSelected: Bool = false
    var isInitialStatusSelected: Bool = false
    var isFinalStatusSelected: Bool = false
    var selectedStartTime: String = String.blank
    var selectedEndTime: String = String.blank
    var triggerId: Int?
    var finalArray = [TriggerEditData]()
    var triggerEditChildData: [TriggerEditData] = []
    
    var isTriggerForLeadContain: Bool = false
    var isInitialStatusContain: String = ""
    var isFinalStatusContain: String = ""
    
    var isEndTime: String = ""
    var isTaskName: String = ""
    var isStartTime: String = ""
    var isAssignedToTask: String = ""
    var smsandTimeArray = Array<Any>()
    var showBordercheck: Bool = false
    var dateTypeCheck: String = ""
    var addNewcheck: Bool = false
    var triggerTargetCheck: String = ""
    var triggerTypeCheck: String = ""
    
    var isAddanotherClicked: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        dateFormater = DateFormater()
        triggerCreateScrollview.delegate = self
        leadSourceArray = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook", "Integrately"]
        appointmentStatusArray = ["Pending", "Confirmed", "Completed", "Canceled", "Updated"]
        viewModel = TriggerEditDetailViewModel(delegate: self)
//        submitBtn.isEnabled = false
//        submitBtn.backgroundColor = UIColor(hexString: "#6AC1E7")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTriggerDetails()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.editTrigger
    }
    
    @objc func getTriggerDetails() {
        self.view.ShowSpinner()
        viewModel?.getSelectedTriggerList(selectedTriggerId: triggerId ?? 0)
    }
    
    func triggerEditSelectedDataRecived() {
        viewModel?.getTriggerDetailListEdit()
    }
    
    func triggerEditDetailDataRecived() {
        viewModel?.getLandingPageNamesEdit()
    }
    
    func triggerEditLandingPageNamesDataRecived() {
        viewModel?.getTriggerQuestionnairesEdit()
    }
    
    func triggerEditQuestionnairesDataRecived() {
        viewModel?.getTriggerLeadSourceUrlEdit()
    }
    
    func triggerEditLeadTagsDataRecived() {
        self.view.HideSpinner()
        
        let defaultScreen = TriggerEditDetailModel(cellType: "Default", LastName: "")
        let moduleScreen = TriggerEditDetailModel(cellType: "Module", LastName: "")
        let leadScreen = TriggerEditDetailModel(cellType: "Lead", LastName: "")
        let appointmentScreen = TriggerEditDetailModel(cellType: "Appointment", LastName: "")
        let createScreen = TriggerEditDetailModel(cellType: "Both", LastName: "")
        let modelData = viewModel?.getTriggerEditListData
        
        if modelData?.name != "" && modelData?.moduleName != "" {
            triggerDetailList.append(defaultScreen)
            triggerDetailList.append(moduleScreen)
            if modelData?.moduleName == "leads" {
                triggerDetailList.append(leadScreen)
            } else if modelData?.moduleName == "Appointment" {
                triggerDetailList.append(appointmentScreen)
            }
            triggerDetailList.append(createScreen)
        }
        selectedLeadSources = modelData?.triggerConditions ?? []
        triggerdDetailTableView.reloadData()
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight
        self.view.layoutIfNeeded()
    }
    
    func triggerEditLeadSourceUrlDataRecived() {
        viewModel?.getTriggerLeadTagsList()
    }
    
    func triggerSMSPatientStatusAllDataRecived() {
        self.view.HideSpinner()
        let emailSMS = TriggerEditDetailModel(cellType: "Both", LastName: "")
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
    
    func bothInsertDataReceived() {
        self.view.HideSpinner()
        let emailSMS = TriggerEditDetailModel(cellType: "Both", LastName: "")
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
    
    func createEditTriggerDataReceived() {
        triggerAppointmentUpdatedSucessfull()
    }
    
    func createEditAppointmentDataReceived() {
        triggerAppointmentUpdatedSucessfull()
    }
    
    func triggerAppointmentUpdatedSucessfull() {
        self.view.HideSpinner()
        self.view.showToast(message: "Trigger updated successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func registerTableView() {
        self.triggerdDetailTableView.delegate = self
        self.triggerdDetailTableView.dataSource = self
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerDefaultTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerLeadEditActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerLeadEditActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerEditModuleTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditModuleTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerAppointmentActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerAppointmentActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerParentCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerParentCreateTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "BottomTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "BottomTableViewCell")
    }
    
    func createNewTriggerCell(cellNameType: String) {
        let emailSMS = TriggerEditDetailModel(cellType: cellNameType, LastName: String.blank)
        triggerDetailList.append(emailSMS)
        self.triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (self.triggerDetailList.count) - 1, section: 0)
        self.triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        self.triggerdDetailTableView.endUpdates()
    }
    
    var triggerCreateTableViewHeight: CGFloat {
        triggerdDetailTableView.layoutIfNeeded()
        return triggerdDetailTableView.contentSize.height + 500
    }
    
}

extension TriggerEditDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight
    }
}


extension TriggerEditDetailViewController: BottomTableViewCellProtocol {
    
    func cancelButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// submit button which validate all  condition
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
                    
                } else if triggerDetailList.cellType == "Module" {
                    guard let moduleCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditModuleTableViewCell else { return  }
                    isModuleSelectionType = moduleCreateCell.moduleTypeSelected
                } else if triggerDetailList.cellType == "Lead" {
                    guard let leadCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerLeadEditActionTableViewCell else { return  }
                    isfromLeadStatus = leadCreateCell.leadInitialStatusTextField.text ?? ""
                    istoLeadStatus = leadCreateCell.leadFinalStatusTextField.text ?? ""
                    isTriggerForLeadContain = leadCreateCell.leadStatusChangeButton.isSelected
                } else if triggerDetailList.cellType == "Both" {
                    guard let bothCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerParentCreateTableViewCell else { return  }
                    let parentTableView = bothCreateCell.getTableView()
                    
                    for childIndex in 0..<(finalArray.count)  {
                        let cellChildIndexPath = IndexPath(row: childIndex, section: 0)
                        let item = finalArray[cellChildIndexPath.row]
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
                            orderOfConditionTrigger = item.orderOfCondition ?? 0
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
            for item in selectedLeadLandingPages {
                let param: [String: Any] = ["name": item.name ?? "", "id": item.id ?? 0]
                selectedLeadLandingPagesdict.append(param)
            }
            
            var selectedLeadSourceUrldict = Array<Any>()
            for item in selectedLeadSourceUrl {
                let param: [String: Any] = ["sourceUrl": item.sourceUrl ?? "", "id": item.id ?? 0]
                selectedLeadSourceUrldict.append(param)
            }
            
            var selectedLeadTagsUrldict = Array<Any>()
            for item in selectedLeadTags {
                let param: [String: Any] = ["name": item.name ?? "", "id": item.id ?? 0, "isDefault": item.isDefault ?? false]
                selectedLeadTagsUrldict.append(param)
            }
            
            var selectedleadFormsdict = Array<Any>()
            for item in selectedleadForms {
                let param: [String: Any] = ["name": item.name ?? "", "id": item.id ?? 0]
                selectedleadFormsdict.append(param)
            }
            
            var urlParameter: Parameters = [String: Any]()
            if isfromLeadStatus == "" && istoLeadStatus == "" {
                urlParameter = ["name": moduleName, "moduleName": "leads", "triggeractionName": "Pending", "triggerConditions": selectedLeadSources, "triggerData": smsandTimeArray, "landingPageNames": selectedLeadLandingPagesdict, "forms": selectedleadFormsdict, "sourceUrls": selectedLeadSourceUrldict, "leadTags": selectedLeadTagsUrldict, "isTriggerForLeadStatus": isTriggerForLeadContain, "fromLeadStatus": NSNull(), "toLeadStatus": NSNull()
                ]
            } else {
                urlParameter = ["name": moduleName, "moduleName": "leads", "triggeractionName": "Pending", "triggerConditions": selectedLeadSources, "triggerData": smsandTimeArray, "landingPageNames": selectedLeadLandingPagesdict, "forms": selectedleadFormsdict, "sourceUrls": selectedLeadSourceUrldict, "leadTags": selectedLeadTagsUrldict, "isTriggerForLeadStatus": isTriggerForLeadContain, "fromLeadStatus": isfromLeadStatus, "toLeadStatus": istoLeadStatus
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
                    guard let defaultCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerDefaultTableViewCell else { return  }
                } else if triggerDetailList.cellType == "Module" {
                    guard let moduleCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerEditModuleTableViewCell else { return  }
                    isModuleSelectionTypeAppointment = moduleCreateCell.moduleTypeSelected
                } else if triggerDetailList.cellType == "Appointment" {
                    guard let leadCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerAppointmentActionTableViewCell else { return  }
                } else if triggerDetailList.cellType == "Both" {
                    guard let bothCreateCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerParentCreateTableViewCell else { return  }
                    let parentTableView = bothCreateCell.getTableView()
                    for childIndex in 0..<(finalArray.count)  {
                        let cellChildIndexPath = IndexPath(row: childIndex, section: 0)
                        let item = finalArray[cellChildIndexPath.row]
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
            var urlParameter: Parameters = [String: Any]()
            urlParameter = ["name": moduleName, "moduleName": "Appointment", "triggeractionName": appointmentSelectedStatus, "triggerConditions": [], "triggerData": smsandTimeArray, "landingPageNames": [], "forms": [], "sourceUrls": [], "leadTags": selectedLeadTags, "isTriggerForLeadStatus": false, "fromLeadStatus": NSNull(), "toLeadStatus": NSNull()
            ]
            print(urlParameter)
            self.view.ShowSpinner()
            viewModel?.createAppointmentDataMethodEdit(appointmentDataParms: urlParameter, selectedTriggerid: triggerId ?? 0)
        }
    }
    
    
}
