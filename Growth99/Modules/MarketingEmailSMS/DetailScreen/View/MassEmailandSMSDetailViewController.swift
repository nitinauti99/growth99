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
    func massEmailSMSEQuotaCountDataReceived()
    func massEmailSMSAuditQuotaCountDataReceived()
    func massEmailSMSLeadStatusAllDataRecived()
    func massEmailSMSPatientStatusAllDataRecived()
    func errorReceived(error: String)
}

class MassEmailandSMSDetailViewController: UIViewController, MassEmailandSMSDetailViewControlProtocol {
    
    @IBOutlet weak var emailAndSMSTableView: UITableView!
    
    var emailAndSMSDetailList = [MassEmailandSMSDetailModel]()
    var viewModel: MassEmailandSMSDetailViewModelProtocol?
    var leadTagsArray = [MassEmailSMSTagListModel]()
    var patientTagsArray = [MassEmailSMSTagListModel]()
    
    var selectedLeadTags = [MassEmailSMSTagListModel]()
    var selectedLeadTagIds: String = String.blank

    var selectedPatientTags = [MassEmailSMSTagListModel]()
    var selectedPatientTagIds: String = String.blank
    
    var emailTemplatesArray = [EmailTemplateDTOList]()
    var selectedEmailTemplates = [EmailTemplateDTOList]()
    var selectedemailTemplateId: String = String.blank
    
    var smsTemplatesArray = [SmsTemplateDTOList]()
    var selectedSmsTemplates = [SmsTemplateDTOList]()
    var selectedSmsTemplateId: String = String.blank
    
    var dateFormater: DateFormaterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
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
    
    @objc func getMassEmailandSMSDetails() {
        self.view.ShowSpinner()
        viewModel?.getMassEmailDetailList()
    }
    
    func massEmailDetailDataRecived() {
        viewModel?.getMassEmailLeadTagsList()
    }
    
    func massEmailLeadTagsDataRecived() {
        viewModel?.getMassEmailPateintsTagsList()
    }
    
    func massEmailPatientTagsDataRecived() {
        viewModel?.getMassEmailBusinessSMSQuotaMethod()
    }

    func massEmailSMSPatientCountDataRecived() {
        bothInsertDataReceived()
    }
    
    func massEmailSMSLeadCountDataRecived() {
        bothInsertDataReceived()
    }
    
    func massEmailSMSEQuotaCountDataReceived() {
        viewModel?.getMassEmailAuditEmailQuotaMethod()
    }
    
    func massEmailSMSAuditQuotaCountDataReceived() {
        self.view.HideSpinner()
    }
    
    func massEmailSMSLeadStatusAllDataRecived() {
        viewModel?.getMassEmailPatientStatusAllMethod()
    }

    func massEmailSMSPatientStatusAllDataRecived() {
        self.view.HideSpinner()
        let emailSMS = MassEmailandSMSDetailModel(cellType: "Both", LastName: "")
        emailAndSMSDetailList.append(emailSMS)
        emailAndSMSTableView.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
        emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableView.endUpdates()
    }
    
    func bothInsertDataReceived() {
        self.view.HideSpinner()
        let emailSMS = MassEmailandSMSDetailModel(cellType: "Both", LastName: "")
        emailAndSMSDetailList.append(emailSMS)
        emailAndSMSTableView.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
        emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableView.endUpdates()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
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
}
