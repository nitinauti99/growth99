//
//  MassEmailandSMSEditDetailViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSEditDetailViewControlProtocol: AnyObject {
    func massSMStriggerEditSelectedDataRecived()
    func massSMSEditDetailDataRecived()
    func massSMSEditLeadTagsDataRecived()
    func massSMSEditPatientTagsDataRecived()
    func massSMSEditEmailSmsQuotaDataRecived()
    func massSMSEditEmailSmsCountDataRecived()
    func massSMSEditAllLeadCountDataRecived()
    func massSMSEditAllPatientCountDataRecived()
    func massSMSEditLeadCountDataRecived()
    func massSMSEditPatientCountDataRecived()
    func errorReceivedEdit(error: String)
}

class MassEmailandSMSEditDetailViewController: UIViewController, MassEmailandSMSEditDetailViewControlProtocol {
    
    @IBOutlet weak var emailAndSMSTableViewEdit: UITableView!
    @IBOutlet weak var triggerExicutedView: UIView!
    @IBOutlet weak var triggerExicutedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAuditButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAuditButton: UIButton!

    var massSMSDetailListEdit = [MassEmailandSMSDetailModelEdit]()
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
    var massSMStriggerId: Int?

    var selectedTimeSlotEdit: String = String.blank

    var leadSourceArrayEdit: [String] = []
    var appointmentStatusArrayEdit: [String] = []
    var selectedLeadSourcesEdit: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        dateFormaterEdit = DateFormater()
        viewModelEdit = MassEmailandSMSEditDetailViewModel(delegate: self)
        leadSourceArrayEdit = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook", "Integrately"]
        appointmentStatusArrayEdit = ["Pending", "Confirmed", "Completed", "Cancelled", "Updated"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMassEmailandSMSDetailsEdit()
    }
    
    func setUpNavigationBar() {
        self.title = "Edit Mass Email and SMS"
    }
    
    @objc func getMassEmailandSMSDetailsEdit() {
        self.view.ShowSpinner()
        viewModelEdit?.getSelectedMassSMSEditList(selectedMassSMSId: massSMStriggerId ?? 0)
    }
    
    func massSMStriggerEditSelectedDataRecived() {
        viewModelEdit?.getMassSMSEditDetailList()
    }
    
    func massSMSEditDetailDataRecived() {
        viewModelEdit?.getMassSMSEditLeadTagsList()
    }
    
    func massSMSEditLeadTagsDataRecived() {
        viewModelEdit?.getMassSMSEditPateintsTagsList()
    }
    
    func massSMSEditPatientTagsDataRecived() {
        viewModelEdit?.getMassSMSEditBusinessSMSQuotaMethod()
    }

    func massSMSEditEmailSmsQuotaDataRecived() {
        viewModelEdit?.getMassSMSEditAuditEmailQuotaMethod()
    }
    
    func massSMSEditEmailSmsCountDataRecived() {
        self.view.HideSpinner()
        let modelData = viewModelEdit?.getMassSMSTriggerEditListData
        let defaultScreen = MassEmailandSMSDetailModelEdit(cellType: "Default", LastName: "")
        let moduleScreen = MassEmailandSMSDetailModelEdit(cellType: "Module", LastName: "")
        let leadScreen = MassEmailandSMSDetailModelEdit(cellType: "Lead", LastName: "")
        let appointmentScreen = MassEmailandSMSDetailModelEdit(cellType: "Appointment", LastName: "")
        if modelData?.executionStatus == "COMPLETED" {
            viewAuditButtonHeight.constant = 35
            triggerExicutedViewHeight.constant = 90
        } else {
            viewAuditButtonHeight.constant = 0
            triggerExicutedViewHeight.constant = 0
        }
        
        if modelData?.name != "" && modelData?.moduleName != "" {
            massSMSDetailListEdit.append(defaultScreen)
            massSMSDetailListEdit.append(moduleScreen)
            if modelData?.moduleName == "MassLead" {
                massSMSDetailListEdit.append(leadScreen)
            } else if modelData?.moduleName == "MassPatient" {
                massSMSDetailListEdit.append(appointmentScreen)
            }
            let createScreen = MassEmailandSMSDetailModelEdit(cellType: "Both", LastName: "")
            let timeScreen = MassEmailandSMSDetailModelEdit(cellType: "Time", LastName: "")
            massSMSDetailListEdit.append(createScreen)
            massSMSDetailListEdit.append(timeScreen)
        }
        selectedLeadSourcesEdit = modelData?.triggerConditions ?? []
        
        emailAndSMSTableViewEdit.reloadData()
    }
    
    func errorReceivedEdit(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func massSMSEditAllLeadCountDataRecived() {
        viewModelEdit?.getMassSMSEditAllPatientMethod()
    }
    
    func massSMSEditAllPatientCountDataRecived() {
        self.view.HideSpinner()
    }
    
    func massSMSEditLeadCountDataRecived() {
        bothCellDataCreate()
    }
    
    func massSMSEditPatientCountDataRecived() {
        bothCellDataCreate()
    }
    
    func bothCellDataCreate() {
        self.view.HideSpinner()
        createNewMassEmailSMSCell(cellNameType: "Both")
        scrollToBottom()
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
        massSMSDetailListEdit.append(emailSMS)
        DispatchQueue.main.async {
            self.emailAndSMSTableViewEdit.beginUpdates()
            let indexPath = IndexPath(row: self.massSMSDetailListEdit.count - 1, section: 0)
            self.emailAndSMSTableViewEdit.insertRows(at: [indexPath], with: .fade)
            self.emailAndSMSTableViewEdit.endUpdates()
        }
    }
}
