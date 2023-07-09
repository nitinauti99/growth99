//
//  CalendarBaseViewController.swift
//  Growth99
//
//  Created by admin on 01/01/23.
//

import UIKit

protocol CalenderEditEventViewControllerProtocol: AnyObject {
    func eventDataReceived()
    func datesDataReceived()
    func timesDataReceived()
    func appoinmentEdited()
    func errorEventReceived(error: String)
    func getPhoneNumberDataRecived()
    func getEmailAddressDataRecived()
    func appoinmentDeletedSucess()
    func EditAppointmentsForPateintDataRecived()
    func clinicsReceivedEventEdit()
    func serviceListDataRecivedEventEdit()
    func providerListDataRecivedEventEdit()
}

class CalenderEventEditViewController: UIViewController, CalenderEditEventViewControllerProtocol {
    
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
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollViewBooking: UIScrollView!
    
    var eventViewModel: CalenderEditEventViewModelProtocol?
    
    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = Int()
    
    var allServices = [ServiceList]()
    var selectedServices = [ServiceList]()
    var createSelectedServicesarray = [ServiceList]()
    
    var selectedServicesIds = [Int]()
    
    var allProviders = [UserDTOList]()
    var selectedProviders = [UserDTOList]()
    var selectedProvidersIds = Int()
    
    var allDatesList = [String]()
    var selectedDates = [String]()
    var selectedDatesIds = [Int]()
    
    var allTimesList = [String]()
    var selectedTimes = [String]()
    var selectedTimesIds = [Int]()
    
    var editBookingHistoryData: AppointmentDTOList?
    var appointmentId: Int?
    var screenTitle: String = ""
    var userSelectedDate: String = String.blank
    var selectedDate: String = String.blank
    var selectedTime: String = String.blank
    var appointmentTypeSelected: String = "InPerson"
    var sourceTypeSelected: String = "Calender"
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let formatter = DateFormatter()
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    let radioController: RadioButtonController = RadioButtonController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.layer.borderColor = UIColor.gray.cgColor
        notesTextView.layer.borderWidth = 1.0
        eventViewModel = CalenderEditEventViewModel(delegate: self)
        setUpNavigationBar()
        self.view.ShowSpinner()
        eventViewModel?.getEditAppointmentsForPateint(appointmentsId: appointmentId ?? 0)
        //emailTextField.EditTarget(self, action: #selector(EditEventViewController.textFieldDidChange(_:)), for: .editingChanged)
        // phoneNumberTextField.EditTarget(self, action: #selector(EditEventViewController.textFieldDidChange(_:)), for: .editingChanged)
        dateTextField.tintColor = .clear
        dateTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        radioController.buttonsArray = [inPersonBtn, virtualBtn]
        radioController.defaultButton = inPersonBtn
        
    }
    
    @objc func dateFromButtonPressed() {
        dateTextField.text = dateFormatterString(textField: dateTextField)
        self.view.ShowSpinner()
        if self.selectedProvidersIds == 0 {
            self.selectedProvidersIds = self.editBookingHistoryData?.providerId ?? 0
        }
        if self.selectedClincIds == 0 {
            self.selectedClincIds = self.editBookingHistoryData?.clinicId ?? 0
        }
        if self.selectedServicesIds.first == 0 {
            let serviceSelectedArray = self.editBookingHistoryData?.serviceList ?? []
            self.selectedServicesIds = serviceSelectedArray.map({$0.serviceId ?? 0})
        }
        self.eventViewModel?.getTimeList(dateStr: self.eventViewModel?.timeInputCalendarButton(date: dateTextField.text ?? "") ?? String.blank, clinicIds: self.selectedClincIds, providerId: self.selectedProvidersIds, serviceIds: self.selectedServicesIds, appointmentId: self.appointmentId ?? 0)
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
        self.navigationItem.title = Constant.Profile.editAppointment
    }
    
    func EditAppointmentsForPateintDataRecived(){
        editBookingHistoryData = eventViewModel?.getAppointmentsForPateintData
        setupBookingHistoryData()
    }
    
    func setupBookingHistoryData() {
        firstNameTextField.text = editBookingHistoryData?.patientFirstName ?? String.blank
        lastNameTextField.text = editBookingHistoryData?.patientLastName ?? String.blank
        emailTextField.text = editBookingHistoryData?.patientEmail ?? String.blank
        phoneNumberTextField.text = editBookingHistoryData?.patientPhone ?? ""
        clincsTextField.text = editBookingHistoryData?.clinicName ?? String.blank
        let serviceSelectedArray = editBookingHistoryData?.serviceList ?? []
        selectedServices = serviceSelectedArray
        selectedServicesIds = serviceSelectedArray.map({$0.serviceId ?? 0})
        servicesTextField.text = serviceSelectedArray.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        providersTextField.text = editBookingHistoryData?.providerName ?? String.blank
        dateTextField.text = eventViewModel?.serverToLocal(date: editBookingHistoryData?.appointmentStartDate ?? String.blank)
        timeTextField.text = "\(eventViewModel?.utcToLocal(dateStr: editBookingHistoryData?.appointmentStartDate ?? String.blank) ?? String.blank)"
        if editBookingHistoryData?.appointmentType == "InPerson" {
            inPersonBtn.isSelected = true
            virtualBtn.isSelected = false
        } else {
            inPersonBtn.isSelected = false
            virtualBtn.isSelected = true
        }
        sourceTypeSelected = editBookingHistoryData?.source ?? String.blank
        appointmentTypeSelected = editBookingHistoryData?.appointmentType ?? String.blank
        notesTextView.text = editBookingHistoryData?.notes ?? String.blank
        self.eventViewModel?.sendProviderListEditEvent(providerParams: self.selectedServicesIds.first ?? 0)
        if editBookingHistoryData?.providerId ?? 0 != 0 {
            self.eventViewModel?.getDatesList(clinicIds: editBookingHistoryData?.clinicId ?? 0, providerId: editBookingHistoryData?.providerId ?? 0, serviceIds: self.selectedServicesIds )
            self.eventViewModel?.getTimeList(dateStr: self.eventViewModel?.timeInputCalendar(date: self.selectedDate) ?? String.blank, clinicIds: editBookingHistoryData?.clinicId ?? 0, providerId: editBookingHistoryData?.providerId ?? 0, serviceIds: self.selectedServicesIds, appointmentId: appointmentId ?? 0)
        }
    }
    
    func serverToLocalDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getClinicsData()
    }
    
    func getClinicsData() {
        self.view.ShowSpinner()
        eventViewModel?.getallClinicsEditEvent()
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func clinicsReceivedEventEdit() {
        selectedClincs = eventViewModel?.getAllClinicsDataEditEvent ?? []
        allClinics = eventViewModel?.getAllClinicsDataEditEvent ?? []
        self.eventViewModel?.getServiceListEditEvent()
    }
    
    func serviceListDataRecivedEventEdit() {
        allServices = eventViewModel?.serviceDataEditEvent ?? []
        self.view.HideSpinner()
    }
    
    func providerListDataRecivedEventEdit() {
        selectedProviders = eventViewModel?.providerDataEditEvent ?? []
        allProviders = eventViewModel?.providerDataEditEvent ?? []
        self.view.HideSpinner()
    }
    
    func datesDataReceived() {
        allDatesList = eventViewModel?.getAllDatesData ?? []
        self.view.HideSpinner()
    }
    
    func timesDataReceived() {
        allTimesList = eventViewModel?.getAllTimessData ?? []
        if allTimesList.count == 0 {
            timeTextField.text = ""
            timeTextField.showError(message: "Appointment Time is required.")
            self.view.showToast(message: "There are no time slots available for the selected date", color: .red)
            scrollToBottom(of: scrollViewBooking, animated: true)
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.init(hexString: "86BFE5")
        } else {
            submitButton.isSelected = true
            submitButton.isEnabled = true
            submitButton.backgroundColor = UIColor.init(hexString: "009EDE")
        }
        self.view.HideSpinner()
    }
    
    func getPhoneNumberDataRecived() {
        
    }
    
    func getEmailAddressDataRecived() {
        
    }
    
    func appointmentListDataRecived() {
        
    }
    
    func scrollToBottom(of scrollView: UIScrollView, animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: animated)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func eventDataReceived() {
        
    }
    
    func appoinmentEdited() {
        self.view.HideSpinner()
        self.view.showToast(message: "Appointment updated successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func appoinmentDeletedSucess() {
        self.view.HideSpinner()
        self.view.showToast(message: "Appointment cancelled successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
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
        createSelectedServicesarray.removeAll()
        if selectedServices.count == 0 {
            self.servicesTextField.text = String.blank
        }
        
        for item in allServices {
            for selctedItem in selectedServices {
                if selctedItem.serviceId == item.serviceId {
                    createSelectedServicesarray.append(item)
                }
            }
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allServices, cellType: .subTitle) { (cell, allServices, indexPath) in
            cell.textLabel?.text = allServices.serviceName
        }
        selectionMenu.setSelectedItems(items: createSelectedServicesarray) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.servicesTextField.text = selectedList.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedServices  = selectedList
            self?.selectedServicesIds = selectedId
            self?.view.ShowSpinner()
            self?.eventViewModel?.sendProviderListEditEvent(providerParams: self?.selectedServicesIds.first ?? 0)
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
            self?.selectedProvidersIds = selectedId.first ?? 0
            self?.view.ShowSpinner()
            self?.eventViewModel?.getDatesList(clinicIds: self?.selectedClincIds ?? 0, providerId: self?.selectedProvidersIds ?? 0, serviceIds: self?.selectedServicesIds ?? [])
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allProviders.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectDatesButtonAction(sender: UIButton) {
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allDatesList, cellType: .subTitle) { (cell, allDates, indexPath) in
            cell.textLabel?.text = self.eventViewModel?.serverToLocal(date: allDates)
        }
        
        selectionMenu.setSelectedItems(items: selectedDates) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.dateTextField.text = self?.serverToLocalDateFormat(date: selectedItem ?? "")
            self?.selectedDate = selectedItem ?? ""
            self?.selectedDates = selectedList
            
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allDatesList.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectTimesButtonAction(sender: UIButton) {
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
        guard let name = firstNameTextField.text, let nameValidate = eventViewModel?.validateName(name), nameValidate else {
            firstNameTextField.showError(message: "First Name is invalid.")
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
            return
        }
        guard let name = lastNameTextField.text, let nameValidate = eventViewModel?.validateName(name), nameValidate else {
            lastNameTextField.showError(message: "Last Name is invalid.")
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
        guard let services = phoneNumberTextField.text, !services.isEmpty else {
            servicesTextField.showError(message: "Services are required")
            return
        }
        guard let provider = phoneNumberTextField.text, !provider.isEmpty else {
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
        if selectedClincIds == 0 {
            selectedClincIds = editBookingHistoryData?.clinicId ?? 0
        }
        
        if selectedProvidersIds == 0 {
            self.selectedProvidersIds = self.editBookingHistoryData?.providerId ?? 0
        }
        
        if self.selectedServicesIds.first == 0 {
            let serviceSelectedArray = self.editBookingHistoryData?.serviceList ?? []
            self.selectedServicesIds = serviceSelectedArray.map({$0.serviceId ?? 0})
        }
        
        if selectedDate == String.blank {
            selectedDate = editBookingHistoryData?.appointmentStartDate ?? ""
        }
        
        if selectedTime == String.blank {
            selectedTime = editBookingHistoryData?.appointmentStartDate ?? ""
        }
        
        self.view.ShowSpinner()
        eventViewModel?.calenderEditAppoinemnetMethod(editAppoinmentId: editBookingHistoryData?.id ?? 0, editAppoinmentModel: CalenderEditAppoinmentModel(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, notes: notesTextView.text, clinicId: selectedClincIds, serviceIds: selectedServicesIds, providerId: selectedProvidersIds, date: eventViewModel?.serverToLocalInputWorking(date: selectedDate), time: eventViewModel?.timeInputCalendar(date: selectedTime), appointmentType: appointmentTypeSelected, source: sourceTypeSelected, appointmentDate: eventViewModel?.appointmentDateInput(date: selectedDate)))
    }
    
    @IBAction func canecelButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func canecelAppointmentAction(sender: UIButton) {
        self.view.ShowSpinner()
        eventViewModel?.deleteSelectedAppointment(deleteAppoinmentId: self.editBookingHistoryData?.id ?? 0)
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