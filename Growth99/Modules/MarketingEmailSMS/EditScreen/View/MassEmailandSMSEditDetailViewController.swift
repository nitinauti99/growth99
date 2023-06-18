//
//  MassEmailandSMSEditDetailViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSEditDetailViewControlProtocol: AnyObject {
    func massEmailDetailDataRecivedEdit()
    func massEmailLeadTagsDataRecivedEdit()
    func massEmailPatientTagsDataRecivedEdit()
    func massEmailSMSPatientCountDataRecivedEdit()
    func massEmailSMSLeadCountDataRecivedEdit()
    func massEmailSMSEQuotaCountDataReceivedEdit()
    func massEmailSMSAuditQuotaCountDataReceivedEdit()
    func massEmailSMSLeadStatusAllDataRecivedEdit()
    func massEmailSMSPatientStatusAllDataRecivedEdit()
    func errorReceivedEdit(error: String)
    func marketingMassLeadDataReceivedEdit()
    func marketingMassPatientDataReceivedEdit()
    func marketingMassLeadPatientDataReceivedEdit()
}

class MassEmailandSMSEditDetailViewController: UIViewController, MassEmailandSMSEditDetailViewControlProtocol {

    @IBOutlet weak var emailAndSMSTableViewEdit: UITableView!
    
    var emailAndSMSDetailListEdit = [MassEmailandSMSDetailModelEdit]()
    var viewModelEdit: MassEmailandSMSEditDetailViewModelProtocol?
    var leadTagsArrayEdit = [MassEmailSMSTagListModelEdit]()
    var patientTagsArrayEdit = [MassEmailSMSTagListModelEdit]()
    
    var selectedLeadTagsEdit = [MassEmailSMSTagListModelEdit]()
    var selectedLeadTagIdsEdit: String = String.blank

    var selectedPatientTagsEdit = [MassEmailSMSTagListModelEdit]()
    var selectedPatientTagIdsEdit: String = String.blank
    
    var emailTemplatesArrayEdit = [EmailTemplateDTOListEdit]()
    var selectedEmailTemplatesEdit = [EmailTemplateDTOListEdit]()
    var selectedemailTemplateIdEdit: String = String.blank
    
    var smsTemplatesArrayEdit = [SmsTemplateDTOListEdit]()
    var selectedSmsTemplatesEdit = [SmsTemplateDTOListEdit]()
    var selectedSmsTemplateIdEdit: String = String.blank
    
    var dateFormaterEdit: DateFormaterProtocol?
    var patientAppointmentStatusEdit: String = String.blank
    var leadSourceEdit: String = String.blank
    
    var paymentStatusSelectedEdit: [String] = []
    var leadStatusSelectedEdit: [String] = []
    var leadSourceSelectedEdit: [String] = []
    var appointmentStatusSelectedEdit: [String] = []
    var smsEmailModuleSelectionTypeEdit: String = String.blank
    var smsEmailTargetSelectionTypeEdit: String = String.blank

    var moduleNameEdit: String = String.blank
    var marketingTriggersDataEdit = [MarketingTriggerDataEdit]()
    
    var networkTypeSelectedEdit: String = String.blank
    var templateIdEdit: Int = 0
    var massAppointmnentIdEdit: Int = 0

    var selectedTimeSlotEdit: String = String.blank

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        dateFormaterEdit = DateFormater()
        let emailSMS = MassEmailandSMSDetailModelEdit(cellType: "Default", LastName: "")
        emailAndSMSDetailListEdit.append(emailSMS)
        viewModelEdit = MassEmailandSMSEditDetailViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMassEmailandSMSDetailsEdit()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.createMassEmailSMS
    }
    
    @objc func getMassEmailandSMSDetailsEdit() {
        self.view.ShowSpinner()
        viewModelEdit?.getMassEmailDetailListEdit()
    }
    
    func massEmailDetailDataRecivedEdit() {
        viewModelEdit?.getMassEmailLeadTagsListEdit()
    }
    
    func massEmailLeadTagsDataRecivedEdit() {
        viewModelEdit?.getMassEmailPateintsTagsListEdit()
    }
    
    func massEmailPatientTagsDataRecivedEdit() {
        viewModelEdit?.getMassEmailBusinessSMSQuotaMethodEdit()
    }

    func massEmailSMSPatientCountDataRecivedEdit() {
        bothInsertDataReceivedEdit()
    }
    
    func massEmailSMSLeadCountDataRecivedEdit() {
        bothInsertDataReceivedEdit()
    }
    
    func massEmailSMSEQuotaCountDataReceivedEdit() {
        viewModelEdit?.getMassEmailAuditEmailQuotaMethodEdit()
    }
    
    func massEmailSMSAuditQuotaCountDataReceivedEdit() {
        self.view.HideSpinner()
    }
    
    func massEmailSMSLeadStatusAllDataRecivedEdit() {
        viewModelEdit?.getMassEmailPatientStatusAllMethodEdit()
    }
    
    func marketingMassLeadDataReceivedEdit() {
        smsEmailSubmitReponseReceivedEdit()
    }
    
    func marketingMassPatientDataReceivedEdit() {
        smsEmailSubmitReponseReceivedEdit()
    }
    
    func marketingMassLeadPatientDataReceivedEdit() {
        smsEmailSubmitReponseReceivedEdit()
    }
    
    func smsEmailSubmitReponseReceivedEdit() {
        self.view.HideSpinner()
        self.view.showToast(message: "Trigger created successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func massEmailSMSPatientStatusAllDataRecivedEdit() {
        self.view.HideSpinner()
        createNewMassEmailSMSCell(cellNameType: "Both")
    }
    
    func bothInsertDataReceivedEdit() {
        self.view.HideSpinner()
        createNewMassEmailSMSCell(cellNameType: "Both")
    }
    
    func errorReceivedEdit(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func registerTableView() {
        self.emailAndSMSTableViewEdit.delegate = self
        self.emailAndSMSTableViewEdit.dataSource = self
        self.emailAndSMSTableViewEdit.register(UINib(nibName: "MassEmailandSMSEditDefaultTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSEditDefaultTableViewCell")
        self.emailAndSMSTableViewEdit.register(UINib(nibName: "MassEmailandSMSEditCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSEditCreateTableViewCell")
        self.emailAndSMSTableViewEdit.register(UINib(nibName: "MassEmailandSMSEditLeadActionTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSEditLeadActionTableViewCell")
        self.emailAndSMSTableViewEdit.register(UINib(nibName: "MassEmailandSMSEditModuleTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSEditModuleTableViewCell")
        self.emailAndSMSTableViewEdit.register(UINib(nibName: "MassEmailandSMSEditPatientActionTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSEditPatientActionTableViewCell")
        self.emailAndSMSTableViewEdit.register(UINib(nibName: "MassEmailandSMSEditTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "MassEmailandSMSEditTimeTableViewCell")
    }
    
    func createNewMassEmailSMSCell(cellNameType: String) {
        let emailSMS = MassEmailandSMSDetailModelEdit(cellType: cellNameType, LastName: "")
        emailAndSMSDetailListEdit.append(emailSMS)
        emailAndSMSTableViewEdit.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailListEdit.count) - 1, section: 0)
        emailAndSMSTableViewEdit.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableViewEdit.endUpdates()
    }
}
