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
    
    var triggerDetailList = [TriggerEditDetailModel]()
    var viewModel: TriggerEditDetailViewModelProtocol?
    var leadTagsArray = [TriggerEditTagListModel]()
    var patientTagsArray = [TriggerEditTagListModel]()
    
    var selectedLeadTags = [TriggerEditTagListModel]()
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
    
    var selectedTriggerTime: String = String.blank
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
    
    var landingPage: String = String.blank
    var landingForm: String = String.blank
    
    var triggerId: Int?
    
    var triggerEditChildData : [TriggerEditData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        dateFormater = DateFormater()
        leadSourceArray = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook", "Integrately"]

        appointmentStatusArray = ["Pending", "Confirmed", "Completed", "Cancelled", "Updated"]
        
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
        self.view.HideSpinner()
        
        let defaultScreen = TriggerEditDetailModel(cellType: "Default", LastName: "")
        let moduleScreen = TriggerEditDetailModel(cellType: "Module", LastName: "")
        let leadScreen = TriggerEditDetailModel(cellType: "Lead", LastName: "")
        let appointmentScreen = TriggerEditDetailModel(cellType: "Appointment", LastName: "")
        let createScreen = TriggerEditDetailModel(cellType: "Both", LastName: "")
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
            triggerDetailList.append(createScreen)
        }
        selectedLeadSources = modelData?.triggerConditions ?? []
//        selectedLeadLandingPages = modelData?.landingPages ?? []
//        selectedleadForms = modelData?.forms ?? []
//        selectedLeadSourceUrl = modelData?.sourceUrls ?? []
        triggerdDetailTableView.reloadData()
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
        triggerAppointmentCreateSucessfull()
    }
    
    func createEditAppointmentDataReceived() {
        triggerAppointmentCreateSucessfull()
    }
    
    func triggerAppointmentCreateSucessfull() {
        self.view.HideSpinner()
        self.view.showToast(message: "Trigger created sucessfully", color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    func registerTableView() {
        self.triggerdDetailTableView.delegate = self
        self.triggerdDetailTableView.dataSource = self
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerDefaultTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerLeadActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerLeadActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerModuleTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerModuleTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerAppointmentActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerAppointmentActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerParentCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerParentCreateTableViewCell")
    }
    
    func createNewTriggerCell(cellNameType: String) {
        let emailSMS = TriggerEditDetailModel(cellType: cellNameType, LastName: String.blank)
        triggerDetailList.append(emailSMS)
        triggerdDetailTableView.beginUpdates()
        let indexPath = IndexPath(row: (triggerDetailList.count) - 1, section: 0)
        triggerdDetailTableView.insertRows(at: [indexPath], with: .fade)
        triggerdDetailTableView.endUpdates()
    }
    
}
