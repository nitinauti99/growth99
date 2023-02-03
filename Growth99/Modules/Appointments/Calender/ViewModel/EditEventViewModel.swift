//
//  EditEventViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 03/02/23.
//

import Foundation

protocol EditEventViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool

    var getAllDatesData: [String] { get }
    var getAllTimessData: [String] { get }
    func getTimeList(dateStr: String, clinicIds: Int, providerId: Int, serviceIds: Array<Int>, appointmentId: Int)
    func getDatesList(clinicIds: Int, providerId: Int, serviceIds: Array<Int>)
    func timeInputCalender(date: String) -> String
    func serverToLocal(date: String) -> String
    func utcToLocal(dateStr: String) -> String?
    func serverToLocalInputWorking(date: String) -> String
    func appointmentDateInput(date: String) -> String
    func editAppoinemnetMethod(editAppoinmentId: Int, editAppoinmentModel: EditAppoinmentModel)
    func checkUserEmailAddress(emailAddress: String)
    func checkUserPhoneNumber(phoneNumber: String)
    func localInputToServerInput(date: String) -> String
    func localInputeDateToServer(date: String) -> String
    func deleteSelectedAppointment(deleteAppoinmentId: Int)
}

class EditEventViewModel {
    
    var delegate: EditEventViewControllerProtocol?
    var allDates: [String] = []
    var allTimes: [String] = []

    init(delegate: EditEventViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
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
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<String, GrowthNetworkError>) in
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
    
}

extension EditEventViewModel: EditEventViewModelProtocol {
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.count == 10 {
            return true
        }
        return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

