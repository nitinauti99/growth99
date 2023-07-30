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
    func timesDataReceived(datesClick: Bool)
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

class AppointmentListDetailViewController: UIViewController, AppointmentListDetailVCProtocol {
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var firstNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var clincsTextField: CustomTextField!
    @IBOutlet weak var servicesTextField: CustomTextField!
    @IBOutlet weak var providersTextField: CustomTextField!
    @IBOutlet weak var appoinmentStatusField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var timeTextField: CustomTextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var inPersonBtn: UIButton!
    @IBOutlet weak var virtualBtn: UIButton!
    @IBOutlet weak var dateSelectionButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollViewAppointment: UIScrollView!
    
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
    var selectedProvidersIds = Int()
    
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
    var sourceTypeSelected: String = "Calender"
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let formatter = DateFormatter()
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    let radioController: RadioButtonController = RadioButtonController()
    let datesButtonClicked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.layer.borderColor = UIColor.gray.cgColor
        notesTextView.layer.borderWidth = 1.0
        eventViewModel = AppointmentListDetailViewModel(delegate: self)
        setUpNavigationBar()
        self.view.ShowSpinner()
        eventViewModel?.getEditAppointmentsForPateint(appointmentsId: appointmentId ?? 0)
        radioController.buttonsArray = [inPersonBtn, virtualBtn]
        radioController.defaultButton = inPersonBtn
        dateTextField.tintColor = .clear
        dateTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
    }
    
    @objc func dateFromButtonPressed() {
        dateTextField.text = dateFormatterString(textField: dateTextField)
        self.selectedDate = convertDateString2(dateString: dateTextField.text ?? "")
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
        self.eventViewModel?.getTimeList(dateStr: self.eventViewModel?.timeInputCalendarButton(date: dateTextField.text ?? "") ?? String.blank, clinicIds: self.selectedClincIds, providerId: self.selectedProvidersIds, serviceIds: self.selectedServicesIds, appointmentId: self.appointmentId ?? 0, datesButtonClick: true)
    }
    
    func convertDateString2(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: dateString) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            outputDateFormatter.timeZone = TimeZone(identifier: UserRepository.shared.timeZone ?? "")
            outputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            let formattedDate = outputDateFormatter.string(from: date)
            return formattedDate
        } else {
            return "Invalid date format"
        }
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
    
    func editAppointmentsForPateintDataRecived() {
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
        appoinmentStatusField.text = editBookingHistoryData?.appointmentStatus ?? String.blank
        dateTextField.text = eventViewModel?.serverToLocal(date: editBookingHistoryData?.appointmentStartDate ?? String.blank)
        self.selectedDate = editBookingHistoryData?.appointmentStartDate ?? String.blank
        self.selectedTime = editBookingHistoryData?.appointmentStartDate ?? String.blank
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
            self.eventViewModel?.getTimeList(dateStr: self.eventViewModel?.timeInputCalendar(date: self.selectedDate) ?? String.blank, clinicIds: editBookingHistoryData?.clinicId ?? 0, providerId: editBookingHistoryData?.providerId ?? 0, serviceIds: self.selectedServicesIds, appointmentId: appointmentId ?? 0, datesButtonClick: false)
        }
    }
    
    func serverToLocalDateFormat(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let inputDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: inputDate)
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
    
    func timesDataReceived(datesClick: Bool) {
        allTimesList = eventViewModel?.getAllTimessData ?? []
        if allTimesList.isEmpty {
            if datesClick {
                timeTextField.text = ""
                timeTextField.showError(message: "Appointment Time is required.")
                self.view.showToast(message: "There are no time slots available for the selected date", color: .red)
                scrollToBottom(of: scrollViewAppointment, animated: true)
                submitButton.isEnabled = false
                submitButton.backgroundColor = UIColor.init(hexString: "86BFE5")
            }
        } else {
            if datesClick {
                timeTextField.text = ""
                timeTextField.showError(message: "Please select appointment time.")
                submitButton.isSelected = true
                submitButton.isEnabled = true
                submitButton.backgroundColor = UIColor.init(hexString: "009EDE")
            }
        }
        self.view.HideSpinner()
    }
    
    func scrollToBottom(of scrollView: UIScrollView, animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        scrollView.setContentOffset(bottomOffset, animated: animated)
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
    
    func appoinmentEdited() {
        self.view.HideSpinner()
        self.view.showToast(message: "Appointment updated successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func appoinmentDeletedSucess() {
        self.view.HideSpinner()
        self.view.showToast(message: "Appointment cancelled successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func errorEventReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func convertDateString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let convertedDateString = dateFormatter.string(from: date)
            return convertedDateString
        }
        return "Invalid date string"
    }
}

extension AppointmentListDetailViewController {
    
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
