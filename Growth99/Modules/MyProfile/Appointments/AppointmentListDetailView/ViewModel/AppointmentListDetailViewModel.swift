//
//  AppointmentListDetailViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 10/02/23.
//

import Foundation

protocol AppointmentListDetailVMProtocol {
    var  getAllDatesData: [String] { get }
    var  getAllTimessData: [String] { get }
    func getTimeList(dateStr: String, clinicIds: Int, providerId: Int, serviceIds: Array<Int>, appointmentId: Int)
    func getDatesList(clinicIds: Int, providerId: Int, serviceIds: Array<Int>)
    func editAppoinemnetMethod(editAppoinmentId: Int, editAppoinmentModel: EditAppoinmentModel)
    func checkUserEmailAddress(emailAddress: String)
    func checkUserPhoneNumber(phoneNumber: String)
    
    func localInputToServerInput(date: String) -> String
    func localInputeDateToServer(date: String) -> String
    func serverToLocal(date: String) -> String
    func utcToLocal(dateStr: String) -> String?
    func serverToLocalInputWorking(date: String) -> String
    func appointmentDateInput(date: String) -> String
    func timeInputCalender(date: String) -> String
    
    func deleteSelectedAppointment(deleteAppoinmentId: Int)
    func getEditAppointmentsForPateint(appointmentsId: Int)
    var  getAppointmentsForPateintData: AppointmentDTOList? { get }
    
    func getallClinicsEditEvent()
    var  getAllClinicsDataEditEvent: [Clinics] { get }
    
    func getServiceListEditEvent()
    var  serviceDataEditEvent: [ServiceList] { get }
    
    func sendProviderListEditEvent(providerParams: Int)
    var  providerDataEditEvent: [UserDTOList] { get }
    
    func isFirstName(_ firstName: String) -> Bool
    func isLastName(_ lastName: String) -> Bool
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
}

class AppointmentListDetailViewModel: AppointmentListDetailVMProtocol {
    
    var delegate: AppointmentListDetailVCProtocol?
    var allDates: [String] = []
    var allTimes: [String] = []
    var editBookingHistoryData: AppointmentDTOList?
    var allClinicsEditEvent: [Clinics]?
    var serviceListDataEditEvent: [ServiceList] = []
    var providerListDataEditEvent: [UserDTOList] = []
    
    init(delegate: AppointmentListDetailVCProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getEditAppointmentsForPateint(appointmentsId: Int) {
        let finaleUrl = ApiUrl.editAppoints + "\(appointmentsId)"
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) { (result: Result< AppointmentDTOList, GrowthNetworkError>) in
            switch result {
            case .success(let PateintsAppointmentList):
                self.editBookingHistoryData = PateintsAppointmentList
                self.delegate?.editAppointmentsForPateintDataRecived()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    func getallClinicsEditEvent() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allClinics):
                self.allClinicsEditEvent = allClinics
                self.delegate?.clinicsReceivedEventEdit()
            case .failure(let error):
                print(error)
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    var getAllClinicsDataEditEvent: [Clinics] {
        return self.allClinicsEditEvent ?? []
    }
    
    func getServiceListEditEvent() {
        self.requestManager.request(forPath: ApiUrl.getAllServices, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ServiceListModel, GrowthNetworkError>) in
            switch result {
            case .success(let serviceData):
                self.serviceListDataEditEvent = serviceData.serviceList ?? []
                self.delegate?.serviceListDataRecivedEventEdit()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var serviceDataEditEvent: [ServiceList] {
        return self.serviceListDataEditEvent
    }
    
    func sendProviderListEditEvent(providerParams: Int) {
        let apiURL = ApiUrl.providerList.appending("\(providerParams)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<ProviderListModel, GrowthNetworkError>) in
            switch result {
            case .success(let providerData):
                self.providerListDataEditEvent = providerData.userDTOList ?? []
                self.delegate?.providerListDataRecivedEventEdit()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    var providerDataEditEvent: [UserDTOList] {
        return self.providerListDataEditEvent
    }
    
    func getDatesList(clinicIds: Int, providerId: Int, serviceIds: Array<Int>) {
        let apiURL = ApiUrl.vacationSubmit.appending("\(providerId)/schedules/dates")
        let parameter: Parameters = ["clinicId": clinicIds,
                                     "providerId": providerId,
                                     "serviceIds": serviceIds,
        ]
        self.requestManager.request(forPath: apiURL, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<[String], GrowthNetworkError>) in
            switch result {
            case .success(let datesData):
                self.allDates = datesData
                self.delegate?.datesDataReceived()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    func getTimeList(dateStr: String, clinicIds: Int, providerId: Int, serviceIds: Array<Int>, appointmentId: Int) {
        let apiURL = ApiUrl.vacationSubmit.appending("\(providerId)/schedules/times")
        let parameter: Parameters = ["date": dateStr,
                                     "clinicId": clinicIds,
                                     "providerId": providerId,
                                     "serviceIds": serviceIds,
                                     "appointmentId": appointmentId
        ]
        self.requestManager.request(forPath: apiURL, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<[String], GrowthNetworkError>) in
            switch result {
            case .success(let timesData):
                self.allTimes = timesData
                self.delegate?.timesDataReceived()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    func checkUserEmailAddress(emailAddress: String) {
        let apiURL = ApiUrl.userByPhone.appending("\(emailAddress)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[String], GrowthNetworkError>) in
            switch result {
            case .success(_):
                self.delegate?.getEmailAddressDataRecived()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    func checkUserPhoneNumber(phoneNumber: String) {
        let apiURL = ApiUrl.userByPhone.appending("\(phoneNumber)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[AddEventPhoneModel], GrowthNetworkError>) in
            switch result {
            case .success(_):
                self.delegate?.getPhoneNumberDataRecived()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    func editAppoinemnetMethod(editAppoinmentId: Int, editAppoinmentModel: EditAppoinmentModel) {
        let parameters: Parameters = [
            "firstName": editAppoinmentModel.firstName ?? String.blank,
            "lastName": editAppoinmentModel.lastName ?? String.blank,
            "email": editAppoinmentModel.email ?? String.blank,
            "phone": editAppoinmentModel.phone ?? String.blank,
            "notes": editAppoinmentModel.notes ?? String.blank,
            "clinicId": editAppoinmentModel.clinicId ?? String.blank,
            "serviceIds": editAppoinmentModel.serviceIds ?? String.blank,
            "providerId": editAppoinmentModel.providerId ?? String.blank,
            "date": editAppoinmentModel.date ?? String.blank,
            "time": editAppoinmentModel.time ?? String.blank,
            "appointmentType": editAppoinmentModel.appointmentType ?? String.blank,
            "source": editAppoinmentModel.source ?? String.blank,
            "appointmentConfirmationStatus": editAppoinmentModel.appointmentConfirmationStatus ?? String.blank,
            "appointmentDate": editAppoinmentModel.appointmentDate ?? String.blank
        ]
        self.requestManager.request(forPath: ApiUrl.editAppointment.appending("\(editAppoinmentId)"), method: .PUT, headers: self.requestManager.Headers(), task: .requestParameters(parameters: parameters, encoding: .jsonEncoding)) { (result: Result<AppoinmentModel, GrowthNetworkError>) in
            switch result {
            case .success(_):
                self.delegate?.appoinmentEdited()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    func deleteSelectedAppointment(deleteAppoinmentId: Int) {
        let apiURL = ApiUrl.editAppointment.appending("\(deleteAppoinmentId)/cancel")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.delegate?.appoinmentDeletedSucess()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    var getAllDatesData: [String] {
        return allDates
    }
    
    var getAllTimessData: [String] {
        return allTimes
    }
    
    func timeInputCalender(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date)
    }
    
    func appointmentDateInput(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z'"
        return dateFormatter.string(from: date)
    }
    
    func localInputToServerInput(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date)
    }
    
    func serverToLocalInputWorking(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: date)
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func localInputeDateToServer(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date)
    }
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    var getAppointmentsForPateintData: AppointmentDTOList? {
        return self.editBookingHistoryData
    }
    
    func isFirstName(_ firstName: String) -> Bool {
        let regex = Constant.Regex.nameWithoutSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: firstName)
    }
    
    func isLastName(_ lastName: String) -> Bool {
        let regex = Constant.Regex.nameWithoutSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: lastName)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let regex = Constant.Regex.phone
        let isPhoneNo = NSPredicate(format:"SELF MATCHES %@", regex)
        return isPhoneNo.evaluate(with: phoneNumber)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = Constant.Regex.email
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
