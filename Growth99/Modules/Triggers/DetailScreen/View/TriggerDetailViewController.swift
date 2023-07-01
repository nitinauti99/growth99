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
    var selectedemailTemplateId: String = String.blank
    
    var smsTemplatesArray = [SmsTemplateDTOListTrigger]()
    var selectedSmsTemplates = [SmsTemplateDTOListTrigger]()
    var selectedSmsTemplateId: String = String.blank
    
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
    
    var isSelectLandingSelected: Bool = false
    var isSelectFormsSelected: Bool = false
    var isLeadStatusChangeSelected: Bool = false
    var isInitialStatusSelected: Bool = false
    var isFinalStatusSelected: Bool = false
    
    var isTriggerForLeadContain: Bool = false
    var isInitialStatusContain: String = ""
    var isFinalStatusContain: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        dateFormater = DateFormater()
        leadSourceArray = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook", "Integrately"]
        appointmentStatusArray = ["Pending", "Confirmed", "Completed", "Cancelled", "Updated"]
        
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
    }
    
}
