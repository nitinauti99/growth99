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
    func appoinmentCreated(apiResponse: AppoinmentModel)
    func errorEventReceived(error: String)
    func getPhoneNumberDataRecived()
    func getEmailAddressDataRecived()
    func patientAppointmentListDataRecived()
}

class AddEventViewController: UIViewController, CalendarViewContollerProtocol, AddEventViewControllerProtocol {
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var clincsTextField: CustomTextField!
    @IBOutlet weak var servicesTextField: CustomTextField!
    @IBOutlet weak var providersTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var timeTextField: CustomTextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var inPersonBtn: UIButton!
    @IBOutlet weak var virtualBtn: UIButton!
    @IBOutlet weak var dateSelectionButton: UIButton!
    @IBOutlet weak var addeventScrollView: UIScrollView!
    
    var addEventViewModel: CalendarViewModelProtocol?
    var eventViewModel: AddEventViewModelProtocol?
    var dateFormater: DateFormaterProtocol?
    
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
    
    var userSelectedDate: String = String.blank
    var selectedDate: String = String.blank
    var selectedTime: String = String.blank
    var appointmentTypeSelected: String = "InPerson"
    var screenTitile = String()
    var pateintsEmail = String()
    let radioController: RadioButtonController = RadioButtonController()
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let formatter = DateFormatter()
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        notesTextView.layer.borderColor = UIColor.gray.cgColor
        notesTextView.layer.borderWidth = 1.0
        setUpNavigationBar()
        self.dateFormater = DateFormater()
        addEventViewModel = CalendarViewModel(delegate: self)
        eventViewModel = AddEventViewModel(delegate: self)
        //emailTextField.addTarget(self, action: #selector(AddEventViewController.textFieldDidChange(_:)), for: .editingChanged)
        // phoneNumberTextField.addTarget(self, action: #selector(AddEventViewController.textFieldDidChange(_:)), for: .editingChanged)
        dateTextField.tintColor = .clear
        dateTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        radioController.buttonsArray = [inPersonBtn, virtualBtn]
        radioController.defaultButton = inPersonBtn
    }
    
    @objc func dateFromButtonPressed() {
        dateTextField.text = dateFormatterString(textField: dateTextField)
        self.view.ShowSpinner()
        self.eventViewModel?.getTimeList(dateStr: self.eventViewModel?.timeInputCalendarButton(date: dateTextField.text ?? "") ?? String.blank, clinicIds: self.selectedClincIds, providerId: self.selectedProvidersIds.first ?? 0, serviceIds: self.selectedServicesIds, appointmentId: 0)
    }
    
    func dateFormatterString(textField: CustomTextField) -> String {
        datePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePicker.minimumDate = todaysDate
        textField.resignFirstResponder()
        datePicker.reloadInputViews()
        return dateFormatter.string(from: datePicker.date)
    }
    
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.appointment
    }
    
    func serverToLocalDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getClinicsData()
    }
    
    func getClinicsData() {
        self.view.ShowSpinner()
        addEventViewModel?.getallClinics()
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
        if self.screenTitile == "Patients Appointment" {
            self.view.ShowSpinner()
            self.eventViewModel?.getPateintsAppointData()
        }
    }
    
    func patientAppointmentListDataRecived(){
        self.view.HideSpinner()
        self.setUPUI()
    }
    
    func setUPUI(){
        let item = eventViewModel?.getPatientsAppointmentList.filter({ $0.email == pateintsEmail})[0]
        self.emailTextField.text = item?.email
        self.firstNameTextField.text = item?.firstName
        self.lastNameTextField.text = item?.lastName
        self.phoneNumberTextField.text = item?.phone
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
    
    func getPhoneNumberDataRecived() {
        
    }
    
    func getEmailAddressDataRecived() {
        
    }
    
    func appointmentListDataRecived() {
        
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func eventDataReceived() {
        
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func appoinmentCreated(apiResponse: AppoinmentModel) {
        self.view.HideSpinner()
        if apiResponse.statusCode == 200 {
            self.view.showToast(message: "Appointment created successfully", color: UIColor().successMessageColor())
            let userInfo = ["clinicId": selectedClincIds, "providerId": selectedProvidersIds, "serviceId": selectedServicesIds] as [String : Any]
            NotificationCenter.default.post(name: Notification.Name("EventCreated"), object: nil, userInfo: userInfo)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.popViewController(animated: true)
            }
        } else if apiResponse.statusCode == 500 {
            self.view.showToast(message: "Provided email address is currently registered with another business. To resolve contact product@growth99.com", color: .red)
            scrollToTop(of: addeventScrollView, animated: true)
            emailTextField.showError(message: "Please eneter another email address")
        } else {
            self.view.showToast(message: "Internal server error", color: .red)
        }
    }
    
    func scrollToTop(of scrollView: UIScrollView, animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -100)
        scrollView.setContentOffset(topOffset, animated: animated)
    }
    
    func errorEventReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.clincsTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
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
            cell.textLabel?.text = allServices.name
        }
        
        selectionMenu.setSelectedItems(items: selectedServices) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.servicesTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
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
            cell.textLabel?.text = "\(allProviders.firstName ?? String.blank) \(allProviders.lastName ?? String.blank)"
        }
        
        selectionMenu.setSelectedItems(items: selectedProviders) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.providersTextField.text = "\(selectedItem?.firstName ?? String.blank) \(selectedItem?.lastName ?? String.blank)"
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedProviders  = selectedList
            self?.selectedProvidersIds = selectedId
            self?.view.ShowSpinner()
            if self?.userSelectedDate == "Manual" {
                self?.eventViewModel?.getDatesList(clinicIds: self?.selectedClincIds ?? 0, providerId: self?.selectedProvidersIds.first ?? 0, serviceIds: self?.selectedServicesIds ?? [])
            } else {
                self?.eventViewModel?.getTimeList(dateStr: self?.eventViewModel?.localInputToServerInput(date: self?.dateTextField.text ?? String.blank) ?? String.blank, clinicIds: self?.selectedClincIds ?? 0, providerId: self?.selectedProvidersIds.first ?? 0, serviceIds: self?.selectedServicesIds ?? [], appointmentId: 0)
            }
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
            cell.textLabel?.text = self.eventViewModel?.serverToLocal(date: allDates)
        }
        
        selectionMenu.setSelectedItems(items: selectedDates) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.dateTextField.text = self?.eventViewModel?.serverToLocal(date: selectedList[0])
            self?.selectedDate = selectedList[0]
            self?.selectedDates = selectedList
            self?.view.ShowSpinner()
            self?.eventViewModel?.getTimeList(dateStr: self?.eventViewModel?.timeInputCalendar(date: self?.selectedDates.first ?? String.blank) ?? String.blank, clinicIds: self?.selectedClincIds ?? 0, providerId: self?.selectedProvidersIds.first ?? 0, serviceIds: self?.selectedServicesIds ?? [], appointmentId: 0)
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
            cell.textLabel?.text = self.eventViewModel?.utcToLocal(dateStr: allTimes)
        }
        
        selectionMenu.setSelectedItems(items: selectedTimes) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.timeTextField.text = self?.eventViewModel?.utcToLocal(dateStr: selectedList[0])
            self?.selectedTime = selectedList[0]
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
            firstNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
            return
        }
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: "Phone Number is required")
            return
        }
        
        let characterCount = phoneNumber.count
        if characterCount < 10 {
            phoneNumberTextField.showError(message: "Phone Number should contain 10 digits")
        }
        
        guard let clinic = clincsTextField.text, !clinic.isEmpty else {
            clincsTextField.showError(message: Constant.Profile.clinicsRequired)
            return
        }
        guard let services = servicesTextField.text, !services.isEmpty else {
            servicesTextField.showError(message: "Services are required")
            return
        }
        guard let provider = providersTextField.text, !provider.isEmpty else {
            providersTextField.showError(message: "Providers are required")
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
        
        let str: String = (date) + " " + (time)
        let scheduledDate = (dateFormater?.localToServerCalender(date: str)) ?? ""
        
        self.view.ShowSpinner()
        if self.userSelectedDate == "Manual" {
            eventViewModel?.createAppoinemnetMethod(addEventModel: NewAppoinmentModel(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, notes: notesTextView.text, clinicId: selectedClincIds, serviceIds: selectedServicesIds, providerId: selectedProvidersIds.first, date: eventViewModel?.serverToLocalInputWorking(date: date), time: eventViewModel?.timeInputCalendar(date: selectedTime), appointmentType: appointmentTypeSelected, source: "Calendar", appointmentDate: scheduledDate))
        } else {
            eventViewModel?.createAppoinemnetMethod(addEventModel: NewAppoinmentModel(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, notes: notesTextView.text, clinicId: selectedClincIds, serviceIds: selectedServicesIds, providerId: selectedProvidersIds.first, date: eventViewModel?.localInputeDateToServer(date: dateTextField.text ?? String.blank), time: eventViewModel?.timeInputCalendar(date: selectedTime), appointmentType: appointmentTypeSelected, source: "Calendar", appointmentDate: scheduledDate))
        }
    }
    
    @IBAction func inPersonButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        appointmentTypeSelected = "InPerson"
        virtualBtn.isSelected = false
    }
    
    @IBAction func virtualButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        inPersonBtn.isSelected = false
        appointmentTypeSelected = "Virtual"
    }
}
