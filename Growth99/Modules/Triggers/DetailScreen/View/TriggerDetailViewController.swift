//
//  TriggerDetailViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerDetailViewControlProtocol: AnyObject {
    func triggerDetailDataRecived()
    func triggerLandingPageNamesDataRecived()
    func triggerQuestionnairesDataRecived()
    func triggerLeadSourceUrlDataRecived()
    func errorReceived(error: String)
    func triggerLeadTagsDataRecived()
    func createTriggerDataReceived()
    func createAppointmentDataReceived()
}

class TriggerDetailViewController: UIViewController, TriggerDetailViewControlProtocol {
    
    @IBOutlet weak var triggerdDetailTableView: UITableView!
    
    @IBOutlet weak var submitBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet var triggerCreateScrollview: UIScrollView!
    @IBOutlet var triggerCreateScrollviewHeight: NSLayoutConstraint!
    
    var triggerDetailList = [TriggerDetailModel]()
    var viewModel: TriggerDetailViewModelProtocol?
    var leadTagsArray = [TriggerTagListModel]()
    var patientTagsArray = [TriggerTagListModel]()
    
    var selectedLeadTags = [MassEmailSMSTagListModelEdit]()
    var selectedLeadTagIds: String = String.blank
    
    var selectedPatientTags = [TriggerTagListModel]()
    var selectedPatientTagIds: String = String.blank
    
    var emailTemplatesArray = [EmailTemplateDTOListTrigger]()
    var selectedEmailTemplates = [EmailTemplateDTOListTrigger]()
    
    var smsTemplatesArray = [SmsTemplateDTOListTrigger]()
    var selectedSmsTemplates = [SmsTemplateDTOListTrigger]()
    
    var dateFormater: DateFormaterProtocol?
    var patientAppointmentStatus: String = String.blank
    var leadSource: String = String.blank
    
    var leadSourceArray: [String] = []
    var selectedLeadSources: [String] = []
    var leadLandingPagesArray = [LandingPageNamesModel]()
    var selectedLeadLandingPages: [LandingPageNamesModel] = []
    var leadFormsArray = [LandingPageNamesModel]()
    var selectedleadForms: [LandingPageNamesModel] = []
    var appointmentStatusArray: [String] = []
    var selectedAppointmentStatus: [String] = []
    
    var leadSourceUrlArray = [LeadSourceUrlListModel]()
    var selectedLeadSourceUrl = [LeadSourceUrlListModel]()
    
    var triggersCreateData = [TriggerCreateData]()
    var triggersAppointmentCreateData = [TriggerAppointmentCreateData]()
    var leadTagsTriggerArray = [MassEmailSMSTagListModelEdit]()
    
    var moduleSelectionType: String = String.blank
    var smsTargetArray: [String] = []
    var emailTargetArray: [String] = []
    var smsTargetSelectionType: String = String.blank
    var emailTargetSelectionType: String = String.blank
    var taskUserListArray: [UserDTOListTrigger] = []
    var selectedTaskTemplate: Int = 0
    
    var moduleName: String = String.blank
    var selectedNetworkType: String = String.blank
    var templateId: Int = 0
    
    var selectedTriggerTime: Int = 0
    var selectedStartTime: String = String.blank
    var selectedEndTime: String = String.blank
    
    var selectedTriggerFrequency: String = String.blank
    var taskName: String = String.blank
    var leadTriggerTarget: String = String.blank
    var cinicTriggerTarget: String = String.blank
    var timerTypeSelected: String = String.blank
    
    var appointmentSelectedStatus: String = String.blank
    var scheduledBasedOnSelected: String = String.blank
    var addAnotherClicked: String = String.blank

    var landingPage: String = String.blank
    var landingForm: String = String.blank
    
    var isSelectLandingSelected: Bool = false
    var isSelectFormsSelected: Bool = false
    var isLeadStatusChangeSelected: Bool = false
    var isInitialStatusSelected: Bool = false
    var isFinalStatusSelected: Bool = false
    
    var isTriggerForLeadContain: Bool = false
    var isInitialStatusContain: String = ""
    var isFinalStatusContain: String = ""
    var smsandTimeArray = Array<Any>()
    var isTriggerFrequency: String = ""
    
    var iterationCounter = 0
    var orderCount = 0
    
    var addNewCheckCreate: Bool = true
    var showBorderLineCreate: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        dateFormater = DateFormater()
        leadSourceArray = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook", "Integrately"]
        appointmentStatusArray = ["Pending", "Confirmed", "Completed", "Canceled", "Updated"]
        triggerCreateScrollview.delegate = self
        
        let emailSMS = TriggerDetailModel(cellType: "Default", LastName: "")
        triggerDetailList.append(emailSMS)
        
        viewModel = TriggerDetailViewModel(delegate: self)
        submitBtn.isEnabled = false
        submitBtn.backgroundColor = UIColor(hexString: "#6AC1E7")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTriggerDetails()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.createTrigger
    }
    
    @objc func getTriggerDetails() {
        self.view.ShowSpinner()
        viewModel?.getTriggerDetailList()
    }
    
    func triggerDetailDataRecived() {
        viewModel?.getLandingPageNames()
    }
    
    func triggerLandingPageNamesDataRecived() {
        viewModel?.getTriggerQuestionnaires()
    }
    
    func triggerQuestionnairesDataRecived() {
        viewModel?.getTriggerLeadSourceUrl()
    }
    
    func triggerLeadSourceUrlDataRecived() {
        viewModel?.getTriggerLeadTagsList()
    }
    
    func triggerLeadTagsDataRecived() {
        self.view.HideSpinner()
    }
    
    func triggerSMSPatientStatusAllDataRecived() {
        self.view.HideSpinner()
        let emailSMS = TriggerDetailModel(cellType: "Both", LastName: "")
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
    
    func bothInsertDataReceived() {
        self.view.HideSpinner()
        let emailSMS = TriggerDetailModel(cellType: "Both", LastName: "")
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
    
    func createTriggerDataReceived() {
        triggerAppointmentCreateSucessfull()
    }
    
    func createAppointmentDataReceived() {
        triggerAppointmentCreateSucessfull()
    }
    
    func triggerAppointmentCreateSucessfull() {
        self.view.HideSpinner()
        self.view.showToast(message: "Trigger created successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    var triggerCreateTableViewHeight: CGFloat {
        triggerdDetailTableView.layoutIfNeeded()
        return triggerdDetailTableView.contentSize.height
    }
    
    func registerTableView() {
        self.triggerdDetailTableView.delegate = self
        self.triggerdDetailTableView.dataSource = self
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerDefaultTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerSMSCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerSMSCreateTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerLeadActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerLeadActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerModuleTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerModuleTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerAppointmentActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerAppointmentActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerTimeTableViewCell")
    }
    
    func createNewTriggerCell(cellNameType: String) {
        let emailSMS = TriggerDetailModel(cellType: cellNameType, LastName: String.blank)
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight + 300
    }
    
    @IBAction func submitButtonAction(sender: UIButton) {
        self.smsandTimeArray = []
        
        if moduleSelectionType == "lead" {
        
            var triggerDataDict = [String: Any]()
            var isfromLeadStatus: String = ""
            var istoLeadStatus: String = ""
            var isTriggerForLeadContain: Bool = false
            var isModuleSelectionType: String = ""
            
            for index in 0..<(self.triggerDetailList.count) {
                
                let cellIndexPath = IndexPath(row: index, section: 0)
                var templateId: Int = 0
                let triggerDetailList = self.triggerDetailList[cellIndexPath.row]
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
                    
                    if bothCreateCell.selectedTriggerTarget == "Leads" {
                        bothCreateCell.selectedTriggerTarget = "lead"
                    }
                    
                    if bothCreateCell.networkTypeSelected == "SMS" {
                        templateId = Int(bothCreateCell.selectedSmsTemplateId) ?? 0
                    } else if bothCreateCell.networkTypeSelected == "EMAIL" {
                        templateId = Int(bothCreateCell.selectedemailTemplateId) ?? 0
                    } else {
                        templateId = Int(bothCreateCell.selectedemailTemplateId) ?? 0
                    }
                    
                    triggerDataDict = ["actionIndex": 3,
                                       "triggerTemplate": templateId,
                                       "triggerType": bothCreateCell.networkTypeSelected.uppercased(),
                                       "triggerTarget":  bothCreateCell.selectedTriggerTarget,
                                       "taskName": bothCreateCell.taskNameTextField.text ?? ""
                    ]
                    
                } else if triggerDetailList.cellType == "Time" {
                    guard let timeCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell else { return  }
                    if let text = timeCell.timeHourlyTextField.text, !text.isEmpty {
                        isTriggerFrequency = text
                    } else {
                        isTriggerFrequency = "Min"
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
                    
                    if iterationCounter == 0 {
                        orderCount = 0
                    } else if iterationCounter == 1 {
                        orderCount = orderCount + 2
                    } else  {
                        orderCount = orderCount + 1
                    }
                    
                    if iterationCounter == 0 {
                        if self.triggerDetailList.count == 5 {
                            addNewCheckCreate = true
                            showBorderLineCreate = false
                        } else {
                            addNewCheckCreate = false
                            showBorderLineCreate = true
                        }
                    } else {
                        if index == self.triggerDetailList.count - 1 {
                            addNewCheckCreate = true
                            showBorderLineCreate = false
                        } else {
                            addNewCheckCreate = false
                            showBorderLineCreate = true
                        }
                    }
                    
                    iterationCounter += 1

                    let timeDict: [String : Any] = [
                        "addNew": addNewCheckCreate,
                        "showBorder": showBorderLineCreate,
                        "orderOfCondition": orderCount,
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
            let leadTags: [String] = []
            if isfromLeadStatus == "" && istoLeadStatus == "" {
                urlParameter = ["name": moduleName, "moduleName": "leads", "triggeractionName": "Pending", "triggerConditions": selectedLeadSources, "triggerData": smsandTimeArray, "landingPageNames": selectedLeadLandingPagesdict, "forms": selectedleadFormsdict, "sourceUrls": selectedLeadSourceUrldict, "leadTags": leadTags, "isTriggerForLeadStatus": isTriggerForLeadContain, "fromLeadStatus": NSNull(), "toLeadStatus": NSNull()
                ]
            } else {
                urlParameter = ["name": moduleName, "moduleName": "leads", "triggeractionName": "Pending", "triggerConditions": selectedLeadSources, "triggerData": smsandTimeArray, "landingPageNames": selectedLeadLandingPagesdict, "forms": selectedleadFormsdict, "sourceUrls": selectedLeadSourceUrldict, "leadTags": leadTags, "isTriggerForLeadStatus": isTriggerForLeadContain, "fromLeadStatus": isfromLeadStatus, "toLeadStatus": istoLeadStatus
                ]
            }
            self.view.ShowSpinner()
            viewModel?.createTriggerDataMethod(triggerDataParms: urlParameter)
        } else {
            
            var triggerDataDictAppointment = [String: Any]()
            var isModuleSelectionTypeAppointment: String = ""
            
            for index in 0..<(self.triggerDetailList.count) {
                let cellIndexPath = IndexPath(row: index, section: 0)
                var templateId: Int = 0
                let triggerDetailList = self.triggerDetailList[cellIndexPath.row]
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
                    
                    if bothCreateCell.networkTypeSelected == "SMS" {
                        templateId = Int(bothCreateCell.selectedSmsTemplateId) ?? 0
                    } else {
                        templateId = Int(bothCreateCell.selectedemailTemplateId) ?? 0
                    }
                
                    if bothCreateCell.selectedTriggerTarget == "Patient" {
                        bothCreateCell.selectedTriggerTarget = "AppointmentPatient"
                    } else {
                        bothCreateCell.selectedTriggerTarget = "AppointmentClinic"
                    }
                    triggerDataDictAppointment = ["actionIndex": 3,
                                                  "triggerTemplate": templateId,
                                                  "triggerType": bothCreateCell.networkTypeSelected.uppercased(),
                                                  "triggerTarget": bothCreateCell.selectedTriggerTarget,
                                                  "taskName": bothCreateCell.taskNameTextField.text ?? ""
                    ]
                    
                } else if triggerDetailList.cellType == "Time" {
                    guard let timeCell = triggerdDetailTableView.cellForRow(at: cellIndexPath) as? TriggerTimeTableViewCell else { return  }
                    let isTriggerFrequency = timeCell.timeHourlyTextField.text ?? ""
                    if iterationCounter == 0 {
                        orderCount = 0
                    } else if iterationCounter == 1 {
                        orderCount = orderCount + 2
                    } else  {
                        orderCount = orderCount + 1
                    }
                    
                    if iterationCounter == 0 {
                        if self.triggerDetailList.count == 5 {
                            addNewCheckCreate = true
                            showBorderLineCreate = false
                        } else {
                            addNewCheckCreate = false
                            showBorderLineCreate = true
                        }
                    } else {
                        if index == self.triggerDetailList.count - 1 {
                            addNewCheckCreate = true
                            showBorderLineCreate = false
                        } else {
                            addNewCheckCreate = false
                            showBorderLineCreate = true
                        }
                    }
                    
                    iterationCounter += 1
                    let timeDict: [String : Any] = [
                        "addNew": addNewCheckCreate,
                        "showBorder": showBorderLineCreate,
                        "orderOfCondition": orderCount,
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
            let triggerConditions: [String] = []
            let landingPageNames: [String] = []
            let forms: [String] = []
            let sourceUrls: [String] = []
            
            urlParameter = ["name": moduleName, "moduleName": "Appointment", "triggeractionName": appointmentSelectedStatus, "triggerConditions": triggerConditions, "triggerData": smsandTimeArray, "landingPageNames": landingPageNames, "forms": forms, "sourceUrls": sourceUrls, "leadTags": NSNull(), "isTriggerForLeadStatus": false, "fromLeadStatus": NSNull(), "toLeadStatus": NSNull()
            ]
            self.view.ShowSpinner()
            viewModel?.createAppointmentDataMethod(appointmentDataParms: urlParameter)
        }
    }    
}

extension TriggerDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight + 300
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight + 300
    }
}
