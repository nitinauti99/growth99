//
//  AppointmentListDetailViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 10/02/23.
//

import UIKit

protocol AppointmentListDetailVCProtocol: AnyObject {
    func eventDataReceived()
    func datesDataReceived()
    func timesDataReceived()
    func appoinmentEdited()
    func errorEventReceived(error: String)
    func getPhoneNumberDataRecived()
    func getEmailAddressDataRecived()
    func appoinmentDeletedSucess()
    func editAppointmentsForPateintDataRecived()
    func clinicsReceivedEventEdit()
    func serviceListDataRecivedEventEdit()
    func providerListDataRecivedEventEdit()
}

class AppointmentListDetailViewController: UIViewController, AppointmentListDetailVCProtocol, UITextFieldDelegate {
    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var firstNameTextField: CustomTextField!
    @IBOutlet private weak var lastNameTextField: CustomTextField!
    @IBOutlet private weak var phoneNumberTextField: CustomTextField!

    @IBOutlet private weak var clincsTextField: CustomTextField!
    @IBOutlet private weak var servicesTextField: CustomTextField!
    @IBOutlet private weak var providersTextField: CustomTextField!
    @IBOutlet private weak var appoinmentStatusField: CustomTextField!
    @IBOutlet private weak var dateTextField: CustomTextField!
    @IBOutlet private weak var timeTextField: CustomTextField!
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var inPersonBtn: UIButton!
    @IBOutlet private weak var virtualBtn: UIButton!
    @IBOutlet private weak var dateSelectionButton: UIButton!

    var eventViewModel: AppointmentListDetailVMProtocol?
    
    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = Int()
    
    var allServices = [ServiceList]()
    var selectedServices = [ServiceList]()
    var createSelectedServicesarray = [ServiceList]()

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
    
    var editBookingHistoryData: AppointmentDTOList?
    var appointmentId: Int?

    var userSelectedDate: String = String.blank
    var selectedDate: String = String.blank
    var selectedTime: String = String.blank
    var appointmentTypeSelected: String = "InPerson"

    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.layer.borderColor = UIColor.gray.cgColor
        notesTextView.layer.borderWidth = 1.0
        eventViewModel = AppointmentListDetailViewModel(delegate: self)
        setUpNavigationBar()
        self.view.ShowSpinner()
        eventViewModel?.getEditAppointmentsForPateint(appointmentsId: appointmentId ?? 0)
        //emailTextField.EditTarget(self, action: #selector(EditEventViewController.textFieldDidChange(_:)), for: .editingChanged)
       // phoneNumberTextField.EditTarget(self, action: #selector(EditEventViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == emailTextField {
            eventViewModel?.checkUserEmailAddress(emailAddress: emailTextField.text ?? String.blank)
        } else if textField == phoneNumberTextField {
            eventViewModel?.checkUserPhoneNumber(phoneNumber: phoneNumberTextField.text ?? String.blank)
        }
    }
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.editAppointment
    }
    
    func editAppointmentsForPateintDataRecived() {
        editBookingHistoryData = eventViewModel?.getAppointmentsForPateintData
        setupBookingHistoryData()
    }

    func setupBookingHistoryData() {
        firstNameTextField.text = editBookingHistoryData?.patientFirstName ?? String.blank
        lastNameTextField.text = editBookingHistoryData?.patientLastName ?? String.blank
        emailTextField.text = editBookingHistoryData?.patientEmail ?? String.blank
        
        phoneNumberTextField.text = editBookingHistoryData?.patientPhone?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")

        clincsTextField.text = editBookingHistoryData?.clinicName ?? String.blank
        let serviceSelectedArray = editBookingHistoryData?.serviceList ?? []
        selectedServices = serviceSelectedArray
        selectedServicesIds = serviceSelectedArray.map({$0.serviceId ?? 0})
        servicesTextField.text = serviceSelectedArray.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        providersTextField.text = editBookingHistoryData?.providerName ?? String.blank
        appoinmentStatusField.text = editBookingHistoryData?.appointmentStatus ?? String.blank
        dateTextField.text = eventViewModel?.serverToLocal(date: editBookingHistoryData?.appointmentStartDate ?? String.blank)
        timeTextField.text = "\(eventViewModel?.utcToLocal(dateStr: editBookingHistoryData?.appointmentStartDate ?? String.blank) ?? String.blank)"
        if editBookingHistoryData?.appointmentType == "InPerson" {
            inPersonBtn.isSelected = true
            virtualBtn.isSelected = false
        } else {
            inPersonBtn.isSelected = false
            virtualBtn.isSelected = true
        }
        notesTextView.text = editBookingHistoryData?.notes ?? String.blank
    }
    
    func serverToLocalDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/MM/dd"
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
        self.view.showToast(message: error, color: .black)
    }
    
    func eventDataReceived() {
        
    }
    
    func appoinmentEdited() {
        self.view.HideSpinner()
        self.navigationController?.popViewController(animated: true)
    }

    func appoinmentDeletedSucess() {
        self.view.HideSpinner()
        self.view.showToast(message: "Appointment Cancelled Sucessfully", color: .red)
        self.navigationController?.popViewController(animated: true)
    }

    func errorEventReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @IBAction func selectClinicButtonAction(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
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
            cell.textLabel?.text = allServices.serviceName?.components(separatedBy: " ").first
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
            self?.selectedProvidersIds = selectedId
            self?.view.ShowSpinner()
            self?.eventViewModel?.getDatesList(clinicIds: self?.selectedClincIds ?? 0, providerId: self?.selectedProvidersIds.first ?? 0, serviceIds: self?.selectedServicesIds ?? [])
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allProviders.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func selectAppoinmentStatusButtonAction(sender: UIButton) {
        let statusArray = ["Pending", "Confirmed", "Completed", "Cancelled", "Updated"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: statusArray, cellType: .subTitle) { (cell, allStatus, indexPath) in
            cell.textLabel?.text = allStatus.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.appoinmentStatusField.text = selectedItem
         }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(statusArray.count * 30))), arrowDirection: .up), from: self)
    }
    @IBAction func selectDatesButtonAction(sender: UIButton) {
        if selectedDates.count == 0 {
            self.dateTextField.text = String.blank
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: allDatesList, cellType: .subTitle) { (cell, allDates, indexPath) in
            cell.textLabel?.text = self.eventViewModel?.serverToLocal(date: allDates.components(separatedBy: ", ").first ?? String.blank)
        }
        
        selectionMenu.setSelectedItems(items: selectedDates) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.dateTextField.text = self?.serverToLocalDateFormat(date: selectedList[0])
            self?.selectedDate = selectedList[0]
            self?.selectedDates = selectedList
            self?.view.ShowSpinner()
            self?.eventViewModel?.getTimeList(dateStr: self?.eventViewModel?.timeInputCalender(date: self?.selectedDates.first ?? String.blank) ?? String.blank, clinicIds: self?.selectedClincIds ?? 0, providerId: self?.selectedProvidersIds.first ?? 0, serviceIds: self?.selectedServicesIds ?? [], appointmentId: 0)
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
            cell.textLabel?.text = self.eventViewModel?.utcToLocal(dateStr: allTimes.components(separatedBy: ", ").first ?? String.blank)
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
        
//        guard let phoneNumber = phoneNumberTextField.text, phoneNumber.isValidMobile() else {
//            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
//            return
//        }
        
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
        if selectedClincIds == 0 {
            selectedClincIds = editBookingHistoryData?.clinicId ?? 0
        }
        
        self.view.ShowSpinner()
        eventViewModel?.editAppoinemnetMethod(editAppoinmentId: editBookingHistoryData?.id ?? 0, editAppoinmentModel: EditAppoinmentModel(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber, notes: notesTextView.text, clinicId: selectedClincIds, serviceIds: selectedServicesIds, providerId: selectedProvidersIds.first, date: eventViewModel?.serverToLocalInputWorking(date: selectedDate), time: eventViewModel?.timeInputCalender(date: selectedTime), appointmentType: appointmentTypeSelected, source: "Calender", appointmentDate: eventViewModel?.appointmentDateInput(date: selectedDate), appointmentConfirmationStatus: appoinmentStatusField.text))
    }
    
    @IBAction func canecelButtonAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func canecelAppointmentAction(sender: UIButton) {
        self.view.ShowSpinner()
        eventViewModel?.deleteSelectedAppointment(deleteAppoinmentId: self.editBookingHistoryData?.id ?? 0)
    }
    
    @IBAction func gotoPatientAction(sender: UIButton) {
        let peteintDetail = PeteintDetailView.viewController()
        peteintDetail.workflowTaskPatientId = editBookingHistoryData?.id ?? 0
        self.navigationController?.pushViewController(peteintDetail, animated: true)
    }

    @IBAction func inPersonButtonAction(sender: UIButton) {
        inPersonBtn.isSelected = !inPersonBtn.isSelected
        appointmentTypeSelected = "InPerson"
        virtualBtn.isSelected = false
    }
    
    @IBAction func virtualButtonAction(sender: UIButton) {
        virtualBtn.isSelected = !virtualBtn.isSelected
        inPersonBtn.isSelected = false
        appointmentTypeSelected = "Virtual"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextField {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = newString.format(with: "(XXX) XXX-XXXX", phone: newString)
            return false
        }
        return true
    }

}
