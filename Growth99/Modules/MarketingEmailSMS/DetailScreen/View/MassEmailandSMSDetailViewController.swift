//
//  MassEmailandSMSDetailViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSDetailViewControlProtocol: AnyObject {
    func massEmailDetailDataRecived()
    func massEmailLeadTagsDataRecived()
    func massEmailPatientTagsDataRecived()
    func massEmailSMSPatientCountDataRecived()
    func massEmailSMSLeadCountDataRecived()
    func massEmailSMSBusinessQuotaCountDataReceived()
    func massEmailSMSAuditQuotaCountDataReceived()
    func massEmailSMSLeadStatusAllDataRecived()
    func massEmailSMSPatientStatusAllDataRecived()
    func errorReceived(error: String)
    
    func marketingMassLeadDataReceived()
    func marketingMassPatientDataReceived()
    func marketingMassLeadPatientDataReceived()
    
}

class MassEmailandSMSDetailViewController: UIViewController, MassEmailandSMSDetailViewControlProtocol {
    
    @IBOutlet weak var emailAndSMSTableView: UITableView!
    @IBOutlet weak var triggerEmailReachedView: UIView!
    @IBOutlet weak var triggerEmailReachedViewHeight: NSLayoutConstraint!

    var emailAndSMSDetailList = [MassEmailandSMSDetailModel]()
    var viewModel: MassEmailandSMSDetailViewModelProtocol?
    var leadTagsArray = [MassEmailSMSTagListModel]()
    var patientTagsArray = [MassEmailSMSPTagListModel]()
    
    var selectedLeadTags = [MassEmailSMSTagListModel]()
    var selectedLeadTagIds: String = String.blank
    
    var selectedPatientTags = [MassEmailSMSPTagListModel]()
    var selectedPatientTagIds: String = String.blank
    
    var emailTemplatesArray = [EmailTemplateDTOList]()
    var selectedEmailTemplates = [EmailTemplateDTOList]()
    var selectedemailTemplateId: Int = 0
    
    var smsTemplatesArray = [SmsTemplateDTOList]()
    var selectedSmsTemplates = [SmsTemplateDTOList]()
    var selectedSmsTemplateId: Int = 0
    
    var dateFormater: DateFormaterProtocol?
    var patientAppointmentStatus: String = String.blank
    var leadSource: String = String.blank
    
    var paymentStatusSelected: [String] = []
    var leadStatusSelected: [String] = []
    var leadSourceSelected: [String] = []
    var appointmentStatusSelected: [String] = []
    var smsEmailModuleSelectionType: String = String.blank
    var smsEmailTargetSelectionType: String = String.blank
    
    var moduleName: String = String.blank
    var marketingTriggersData = [MarketingTriggerData]()
    
    var networkTypeSelected: String = String.blank
    var templateId: Int = 0
    var massAppointmnentId: Int = 0
    
    var selectedTimeSlot: String = String.blank
    var leadSourceArray: [String] = []
    var appointmentStatusArray: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        
        leadSourceArray = ["ChatBot", "Landing Page", "Self Assessment", "Form", "Manual","Facebook", "Integrately"]

        appointmentStatusArray = ["Pending", "Confirmed", "Completed", "Canceled", "Updated"]

        dateFormater = DateFormater()
        let emailSMS = MassEmailandSMSDetailModel(cellType: "Default", LastName: "")
        emailAndSMSDetailList.append(emailSMS)
        viewModel = MassEmailandSMSDetailViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMassEmailandSMSDetails()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.createMassEmailSMS
    }
    // 1 API
    @objc func getMassEmailandSMSDetails() {
        self.view.ShowSpinner()
        viewModel?.getMassEmailDetailList()
    }
    
    // 2 API
    func massEmailDetailDataRecived() {
        viewModel?.getMassEmailLeadTagsList()
    }
    
    // 3 API
    func massEmailLeadTagsDataRecived() {
        viewModel?.getMassEmailPateintsTagsList()
    }
    
    // 4 API
    func massEmailPatientTagsDataRecived() {
        viewModel?.getMassEmailBusinessSMSQuotaMethod()
    }
    
    // 5 API
    func massEmailSMSBusinessQuotaCountDataReceived() {
        viewModel?.getMassEmailAuditEmailQuotaMethod()
    }
    
    // 6 API
    func massEmailSMSAuditQuotaCountDataReceived() {
        let isPositive = isResultPositive()
        if isPositive {
            triggerEmailReachedViewHeight.constant = 0
        } else {
            triggerEmailReachedViewHeight.constant = 60
        }
        self.view.HideSpinner()
    }
    
    func massEmailSMSPatientCountDataRecived() {
        bothInsertDataReceived()
    }
    
    func massEmailSMSLeadCountDataRecived() {
        bothInsertDataReceived()
    }
    
    func massEmailSMSLeadStatusAllDataRecived() {
        viewModel?.getMassEmailPatientStatusAllMethod()
    }
    
    func marketingMassLeadDataReceived() {
        smsEmailSubmitReponseReceived()
    }
    
    func marketingMassPatientDataReceived() {
        smsEmailSubmitReponseReceived()
    }
    
    func marketingMassLeadPatientDataReceived() {
        smsEmailSubmitReponseReceived()
    }
    
    func isResultPositive() -> Bool {
        guard let businessEmailCount = viewModel?.getmassEmailSMSBusinessQuotaCountData?.emailLimit,
              let auditEmailCount = viewModel?.getmassEmailSMSAuditQuotaCountData?.emailCount else {
            return false
        }
        let emailCount = businessEmailCount - auditEmailCount
        return emailCount > 0
    }
    
    func smsEmailSubmitReponseReceived() {
        self.view.HideSpinner()
        self.view.showToast(message: "Trigger created successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func massEmailSMSPatientStatusAllDataRecived() {
        self.view.HideSpinner()
        createNewMassEmailSMSCell(cellNameType: "Both")
        self.scrollToBottom()
    }
    
    func bothInsertDataReceived() {
        self.view.HideSpinner()
        createNewMassEmailSMSCell(cellNameType: "Both")
        self.scrollToBottom()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func registerTableView() {
        self.emailAndSMSTableView.delegate = self
        self.emailAndSMSTableView.dataSource = self
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSDefaultTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSCreateTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSLeadActionTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSLeadActionTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSModuleTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSModuleTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSPatientActionTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSPatientActionTableViewCell")
        self.emailAndSMSTableView.register(UINib(nibName: "MassEmailandSMSTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSTimeTableViewCell")
    }
    
    func createNewMassEmailSMSCell(cellNameType: String) {
        let emailSMS = MassEmailandSMSDetailModel(cellType: cellNameType, LastName: "")
        emailAndSMSDetailList.append(emailSMS)
        emailAndSMSTableView.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
        emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableView.endUpdates()
    }
}
