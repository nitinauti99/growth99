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
    var finalArray = [TriggerEditData]()
    var triggerEditChildData: [TriggerEditData] = []
    
    
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
    
    func registerTableView() {
        self.triggerdDetailTableView.delegate = self
        self.triggerdDetailTableView.dataSource = self
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerEditDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditDefaultTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerLeadEditActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerLeadEditActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerEditModuleTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditModuleTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerEditAppointmentActionTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerEditAppointmentActionTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "TriggerParentCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "TriggerParentCreateTableViewCell")
        self.triggerdDetailTableView.register(UINib(nibName: "BottomTableViewCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "BottomTableViewCell")
    }
    
    var triggerCreateTableViewHeight: CGFloat {
        triggerdDetailTableView.layoutIfNeeded()
        return triggerdDetailTableView.contentSize.height + 500
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
        addTriggerEditDetailModel(cellType: "Both")
    }
    
    func bothInsertDataReceived() {
        self.view.HideSpinner()
        addTriggerEditDetailModel(cellType: "Both")
    }
    
    private func addTriggerEditDetailModel(cellType: String) {
        let emailSMS = TriggerEditDetailModel(cellType: cellType, LastName: "")
        triggerDetailList.append(emailSMS)
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
        triggerdDetailTableView.reloadData()
        triggerCreateScrollviewHeight.constant = triggerCreateTableViewHeight
        self.view.layoutIfNeeded()
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
