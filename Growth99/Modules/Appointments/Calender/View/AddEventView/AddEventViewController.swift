//
//  AddEventViewController.swift
//  Growth99
//
//  Created by admin on 27/12/22.
//

import UIKit

protocol AddEventViewControllerProtocol: AnyObject {
    func eventDataReceived()
    func datesDataReceived()
    func timesDataReceived()
    func errorEventReceived(error: String)
}

class AddEventViewController: UIViewController, CalenderViewContollerProtocol, AddEventViewControllerProtocol {

    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var firstNameTextField: CustomTextField!
    @IBOutlet private weak var lastNameTextField: CustomTextField!
    @IBOutlet private weak var phoneNumberTextField: CustomTextField!

    @IBOutlet private weak var clincsTextField: CustomTextField!
    @IBOutlet private weak var servicesTextField: CustomTextField!
    @IBOutlet private weak var providersTextField: CustomTextField!
    @IBOutlet private weak var dateTextField: CustomTextField!
    @IBOutlet private weak var timeTextField: CustomTextField!
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var inPersonBtn: UIButton!
    @IBOutlet private weak var virtualBtn: UIButton!

    var addEventViewModel: CalenderViewModelProtocol?
    var eventViewModel: AddEventViewModelProtocol?

    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = Int()
    
    var allServices = [ServiceList]()
    var selectedServices = [ServiceList]()
    var selectedServicesIds = [Int]()
    
    var allProviders = [UserDTOList]()
    var selectedProviders = [UserDTOList]()
    var selectedProvidersIds = [Int]()
    
    var allDatesList = [String]()
    var selectedDates = [String]()
    var selectedDatesIds = [Int]()
    
    var allTimesList = [String]()
    var selectedTimes = [String]()
    var selectedTimesIds = [Int]()

    var inPersonSelected: String = "inPerson"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.layer.borderColor = UIColor.gray.cgColor
        notesTextView.layer.borderWidth = 1.0
        setUpNavigationBar()
        addEventViewModel = CalenderViewModel(delegate: self)
        eventViewModel = AddEventViewModel(delegate: self)
    }
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.appointment
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(closeEventClicked), imageName: "iconCircleCross")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getClinicsData()
    }
    
    func getClinicsData() {
        self.view.ShowSpinner()
        addEventViewModel?.getallClinics()
    }

    @objc func closeEventClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func clinicsReceived() {
        selectedClincs = addEventViewModel?.getAllClinicsData ?? []
        allClinics = addEventViewModel?.getAllClinicsData ?? []
        self.addEventViewModel?.getServiceList()
    }
    
    func serviceListDataRecived() {
        selectedServices = []
        allServices = addEventViewModel?.serviceData ?? []
        self.view.HideSpinner()
    }
    
    func providerListDataRecived() {
        selectedProviders = addEventViewModel?.providerData ?? []
        allProviders = addEventViewModel?.providerData ?? []
        self.view.HideSpinner()
    }
    
    func datesDataReceived() {
        allDatesList = eventViewModel?.getAllDatesData ?? []
        self.view.HideSpinner()
    }
    
    func timesDataReceived() {
        allTimesList = eventViewModel?.getAllTimessData ?? []
        self.view.HideSpinner()
    }
    
    func appointmentListDataRecived() {
        
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
    }
    
    func eventDataReceived() {
        
    }

    func errorEventReceived(error: String) {
        
    }
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.clincsTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedClincs  = selectedList
            self?.selectedClincIds = selectedId.first ?? 0
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allClinics.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectServicesButtonAction(sender: UIButton) {
        if selectedServices.count == 0 {
            self.servicesTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allServices, cellType: .subTitle) { (cell, allServices, indexPath) in
            cell.textLabel?.text = allServices.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedServices) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.servicesTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedServices  = selectedList
            self?.selectedServicesIds = selectedId
            self?.view.ShowSpinner()
            self?.addEventViewModel?.sendProviderList(providerParams: self?.selectedServicesIds.first ?? 0)
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allServices.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectProvidersButtonAction(sender: UIButton) {
        if selectedProviders.count == 0 {
            self.providersTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allProviders, cellType: .subTitle) { (cell, allProviders, indexPath) in
            cell.textLabel?.text = allProviders.firstName?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedProviders) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.providersTextField.text = selectedList.map({$0.firstName ?? ""}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedProviders  = selectedList
            self?.selectedProvidersIds = selectedId
            self?.view.ShowSpinner()
            self?.eventViewModel?.getDatesList(clinicIds: self?.selectedClincIds ?? 0, providerId: self?.selectedProvidersIds.first ?? 0, serviceIds: self?.selectedServicesIds ?? [])
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allProviders.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectDatesButtonAction(sender: UIButton) {
        if selectedDates.count == 0 {
            self.dateTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allDatesList, cellType: .subTitle) { (cell, allDates, indexPath) in
            cell.textLabel?.text = self.eventViewModel?.serverToLocal(date: allDates.components(separatedBy: ", ").first ?? "")
        }
        
        selectionMenu.setSelectedItems(items: selectedDates) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.dateTextField.text = self?.eventViewModel?.serverToLocal(date: selectedList[0])
            self?.selectedDates = selectedList
            self?.view.ShowSpinner()
            self?.eventViewModel?.getTimeList(dateStr: self?.eventViewModel?.timeInputCalender(date: self?.selectedDates.first ?? "") ?? "", clinicIds: self?.selectedClincIds ?? 0, providerId: self?.selectedProvidersIds.first ?? 0, serviceIds: self?.selectedServicesIds ?? [], appointmentId: 0)
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allDatesList.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectTimesButtonAction(sender: UIButton) {
        if selectedTimes.count == 0 {
            self.timeTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allTimesList, cellType: .subTitle) { (cell, allTimes, indexPath) in
            cell.textLabel?.text = self.eventViewModel?.utcToLocal(dateStr: allTimes.components(separatedBy: ", ").first ?? "")
        }
        
        selectionMenu.setSelectedItems(items: selectedTimes) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.timeTextField.text = self?.eventViewModel?.utcToLocal(dateStr: selectedList[0])
            self?.selectedTimes = selectedList
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allTimesList.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func saveButtonAction(sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
            return
        }
        
        guard let emailValidate = eventViewModel?.isValidEmail(email), emailValidate else {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            return
        }
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            firstNameTextField.showError(message: Constant.Profile.chooseToDate)
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            lastNameTextField.showError(message: Constant.Profile.chooseToDate)
            return
        }
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            return
        }
        
        if let textField = phoneNumberTextField.text, let phoneNumberValidate = eventViewModel?.isValidPhoneNumber(textField), phoneNumberValidate == false {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
        }
        
        guard let clinic = clincsTextField.text, !clinic.isEmpty else {
            phoneNumberTextField.showError(message: Constant.Profile.chooseToDate)
            return
        }
        guard let services = phoneNumberTextField.text, !services.isEmpty else {
            servicesTextField.showError(message: Constant.Profile.chooseToDate)
            return
        }
        guard let provider = phoneNumberTextField.text, !provider.isEmpty else {
            providersTextField.showError(message: Constant.Profile.chooseToDate)
            return
        }
        
        guard let date = dateTextField.text, !date.isEmpty else {
            dateTextField.showError(message: Constant.Profile.chooseToDate)
            return
        }
        
        guard let time = timeTextField.text, !time.isEmpty else {
            timeTextField.showError(message: Constant.Profile.chooseToTime)
            return
        }
        self.view.ShowSpinner()        
    }
    
    @IBAction func canecelButtonAction(sender: UIButton) {
        self.navigationController?.dismiss(animated: true)
    }
    
    @IBAction func inPersonButtonAction(sender: UIButton) {
        inPersonBtn.isSelected = !inPersonBtn.isSelected
        virtualBtn.isSelected = false
    }
    
    @IBAction func virtualButtonAction(sender: UIButton) {
        virtualBtn.isSelected = !virtualBtn.isSelected
        inPersonBtn.isSelected = false
    }
}
