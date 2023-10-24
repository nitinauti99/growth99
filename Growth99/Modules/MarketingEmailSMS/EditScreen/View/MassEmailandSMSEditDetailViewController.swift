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
    func massSMSEditBusinessEmailSMSQuotaDataRecived()
    func massSMSEditAuditEmailSmsCountDataRecived()
    func massSMSEditAllLeadCountDataRecived()
    func massSMSEditAllPatientCountDataRecived()
    func massSMSEditInitialLeadCountDataRecived()
    func massSMSEditInitialPatientCountDataRecived()
    func massSMSEditLeadCountDataRecived()
    func massSMSEditPatientCountDataRecived()
    func massSMSEditLeadDataReceived()
    func massSMSEditPatientDataReceived()
    func massSMSEditLeadPatientDataReceived()
    func errorReceivedEdit(error: String)
}

class MassEmailandSMSEditDetailViewController: UIViewController, MassEmailandSMSEditDetailViewControlProtocol {
    
    @IBOutlet weak var emailAndSMSTableViewEdit: UITableView!
    @IBOutlet weak var triggerExicutedView: UIView!
    @IBOutlet weak var triggerExicutedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAuditButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var viewAuditButton: UIButton!
    
    @IBOutlet weak var triggerEmailReachedView: UIView!
    @IBOutlet weak var triggerEmailReachedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var triggerEmailReachedViewTop: NSLayoutConstraint!
    @IBOutlet weak var triggerEmailReachedViewBottom: NSLayoutConstraint!
    
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
    var selectedemailTemplateIdEdit: Int = 0
    
    var smsTemplatesArrayEdit = [SmsTemplateDTOListEdit]()
    var selectedSmsTemplatesEdit = [SmsTemplateDTOListEdit]()
    var selectedSmsTemplateIdEdit: Int = 0
    
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
    var triggerCommunicationType: String = ""
    
    var selectedTimeSlotEdit: String = String.blank
    
    var leadSourceArrayEdit: [String] = []
    var appointmentStatusArrayEdit: [String] = []
    var selectedLeadSourcesEdit: [String] = []
    var modelData: MassSMSEditModel?
    
    var patientTypeSelected: Bool = false
    var leadTypeSelected: Bool = false
    var leadPatientBothSelected: Bool = false
    var defaultNextSelected: Bool = false
    var dateFormater: DateFormaterProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        registerTableView()
        dateFormaterEdit = DateFormater()
        viewModelEdit = MassEmailandSMSEditDetailViewModel(delegate: self)
        leadSourceArrayEdit = ["ChatBot", "Landing Page", "Self Assessment", "Form", "Manual","Facebook", "Integrately"]
        appointmentStatusArrayEdit = ["Pending", "Confirmed", "Completed", "Canceled", "Updated"]
        self.dateFormater = DateFormater()
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
    
    func massSMSEditBusinessEmailSMSQuotaDataRecived() {
        viewModelEdit?.getMassSMSEditAuditEmailQuotaMethod()
    }
    
    func massSMSEditAuditEmailSmsCountDataRecived() {
        self.viewModelEdit?.getMassSMSEditAllLeadMethod()
    }
    
    func isResultPositive() -> Bool {
        guard let businessEmailCount = viewModelEdit?.getMassSMSEditBusniessEmailSmsQuotaData?.emailLimit,
              let auditEmailCount = viewModelEdit?.getMassSMSEditAuditEmailSmsCount?.emailCount else {
            return false
        }
        let emailCount = businessEmailCount - auditEmailCount
        return emailCount > 0
    }
    
    @IBAction func navigateToAuditScreen(sFender: UIButton) {
        let auditVC = UIStoryboard(name: "AuditListViewController", bundle: nil).instantiateViewController(withIdentifier: "AuditListViewController") as! AuditListViewController
        auditVC.auditIdInfo = modelData?.id ?? 0
        auditVC.communicationTypeStr = triggerCommunicationType
        auditVC.triggerModuleStr = modelData?.moduleName ?? ""
        navigationController?.pushViewController(auditVC, animated: true)
    }
    
    func massSMSEditAllLeadCountDataRecived() {
        viewModelEdit?.getMassSMSEditAllPatientMethod()
    }
    
    func massSMSEditAllPatientCountDataRecived() {
        let leadStatusData = viewModelEdit?.getMassSMSTriggerEditListData?.triggerConditions ?? []
        let leadSourceData = viewModelEdit?.getMassSMSTriggerEditListData?.source ?? []
        var leadTagsArrayEdit = [MassEmailSMSTagListModelEdit]()
        for landingItem in viewModelEdit?.getMassSMSTriggerEditListData?.leadTags ?? [] {
            let getLandingData = viewModelEdit?.getMassSMSEditLeadTagsListData?.filter({ $0.id == landingItem})
            for landingChildItem in getLandingData ?? [] {
                let landArr = MassEmailSMSTagListModelEdit(name: landingChildItem.name ?? "", isDefault:  landingChildItem.isDefault ?? false, id: landingChildItem.id ?? 0)
                leadTagsArrayEdit.append(landArr)
            }
        }
        let formattedArray = leadTagsArrayEdit.map{String($0.id ?? 0)}.joined(separator: ",")
        viewModelEdit?.getMassSMSEditInitialLeadCountsMethod(leadStatus: leadStatusData.joined(separator: ","),
                                                             moduleName: "MassLead", leadTagIds: formattedArray,
                                                             source: leadSourceData.joined(separator: ","))
    }
    
    func massSMSEditInitialLeadCountDataRecived() {
        let patienttatusData = viewModelEdit?.getMassSMSTriggerEditListData?.triggerConditions ?? []
        var patientTagsArrayEdit = [MassEmailSMSTagListModelEdit]()
        let patientStatusData = viewModelEdit?.getMassSMSTriggerEditListData?.patientStatus ?? []
        for landingItem in viewModelEdit?.getMassSMSTriggerEditListData?.patientTags ?? [] {
            let getLandingData = viewModelEdit?.getMassSMSEditPateintsTagsListData?.filter({ $0.id == landingItem})
            for landingChildItem in getLandingData ?? [] {
                let landArr = MassEmailSMSTagListModelEdit(name: landingChildItem.name ?? "", isDefault:  landingChildItem.isDefault ?? false, id: landingChildItem.id ?? 0)
                patientTagsArrayEdit.append(landArr)
            }
        }
        let formattedArray = patientTagsArrayEdit.map{String($0.id ?? 0)}.joined(separator: ",")
        viewModelEdit?.getMassSMSEditInitialPatientCountMethod(appointmentStatus: patienttatusData.joined(separator: ","),
                                                               moduleName: "MassPatient", patientTagIds: formattedArray, patientStatus: patientStatusData.joined(separator: ","))
    }
    
    func massSMSEditInitialPatientCountDataRecived() {
        self.view.HideSpinner()
        modelData = viewModelEdit?.getMassSMSTriggerEditListData
        let defaultScreen = MassEmailandSMSDetailModelEdit(cellType: "Default", LastName: "")
        let moduleScreen = MassEmailandSMSDetailModelEdit(cellType: "Module", LastName: "")
        let leadScreen = MassEmailandSMSDetailModelEdit(cellType: "Lead", LastName: "")
        let appointmentScreen = MassEmailandSMSDetailModelEdit(cellType: "Appointment", LastName: "")
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
        if modelData?.executionStatus == "COMPLETED" {
            viewAuditButtonHeight.constant = 35
            triggerExicutedViewHeight.constant = 90
        } else {
            viewAuditButtonHeight.constant = 0
            triggerExicutedViewHeight.constant = 0
        }
        let isPositive = isResultPositive()
        if isPositive {
            triggerEmailReachedViewHeight.constant = 0
            triggerEmailReachedViewTop.constant = 0
            triggerEmailReachedViewBottom.constant = 0
        } else {
            triggerEmailReachedViewHeight.constant = 60
            triggerEmailReachedViewTop.constant = 10
            triggerEmailReachedViewBottom.constant = 10
        }
        emailAndSMSTableViewEdit.reloadData()
    }
    
    func errorReceivedEdit(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
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
    
    func massSMSEditLeadDataReceived() {
        massSMSAppointmentUpdatedSucessfull()
    }
    
    func massSMSEditPatientDataReceived() {
        massSMSAppointmentUpdatedSucessfull()
    }
    
    func massSMSEditLeadPatientDataReceived() {
        massSMSAppointmentUpdatedSucessfull()
    }
    
    func massSMSAppointmentUpdatedSucessfull() {
        self.view.HideSpinner()
        self.view.showToast(message: "Trigger updated successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
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
