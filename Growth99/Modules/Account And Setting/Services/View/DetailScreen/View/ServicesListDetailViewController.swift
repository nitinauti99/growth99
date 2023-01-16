//
//  ServicesListDetailViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 13/01/23.
//

import UIKit
import DropDown

protocol ServicesListDetailViewContollerProtocol {
    func errorReceived(error: String)
    func clinicsReceived()
    func consentReceived()
    func questionnairesReceived()
    func serviceCategoriesReceived()
}

class ServicesListDetailViewController: UIViewController, ServicesListDetailViewContollerProtocol {
    
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
    
    let dropDown = DropDown()
    
    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = [Int]()
    
    var allServiceCategories = [Clinics]()
    var selectedServiceCategories = [Clinics]()
    var selectedServiceCategoriesIds = [Int]()
    
    var allConsent = [ConsentListModel]()
    var selectedConsent = [ConsentListModel]()
    var selectedConsentIds = [Int]()
    
    var allQuestionnaires = [QuestionnaireListModel]()
    var selectedQuestionnaires = [QuestionnaireListModel]()
    var selectedQuestionnairesIds = [Int]()

    var servicesAddViewModel: ServiceListDetailViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupUI()
        servicesAddViewModel = ServiceListDetailModel(delegate: self)
        getClinicInfo()
    }
    
    func getClinicInfo() {
        self.view.ShowSpinner()
        servicesAddViewModel?.getallClinics()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.createService
    }
    
    func setupUI() {
        serviceDescTextView.layer.borderColor = UIColor.gray.cgColor
        serviceDescTextView.layer.borderWidth = 1.0
    }
    
    func clinicsReceived() {
        selectedClincs = servicesAddViewModel?.getAllClinicsData ?? []
        allClinics = servicesAddViewModel?.getAllClinicsData ?? []
        self.selectClinicTextField.text = selectedClincs.map({$0.name ?? ""}).joined(separator: ", ")
        let selectedClincId = selectedClincs.map({$0.id ?? 0})
        self.selectedClincIds = selectedClincId
        self.servicesAddViewModel?.getallServiceCategories(selectedClinics: selectedClincIds)
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

    func errorReceived(error: String) {
        self.view.HideSpinner()
    }
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.selectClinicTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.selectClinicTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
            self?.selectedClincs  = selectedList
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allClinics.count * 44))), arrowDirection: .up), from: self)
    }

    @IBAction func serviceDurationButtonAction(sender: UIButton) {
        let leadStatusArray = ["10", "15", "20", "30", "45", "60", "90", "120", "150", "180"]
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
            self?.serviceConsentTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
            self?.selectedConsent = selectedList
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
            self?.serviceQuestionarieTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
            self?.selectedQuestionnaires = selectedList
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
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allServiceCategories, cellType: .subTitle) { (cell, allServiceCategories, indexPath) in
            cell.textLabel?.text = allServiceCategories.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedServiceCategories) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.serviceCategoryTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
            self?.selectedServiceCategories  = selectedList
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allServiceCategories.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func enableDepositsButtonAction(sender: UIButton) {
       
    }
    
    @IBAction func disableBookingButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func uploadServiceImageButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func saveServiceButtonAction(sender: UIButton) {
        
    }
    
    @IBAction func cancelServiceButtonAction(sender: UIButton) {
        
    }
}
