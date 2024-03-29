//
//  ServicesListDetailViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 13/01/23.
//

import UIKit
//import DropDown

protocol ServicesListDetailViewContollerProtocol {
    func errorReceived(error: String)
    func clinicsReceived()
    func consentReceived()
    func questionnairesReceived()
    func serviceCategoriesReceived()
    func createServiceSucessfullyReceived(message: String)
    func selectedServiceDataReceived()
}

class ServicesListDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ServicesListDetailViewContollerProtocol {
    
    @IBOutlet private weak var serviceNameTextField: CustomTextField!
    @IBOutlet private weak var selectClinicTextField: CustomTextField!
    @IBOutlet private weak var serviceDurationTextField: CustomTextField!
    @IBOutlet private weak var serviceCategoryTextField: CustomTextField!
    @IBOutlet private weak var serviceCostTextField: CustomTextField!
    @IBOutlet private weak var serviceUrlTextField: CustomTextField!
    @IBOutlet private weak var depositCostTextField: CustomTextField!
    @IBOutlet private weak var serviceDescTextView: UITextView!
    @IBOutlet private weak var serviceConsentTextField: CustomTextField!
    @IBOutlet private weak var serviceQuestionarieTextField: CustomTextField!
    @IBOutlet private weak var serviceImageViewBtn: UIButton!
    @IBOutlet private weak var removeImageViewBtn: UIButton!
    @IBOutlet private weak var serviceImageView: UIImageView!
    @IBOutlet private weak var serviceImageViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var serviceImageViewTop: NSLayoutConstraint!
    @IBOutlet private weak var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var hideButton: UIButton!
    @IBOutlet private weak var disableButton: UIButton!
    @IBOutlet private weak var enableButton: UIButton!

    @IBOutlet private weak var enableCollectBtnHeightConstant: NSLayoutConstraint!
    @IBOutlet private weak var enableCollectLabelHeightConstant: NSLayoutConstraint!
    @IBOutlet private weak var enableCollectLabelTopConstant: NSLayoutConstraint!

    @IBOutlet private weak var depositCostLabelHeightConstant: NSLayoutConstraint!
    @IBOutlet private weak var depositCostLabelTopConstant: NSLayoutConstraint!

    @IBOutlet private weak var depositCostTFTopConstant: NSLayoutConstraint!
    @IBOutlet private weak var depositCostTFHeightConstant: NSLayoutConstraint!

    var screenTitle: String = String.blank
    var serviceId: Int?

    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = [Int]()
    
    var createSelectedClinicsarray = [Clinics]()
    
    var allServiceCategories = [Clinics]()
    var selectedServiceCategories = [Clinics]()
    var selectedServiceCategoriesId = Int()
    
    var allConsent = [ConsentListModel]()
    var userClinics = [ClinicsServices]()
    var selectedConsent = [ConsentListModel]()
    var servicecategory: ServiceCategory?
    var serviceClinic: Clinic?
    var consents = [Consents]()
    var questionnaires = [Questionnaires]()
    var selectedConsentIds = [Int]()
    
    var allQuestionnaires = [QuestionnaireListModel]()
    var selectedQuestionnaires = [QuestionnaireListModel]()
    var selectedQuestionnairesIds = [Int]()

    var servicesAddViewModel: ServiceListDetailViewModelProtocol?
    var imageRemoved: Bool = true
    var isPreBookingCostAllowed: Bool = false
    var showInPublicBooking: Bool = false
    var priceVaries: Bool = false
    var httpMethodType: HTTPMethod = .POST

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = screenTitle
        servicesAddViewModel = ServiceListDetailModel(delegate: self)
        getClinicInfo()
        setupUI()
        enableButton.isSelected = true
        hideButton.isSelected = false
        disableButton.isSelected = false
    }
    
    func getClinicInfo() {
        self.view.ShowSpinner()
        servicesAddViewModel?.getallClinics()
    }

    func setupUI() {
        serviceDescTextView.layer.borderColor = UIColor.gray.cgColor
        serviceDescTextView.layer.borderWidth = 1.0
        if self.title == Constant.Profile.createService {
            removeImageViewBtn.isHidden = true
            contentViewHeight.constant = 1300
            serviceImageViewHeight.constant = 0
            serviceImageViewTop.constant = 0
        } else {
            servicesAddViewModel?.getUserSelectedService(serviceID: serviceId ?? 0)
            removeImageViewBtn.isHidden = false
        }
    }
    
    func selectedServiceDataReceived() {
        self.view.HideSpinner()
        setupUserSelectedUI()
    }
    
    func setupUserSelectedUI() {
        serviceNameTextField.text = servicesAddViewModel?.getUserSelectedServiceData?.name ?? String.blank
        
        userClinics = servicesAddViewModel?.getUserSelectedServiceData?.clinics ?? []
        selectClinicTextField.text = userClinics.map({$0.clinic?.name ?? String.blank}).joined(separator: ", ")
        
        serviceDurationTextField.text = "\(servicesAddViewModel?.getUserSelectedServiceData?.durationInMinutes ?? 0)"
       
        servicecategory = servicesAddViewModel?.getUserSelectedServiceData?.serviceCategory
        serviceCategoryTextField.text = servicecategory.map({$0.name ?? String.blank})
                
        serviceCostTextField.text = forTrailingZero(temp: servicesAddViewModel?.getUserSelectedServiceData?.serviceCost ?? 0.0)
        
        serviceUrlTextField.text = servicesAddViewModel?.getUserSelectedServiceData?.serviceURL ?? String.blank
        
        depositCostTextField.text = forTrailingZero(temp: servicesAddViewModel?.getUserSelectedServiceData?.preBookingCost ?? 0.0)

        serviceDescTextView.text = servicesAddViewModel?.getUserSelectedServiceData?.description
        
        consents = servicesAddViewModel?.getUserSelectedServiceData?.consents ?? []
        serviceConsentTextField.text = consents.map({$0.name ?? String.blank}).joined(separator: ", ")
        
        questionnaires = servicesAddViewModel?.getUserSelectedServiceData?.questionnaires ?? []
        serviceQuestionarieTextField.text = questionnaires.map({$0.name ?? String.blank}).joined(separator: ", ")
        
//        let consentSelectedArray = servicesAddViewModel?.getUserSelectedServiceData?.consents ?? []
//        selectedConsent = consentSelectedArray
//
//        let questionnairesSelectedArray = servicesAddViewModel?.getUserSelectedServiceData?.questionnaires ?? []
//        selectedQuestionnaires = questionnairesSelectedArray
                
        if servicesAddViewModel?.getUserSelectedServiceData?.showInPublicBooking == true {
            disableButton.isSelected = true
        } else {
            disableButton.isSelected = false
        }
        
        if servicesAddViewModel?.getUserSelectedServiceData?.priceVaries == true {
            hideButton.isSelected = true
            enableButton.isSelected = false
            depositCostTextField.text = String.blank
            enableCollectLabelHeightConstant.constant = 0
            enableCollectBtnHeightConstant.constant = 0
            enableCollectLabelTopConstant.constant = 0
            depositCostLabelTopConstant.constant = 0
            depositCostLabelHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
            depositCostTFHeightConstant.constant = 0
            depositCostTextField.isHidden = true
        } else {
            hideButton.isSelected = false
            enableButton.isSelected = true
            depositCostTextField.isHidden = false
            enableCollectLabelHeightConstant.constant = 36
            enableCollectBtnHeightConstant.constant = 15
            enableCollectLabelTopConstant.constant = 16
            depositCostLabelTopConstant.constant = 0
            depositCostLabelHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
            depositCostTFHeightConstant.constant = 0
        }
        
        if servicesAddViewModel?.getUserSelectedServiceData?.isPreBookingCostAllowed == true {
            depositCostTextField.isHidden = false
            depositCostTFHeightConstant.constant = 45
            depositCostTFTopConstant.constant = 10
        } else {
            depositCostTextField.isHidden = true
            depositCostTFHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
        }
        
        let imageUrl = servicesAddViewModel?.getUserSelectedServiceData?.imageUrl
        if imageUrl?.isEmpty ?? true {
            serviceImageView.image = nil
            serviceImageViewHeight.constant = 0
            serviceImageViewTop.constant = 0
            contentViewHeight.constant = 1300
            removeImageViewBtn.isHidden = true
        } else {
            self.serviceImageView.sd_setImage(with: URL(string: servicesAddViewModel?.getUserSelectedServiceData?.imageUrl ?? String.blank), placeholderImage: nil)
        }
    }
    
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    
    func clinicsReceived() {
        allClinics = servicesAddViewModel?.getAllClinicsData ?? []
        let selectedClincId = allClinics.map({$0.id ?? 0})
        self.servicesAddViewModel?.getallServiceCategories(selectedClinics: selectedClincId)
    }
    
    func serviceCategoriesReceived() {
        allServiceCategories = servicesAddViewModel?.getAllServiceCategoriesData ?? []
        servicesAddViewModel?.getallConsents()
    }
    
    func consentReceived() {
        allConsent = servicesAddViewModel?.getAllConsentsData ?? []
        servicesAddViewModel?.getallQuestionnaires()
    }
    
    func questionnairesReceived() {
        allQuestionnaires = servicesAddViewModel?.getAllQuestionnairesData ?? []
        self.view.HideSpinner()
    }
    
    func createServiceSucessfullyReceived(message: String) {
        self.view.HideSpinner()
        if message == Constant.Profile.createService {
            self.view.showToast(message: "Service Create Sucessfully", color: .black)
        } else {
            self.view.showToast(message: "Service Updated Sucessfully", color: .black)
        }
        self.navigationController?.popViewController(animated: true)
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.selectClinicTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.selectClinicTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedClincs  = selectedList
            self?.selectedClincIds = selectedId
            self?.view.ShowSpinner()
            self?.servicesAddViewModel?.getallServiceCategories(selectedClinics: selectedId)
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allClinics.count * 44))), arrowDirection: .up), from: self)
    }

    @IBAction func serviceDurationButtonAction(sender: UIButton) {
        let leadStatusArray = ["5","10", "15", "20", "30", "45", "60", "90", "120", "150", "180"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.serviceDurationTextField.text = selectedItem
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadStatusArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectConsentButtonAction(sender: UIButton) {
        if selectedConsent.count == 0 {
            self.serviceConsentTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allConsent, cellType: .subTitle) { (cell, allConsent, indexPath) in
            cell.textLabel?.text = allConsent.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedConsent) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.serviceConsentTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedConsent = selectedList
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedConsentIds = selectedId
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allConsent.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectQuestionButtonAction(sender: UIButton) {
        if selectedQuestionnaires.count == 0 {
            self.serviceQuestionarieTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allQuestionnaires, cellType: .subTitle) { (cell, allQuestionnaires, indexPath) in
            cell.textLabel?.text = allQuestionnaires.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedQuestionnaires) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.serviceQuestionarieTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            self?.selectedQuestionnaires = selectedList
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedQuestionnairesIds = selectedId
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allQuestionnaires.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func serviceCategoryButtonAction(sender: UIButton) {
        if selectedServiceCategories.count == 0 {
            self.serviceCategoryTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allServiceCategories, cellType: .subTitle) { (cell, allServiceCategories, indexPath) in
            cell.textLabel?.text = allServiceCategories.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedServiceCategories) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.serviceCategoryTextField.text = selectedItem?.name
            self?.selectedServiceCategories = selectedList
            self?.selectedServiceCategoriesId = selectedItem?.id ?? 0
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allServiceCategories.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func hideServiceCostButtonAction(sender: UIButton) {
        hideButton.isSelected = !hideButton.isSelected
        if hideButton.isSelected {
            enableCollectLabelHeightConstant.constant = 0
            enableCollectBtnHeightConstant.constant = 0
            enableCollectLabelTopConstant.constant = 0
            depositCostLabelTopConstant.constant = 0
            depositCostLabelHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
            depositCostTFHeightConstant.constant = 0
            isPreBookingCostAllowed = false
        } else {
            enableButton.isSelected = false
            isPreBookingCostAllowed = true
            enableCollectLabelHeightConstant.constant = 36
            enableCollectBtnHeightConstant.constant = 15
            enableCollectLabelTopConstant.constant = 16
            depositCostLabelTopConstant.constant = 0
            depositCostLabelHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
            depositCostTFHeightConstant.constant = 0
        }
    }
    
    @IBAction func disableBookingButtonAction(sender: UIButton) {
        disableButton.isSelected = !disableButton.isSelected
        if disableButton.isSelected {
            showInPublicBooking = false
        } else {
            showInPublicBooking = true
        }
    }

    @IBAction func enableDepositsButtonAction(sender: UIButton) {
        enableButton.isSelected = !enableButton.isSelected
        if enableButton.isSelected {
            depositCostTextField.isHidden = false
            depositCostLabelTopConstant.constant = 16
            depositCostLabelHeightConstant.constant = 18
            depositCostTFTopConstant.constant = 10
            depositCostTFHeightConstant.constant = 45
        } else {
            depositCostTextField.isHidden = true
            depositCostLabelTopConstant.constant = 0
            depositCostLabelHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
            depositCostTFHeightConstant.constant = 0
        }
    }
    
    @IBAction func uploadServiceImageButtonAction(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        serviceImageView.image  = selectedImage
        serviceImageViewHeight.constant = 200
        serviceImageViewTop.constant = 20
        contentViewHeight.constant = 1550
        imageRemoved = false
        removeImageViewBtn.isHidden = false
        serviceImageViewBtn.setTitle("Change Service Image", for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeServiceImageButtonAction(sender: UIButton) {
        serviceImageView.image = nil
        serviceImageViewHeight.constant = 0
        serviceImageViewTop.constant = 0
        contentViewHeight.constant = 1300
        removeImageViewBtn.isHidden = true
        imageRemoved = true
        serviceImageViewBtn.setTitle("Choose Service Image", for: .normal)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveServiceButtonAction(sender: UIButton) {
        guard let serviceName = serviceNameTextField.text, !serviceName.isEmpty else {
            serviceNameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let selectClinic = selectClinicTextField.text, !selectClinic.isEmpty else {
            selectClinicTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let serviceDuration = serviceDurationTextField.text, !serviceDuration.isEmpty else {
            serviceDurationTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let serviceCategory = serviceCategoryTextField.text, !serviceCategory.isEmpty else {
            serviceCategoryTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let serviceCost = serviceCostTextField.text, !serviceCost.isEmpty else {
            serviceCostTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let serviceUrl = serviceUrlTextField.text, serviceUrl.validateUrl() else {
            serviceUrlTextField.showError(message: "Service URL is invalid.")
            return
        }
        
        self.view.ShowSpinner()
        
        if self.title == Constant.Profile.createService {
            httpMethodType = .POST
        } else {
            httpMethodType = .PUT
        }
        servicesAddViewModel?.createServiceAPICall(name: serviceName,
                                                   serviceCategoryId: selectedServiceCategoriesId,
                                                   durationInMinutes: Int(serviceDuration) ?? 0,
                                                   serviceCost: Int(serviceCost) ?? 0,
                                                   description: serviceDescTextView.text ?? String.blank,
                                                   serviceURL: serviceUrl,
                                                   consentIds: selectedConsentIds,
                                                   questionnaireIds: selectedQuestionnairesIds,
                                                   clinicIds: selectedClincIds,
                                                   file: "",
                                                   files: "",
                                                   preBookingCost: Int(depositCostTextField.text ?? String.blank) ?? 0,
                                                   imageRemoved: imageRemoved,
                                                   isPreBookingCostAllowed: isPreBookingCostAllowed,
                                                   showInPublicBooking: showInPublicBooking,
                                                   priceVaries: false, httpMethod: httpMethodType, isScreenFrom: self.title ?? String.blank, serviceId: serviceId ?? 0)

    }
    
    @IBAction func cancelServiceButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
