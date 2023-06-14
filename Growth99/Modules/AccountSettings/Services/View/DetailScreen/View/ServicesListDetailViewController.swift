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
    func createServiceSuccessfullyReceived(message: String)
    func selectedServiceDataReceived()
    func serviceImageUploadReceived(responseMessage: String)
    func serviceAddListDataRecived()
}

class ServicesListDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ServicesListDetailViewContollerProtocol {
    
    @IBOutlet weak var serviceNameTextField: CustomTextField!
    @IBOutlet weak var selectClinicTextField: CustomTextField!
    @IBOutlet weak var serviceDurationTextField: CustomTextField!
    @IBOutlet weak var serviceCategoryTextField: CustomTextField!
    @IBOutlet weak var serviceCostTextField: CustomTextField!
    @IBOutlet weak var serviceUrlTextField: CustomTextField!
    @IBOutlet weak var depositCostTextField: CustomTextField!
    @IBOutlet weak var serviceDescTextView: UITextView!
    @IBOutlet weak var serviceConsentTextField: CustomTextField!
    @IBOutlet weak var serviceQuestionarieTextField: CustomTextField!
    @IBOutlet weak var serviceImageViewBtn: UIButton!
    @IBOutlet weak var removeImageViewBtn: UIButton!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceImageViewTop: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hideButton: UIButton!
    @IBOutlet weak var disableButton: UIButton!
    @IBOutlet weak var enableButton: UIButton!
    @IBOutlet weak var enableCollectBtnHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var enableCollectLabelHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var enableCollectLabelTopConstant: NSLayoutConstraint!

    @IBOutlet weak var depositCostLabelHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var depositCostLabelTopConstant: NSLayoutConstraint!

    @IBOutlet weak var depositCostTFTopConstant: NSLayoutConstraint!
    @IBOutlet weak var depositCostTFHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var submitButton: UIButton!

    var screenTitle: String = String.blank
    var serviceId: Int?
    
    var selectedPickerImage: UIImage?

    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = [Int]()
        
    var allServiceCategories = [Clinics]()
    var selectedServiceCategories = [Clinics]()
    var selectedServiceCategoriesId = Int()
    
    var allConsent = [ConsentListModel]()
    var selectedConsent = [ConsentListModel]()
    var selectedConsentIds = [Int]()
    
    var allQuestionnaires = [QuestionnaireListModel]()
    var selectedQuestionnaires = [QuestionnaireListModel]()
    var selectedQuestionnairesIds = [Int]()
    
    var userClinics = [ClinicsServices]()
    var userConsents = [ServiceConsents]()
    var userQuestionnaires = [ServiceQuestionnaires]()

    var servicecategory: ServiceCategory?
    var serviceClinic: Clinic?
    var servicesAddViewModel: ServiceListDetailViewModelProtocol?
    
    var imageRemoved: Bool = true
    var isPreBookingCostAllowed: Bool = false
    var showInPublicBooking: Bool = false
    var priceVaries: Bool = false
    var httpMethodType: HTTPMethod = .POST
    var hidePriceVaries: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = screenTitle
        servicesAddViewModel = ServiceListDetailModel(delegate: self)
        getAddServices()
        setupUI()
    }
    
    func getAddServices() {
        self.view.ShowSpinner()
        servicesAddViewModel?.getAddServiceList()
    }
    
    func serviceAddListDataRecived() {
        servicesAddViewModel?.getallClinics()
    }

    func setupUI() {
        serviceDescTextView.layer.borderColor = UIColor.gray.cgColor
        serviceDescTextView.layer.borderWidth = 1.0
        if self.title == Constant.Profile.createService {
            removeImageViewBtn.isHidden = true
            contentViewHeight.constant = 1400
            serviceImageViewHeight.constant = 0
            serviceImageViewTop.constant = 0
            enableButton.isSelected = false
            hideButton.isSelected = false
            disableButton.isSelected = false
            depositCostLabelTopConstant.constant = 0
            depositCostLabelHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
            depositCostTFHeightConstant.constant = 0
            depositCostTextField.isHidden = true
        } else {
            servicesAddViewModel?.getUserSelectedService(serviceID: serviceId ?? 0)
            removeImageViewBtn.isHidden = true
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
        for item in userClinics {
            selectedClincs.append(Clinics(isDefault: item.clinic?.isDefault, name: item.clinic?.name, id: item.clinic?.id))
            selectedClincIds.append(item.clinic?.id ?? 0)
        }
        
        serviceDurationTextField.text = "\(servicesAddViewModel?.getUserSelectedServiceData?.durationInMinutes ?? 0)"
        servicecategory = servicesAddViewModel?.getUserSelectedServiceData?.serviceCategory
        serviceCategoryTextField.text = servicecategory.map({$0.name ?? String.blank})
        selectedServiceCategories.append(Clinics(isDefault: servicecategory?.isDefault, name: servicecategory?.name, id: servicecategory?.id))
        selectedServiceCategoriesId = servicecategory.map({ $0.id ?? 0}) ?? 0
        
        serviceCostTextField.text = forTrailingZero(temp: servicesAddViewModel?.getUserSelectedServiceData?.serviceCost ?? 0.0)
        serviceUrlTextField.text = servicesAddViewModel?.getUserSelectedServiceData?.serviceURL ?? String.blank
        depositCostTextField.text = forTrailingZero(temp: servicesAddViewModel?.getUserSelectedServiceData?.preBookingCost ?? 0.0)
        serviceDescTextView.text = servicesAddViewModel?.getUserSelectedServiceData?.description
        
        userConsents = servicesAddViewModel?.getUserSelectedServiceData?.consents ?? []
        serviceConsentTextField.text = userConsents.map({$0.name ?? String.blank}).joined(separator: ", ")
        for item in userConsents {
            selectedConsent.append(ConsentListModel(createdAt: item.createdAt ?? "", updatedBy: "\(item.updatedBy?.firstName ?? "") \(item.updatedBy?.lastName ?? "")", createdBy: "\(item.createdBy?.firstName ?? "") \(item.createdBy?.lastName ?? "")", name: item.name ?? "", id: item.id ?? 0, updatedAt: item.updatedAt ?? ""))
            selectedConsentIds.append(item.id ?? 0)
        }
        
        userQuestionnaires = servicesAddViewModel?.getUserSelectedServiceData?.questionnaires ?? []
        serviceQuestionarieTextField.text = userQuestionnaires.map({$0.name ?? String.blank}).joined(separator: ", ")
        for item in userQuestionnaires {
            selectedQuestionnaires.append(QuestionnaireListModel(createdAt: item.createdAt ?? "", isContactForm: nil, name: item.name ?? "", id: item.id ?? 0, isG99ReviewForm: false))
            selectedQuestionnairesIds.append(item.id ?? 0)
        }
            
        if servicesAddViewModel?.getUserSelectedServiceData?.showInPublicBooking == true {
            disableButton.isSelected = true
        } else {
            disableButton.isSelected = false
        }
        
        if servicesAddViewModel?.getUserSelectedServiceData?.priceVaries == true {
            hideButton.isSelected = true
            enableButton.isSelected = false
            depositCostTextField.isHidden = true
            depositCostTextField.text = String.blank
            enableCollectLabelHeightConstant.constant = 0
            enableCollectBtnHeightConstant.constant = 0
            enableCollectLabelTopConstant.constant = 0
            
            depositCostLabelTopConstant.constant = 0
            depositCostLabelHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
            depositCostTFHeightConstant.constant = 0
        } else {
            hideButton.isSelected = false
            enableButton.isSelected = true
            depositCostTextField.isHidden = false
            enableCollectLabelHeightConstant.constant = 36
            enableCollectBtnHeightConstant.constant = 15
            enableCollectLabelTopConstant.constant = 16
            
            depositCostLabelTopConstant.constant = 16
            depositCostLabelHeightConstant.constant = 18
            depositCostTFTopConstant.constant = 10
            depositCostTFHeightConstant.constant = 45
        }
        
        if servicesAddViewModel?.getUserSelectedServiceData?.isPreBookingCostAllowed == true {
            enableButton.isSelected = true
            depositCostTextField.isHidden = false
            depositCostLabelTopConstant.constant = 16
            depositCostTFHeightConstant.constant = 45
            depositCostTFTopConstant.constant = 10
            depositCostLabelHeightConstant.constant = 18
        } else {
            enableButton.isSelected = false
            depositCostTextField.isHidden = true
            depositCostLabelTopConstant.constant = 0
            depositCostTFHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
            depositCostLabelHeightConstant.constant = 0
        }
        
        let imageUrl = servicesAddViewModel?.getUserSelectedServiceData?.imageUrl
        if imageUrl?.isEmpty ?? true {
            serviceImageView.image = nil
            serviceImageViewHeight.constant = 0
            serviceImageViewTop.constant = 0
            contentViewHeight.constant = 1400
            removeImageViewBtn.isHidden = true
        } else {
            self.serviceImageView.sd_setImage(with: URL(string: servicesAddViewModel?.getUserSelectedServiceData?.imageUrl ?? String.blank), placeholderImage: nil)
            serviceImageViewHeight.constant = 200
            serviceImageViewTop.constant = 20
            contentViewHeight.constant = 1550
            imageRemoved = false
            removeImageViewBtn.isHidden = true
            serviceImageViewBtn.setTitle("Change Service Image", for: .normal)
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
    
    func createServiceSuccessfullyReceived(message: String) {
//        self.servicesAddViewModel?.uploadSelectedServiceImage(image: selectedPickerImage ?? UIImage(), selectedServiceId: serviceId ?? 0)
        self.view.HideSpinner()
        if message == Constant.Profile.createService {
            self.view.showToast(message: "Service created successfully", color: UIColor().successMessageColor())
        } else {
            self.view.showToast(message: "Service updated successfully", color: UIColor().successMessageColor())
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func serviceImageUploadReceived(responseMessage: String) {
        self.view.HideSpinner()
        if responseMessage == Constant.Profile.createService {
            self.view.showToast(message: "Service created successfully", color: UIColor().successMessageColor())
        } else {
            self.view.showToast(message: "Service updated successfully", color: UIColor().successMessageColor())
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.selectClinicTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.selectClinicTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedClincs  = selectedList
            self?.selectedClincIds = selectedId
            if selectedId.count > 0 {
                self?.view.ShowSpinner()
                self?.servicesAddViewModel?.getallServiceCategories(selectedClinics: selectedId)
            }
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
            cell.textLabel?.text = allConsent.name
        }
        
        selectionMenu.setSelectedItems(items: selectedConsent) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.serviceConsentTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedConsent = selectedList
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
            cell.textLabel?.text = allQuestionnaires.name
        }
        
        selectionMenu.setSelectedItems(items: selectedQuestionnaires) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.serviceQuestionarieTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedQuestionnaires = selectedList
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
            cell.textLabel?.text = allServiceCategories.name
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
            hidePriceVaries = true
            enableCollectLabelHeightConstant.constant = 0
            enableCollectBtnHeightConstant.constant = 0
            enableCollectLabelTopConstant.constant = 0
            depositCostLabelTopConstant.constant = 0
            depositCostLabelHeightConstant.constant = 0
            depositCostTFTopConstant.constant = 0
            depositCostTFHeightConstant.constant = 0
            depositCostTextField.isHidden = true
        } else {
            hidePriceVaries = false
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
            showInPublicBooking = true
        } else {
            showInPublicBooking = false
        }
    }

    @IBAction func enableDepositsButtonAction(sender: UIButton) {
        enableButton.isSelected = !enableButton.isSelected
        if enableButton.isSelected {
            isPreBookingCostAllowed = true
            depositCostTextField.isHidden = false
            depositCostLabelTopConstant.constant = 16
            depositCostLabelHeightConstant.constant = 18
            depositCostTFTopConstant.constant = 10
            depositCostTFHeightConstant.constant = 45
        } else {
            isPreBookingCostAllowed = false
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
        selectedPickerImage = selectedImage
        serviceImageViewHeight.constant = 200
        serviceImageViewTop.constant = 20
        contentViewHeight.constant = 1550
        imageRemoved = false
        removeImageViewBtn.isHidden = true
        serviceImageViewBtn.setTitle("Change Service Image", for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeServiceImageButtonAction(sender: UIButton) {
        serviceImageView.image = nil
        serviceImageViewHeight.constant = 0
        serviceImageViewTop.constant = 0
        contentViewHeight.constant = 1400
        removeImageViewBtn.isHidden = true
        imageRemoved = true
        serviceImageViewBtn.setTitle("Choose Service Image", for: .normal)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveServiceButtonAction(sender: UIButton) {
        guard let serviceName = serviceNameTextField.text, !serviceName.isEmpty else {
            serviceNameTextField.showError(message: "Service Name is required.")
            return
        }
        
        guard let selectClinic = selectClinicTextField.text, !selectClinic.isEmpty else {
            selectClinicTextField.showError(message: "Clinic Name are required.")
            return
        }
        
        guard let serviceDuration = serviceDurationTextField.text, !serviceDuration.isEmpty else {
            serviceDurationTextField.showError(message: "Service duration is required.")
            return
        }
        
        guard let serviceCategory = serviceCategoryTextField.text, !serviceCategory.isEmpty else {
            serviceCategoryTextField.showError(message: "Service Category is required.")
            return
        }
        
        guard let serviceCost = serviceCostTextField.text, !serviceCost.isEmpty else {
            serviceCostTextField.showError(message: "Service Cost is required.")
            return
        }
        
        if let serviceCost = Double(serviceCostTextField.text ?? ""), let depositCost = Double(depositCostTextField.text ?? ""),
           depositCost > serviceCost {
            depositCostTextField.showError(message: "Deposit cost cannot be greater than the service cost")
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
                                                   serviceURL: serviceUrlTextField.text ?? String.blank,
                                                   consentIds: selectedConsentIds,
                                                   questionnaireIds: selectedQuestionnairesIds,
                                                   clinicIds: selectedClincIds,
                                                   file: "",
                                                   files: "",
                                                   preBookingCost: Int(depositCostTextField.text ?? String.blank) ?? 0,
                                                   imageRemoved: imageRemoved,
                                                   isPreBookingCostAllowed: isPreBookingCostAllowed,
                                                   showInPublicBooking: showInPublicBooking,
                                                   priceVaries: hidePriceVaries, httpMethod: httpMethodType, isScreenFrom: self.title ?? String.blank, serviceId: serviceId ?? 0)

    }
    
    @IBAction func cancelServiceButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
