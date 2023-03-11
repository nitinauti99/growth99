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
}

class TriggerDetailViewController: UIViewController, TriggerDetailViewControlProtocol {
    
    @IBOutlet weak var triggerdDetailTableView: UITableView!
    
    var triggerDetailList = [TriggerDetailModel]()
    var viewModel: TriggerDetailViewModelProtocol?
    var leadTagsArray = [TriggerTagListModel]()
    var patientTagsArray = [TriggerTagListModel]()
    
    var selectedLeadTags = [TriggerTagListModel]()
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
    var statusArray: [String] = []
    var leadStatusArray: [String] = []
    var leadSourceArray: [String] = []
    
    var landingPagesArray = [LandingPageNamesModel]()
    var landingFormsArray = [TriggerQuestionnaireModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        dateFormater = DateFormater()
        statusArray = ["Pending", "Confirmed", "Completed", "Cancelled", "Updated"]
        leadStatusArray = ["NEW", "COLD", "WARM", "HOT", "WON","DEAD"]
        leadSourceArray = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook", "Integrately"]
        let emailSMS = TriggerDetailModel(cellType: "Default", LastName: "")
        triggerDetailList.append(emailSMS)
        viewModel = TriggerDetailViewModel(delegate: self)
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
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
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
}
