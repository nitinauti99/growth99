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
    var leadLandingPagesArray = [EditLandingPageNamesModel]()
    var leadFormsArray = [EditLandingPageNamesModel]()
    var selectedSMSNetwork = [SmsTemplateEditDTOListTrigger]()
    var selectedEmailNetwork = [EmailEditTemplateDTOListTrigger]()
    
    var leadSourceUrlArray = [LeadSourceUrlListModel]()
    
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
    var patientModuleName: String = String.blank
    var selectedNetworkType: String = String.blank
    var templateId: Int = 0
    
    var selectedTriggerTime: Int = 0
    var selectedTriggerFrequency: String = String.blank
    var taskName: String = String.blank
    var selectedTriggerTarget: String = String.blank
    var leadTriggerTarget: String = String.blank
    var cinicTriggerTarget: String = String.blank
    var timerTypeSelected: String = String.blank
    
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
    var triggerEditChildData: [TriggerEditData] = []
    
    var isEndTime: String = ""
    var isTaskName: String = ""
    var isStartTime: String = ""
    var isAssignedToTask: String = ""
    var smsandTimeArray = Array<Any>()
    var addNewcheckCreate: Bool = false
    var showBordercheckCreate: Bool = false
    var orderOfConditionTriggerCheckCreate: Int = 0
    var dateTypeCheck: String = ""
    var triggerTargetCheck: String = ""
    var triggerTypeCheck: String = ""
    var isAddanotherClicked: Bool = false
    var isAddanotherTimeClicked: Bool = false
    var manageBorder: Bool = false
    var defaultNextSelected: Bool = false
    var patientTypeSelected: Bool = false
    var leadTypeSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        dateFormater = DateFormater()
        triggerCreateScrollview.delegate = self
        leadSourceArray = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook", "Integrately"]
        viewModel = TriggerEditDetailViewModel(delegate: self)
        submitBtn.isEnabled = false
        submitBtn.backgroundColor = UIColor(hexString: "#6AC1E7")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTriggerDetails()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.editTrigger
    }
    
    func registerTableView() {
        self.triggerdDetailTableView.delegate = self
        self.triggerdDetailTableView.dataSource = self
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerEditDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditDefaultTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerLeadEditActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerLeadEditActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerEditModuleTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditModuleTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerEditAppointmentActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditAppointmentActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerEditSMSCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditSMSCreateTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerEditTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditTimeTableViewCell")
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
    
    func triggerEditLeadSourceUrlDataRecived() {
        viewModel?.getTriggerLeadTagsList()
    }
    
    func createEditTriggerDataReceived() {
        triggerAppointmentUpdatedSucessfull()
    }
    
    func createEditAppointmentDataReceived() {
        triggerAppointmentUpdatedSucessfull()
    }
    
    func createNewTriggerCell(cellNameType: String) {
        addTriggerEditDetailModel(cellType: cellNameType)
    }
    
    func triggerSMSPatientStatusAllDataRecived() {
        self.view.HideSpinner()
        addTriggerEditDetailModel(cellType: "Create")
    }
    
    func bothInsertDataReceived() {
        self.view.HideSpinner()
        addTriggerEditDetailModel(cellType: "Create")
    }
    
    private func addTriggerEditDetailModel(cellType: String) {
        let emailSMS = TriggerEditDetailModel(cellType: cellType, LastName: "")
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: triggerDetailList.count - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
    
    func addTriggerEditDetailModelCreate() {
        let emailSMS = TriggerEditDetailModel(cellType: "Create", LastName: "")
        triggerDetailList.append(emailSMS)
        isAddanotherClicked = true
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: triggerDetailList.count - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
    
    func addTriggerEditDetailModelTime() {
        let emailSMS = TriggerEditDetailModel(cellType: "Time", LastName: "")
        triggerDetailList.append(emailSMS)
        isAddanotherTimeClicked = true
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: triggerDetailList.count - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
    
    func triggerEditLeadTagsDataRecived() {
        self.view.HideSpinner()
        
        let defaultScreen = TriggerEditDetailModel(cellType: "Default", LastName: "")
        let moduleScreen = TriggerEditDetailModel(cellType: "Module", LastName: "")
        let leadScreen = TriggerEditDetailModel(cellType: "Lead", LastName: "")
        let appointmentScreen = TriggerEditDetailModel(cellType: "Appointment", LastName: "")
        let createScreen = TriggerEditDetailModel(cellType: "Create", LastName: "")
        let timeScreen = TriggerEditDetailModel(cellType: "Time", LastName: "")
        let modelData = viewModel?.getTriggerEditListData
        if modelData?.name != "" && modelData?.moduleName != "" {
            triggerDetailList.append(defaultScreen)
            triggerDetailList.append(moduleScreen)
            if modelData?.moduleName == "leads" {
                triggerDetailList.append(leadScreen)
            } else if modelData?.moduleName == "Appointment" {
                triggerDetailList.append(appointmentScreen)
            }
            for _ in (0..<(modelData?.triggerData?.count ?? 0)) {
                triggerDetailList.append(createScreen)
                triggerDetailList.append(timeScreen)
            }
        }
        triggerdDetailTableView.reloadData()
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight
        self.view.layoutIfNeeded()
    }
    
    var triggerCreateTableViewHeight: CGFloat {
        triggerdDetailTableView.layoutIfNeeded()
        return triggerdDetailTableView.contentSize.height + 300
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
}

extension TriggerEditDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight
    }
}


extension TriggerEditDetailViewController {
    
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(sender: UIButton) {
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
                    let startTimeTrigegr = timeCell.timeRangeStartTimeTF.text ?? ""
                    let endTimeTrigegr = timeCell.timeRangeEndTimeTF.text ?? ""
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let formattedDate = dateFormatter.string(from: currentDate)
                    let dateStartStr: String = (formattedDate) + " " + (startTimeTrigegr)
                    let dateEndStr: String = (formattedDate) + " " + (endTimeTrigegr)
                    let scheduleStartDate = (dateFormater?.convertDateStringToStringCalender(dateString: dateStartStr)) ?? ""
                    let scheduleEndDate = (dateFormater?.convertDateStringToStringCalender(dateString: dateEndStr)) ?? ""
                    if startTimeTrigegr == "" && endTimeTrigegr == "" {
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
                            "startTime": scheduleStartDate,
                            "endTime": scheduleEndDate,
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
