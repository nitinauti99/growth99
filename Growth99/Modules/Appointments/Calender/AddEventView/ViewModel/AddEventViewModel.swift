//
//  AddEventViewModel.swift
//  Growth99
//
//  Created by Exaze Technologies on 18/01/23.
//

import Foundation

protocol AddEventViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool

    var  getAllDatesData: [String] { get }
    var  getAllTimessData: [String] { get }
    func getTimeList(dateStr: String, clinicIds: Int, providerId: Int, serviceIds: Array<Int>, appointmentId: Int)
    func getDatesList(clinicIds: Int, providerId: Int, serviceIds: Array<Int>)
    func timeInputCalender(date: String) -> String
    func serverToLocal(date: String) -> String
    func utcToLocal(dateStr: String) -> String?
    func serverToLocalInputWorking(date: String) -> String
    func appointmentDateInput(date: String) -> String
    func createAppoinemnetMethod(addEventModel: NewAppoinmentModel)
    func checkUserEmailAddress(emailAddress: String)
    func checkUserPhoneNumber(phoneNumber: String)
    func localInputToServerInput(date: String) -> String
    func localInputeDateToServer(date: String) -> String
    func getPateintsAppointData()
    var getPatientsAppointmentList: [PatientsModel] { get }
}

class AddEventViewModel {
    
    var delegate: AddEventViewControllerProtocol?
    var allDates: [String] = []
    var allTimes: [String] = []
    var patientsAppointmentList = [PatientsModel]()

    init(delegate: AddEventViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getPateintsAppointData(){
        self.requestManager.request(forPath: ApiUrl.patientsByTenantId, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[PatientsModel], GrowthNetworkError>) in
            switch result {
            case .success(let PateintsAppointmentList):
                self.patientsAppointmentList = PateintsAppointmentList
                self.delegate?.patientAppointmentListDataRecived()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
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
    
    func createAppoinemnetMethod(addEventModel: NewAppoinmentModel) {
        let parameters: Parameters = [
            "firstName": addEventModel.firstName ?? String.blank,
            "lastName": addEventModel.lastName ?? String.blank,
            "email": addEventModel.email ?? String.blank,
            "phone": addEventModel.phone ?? String.blank,
            "notes": addEventModel.notes ?? String.blank,
            "clinicId": addEventModel.clinicId ?? String.blank,
            "serviceIds": addEventModel.serviceIds ?? String.blank,
            "providerId": addEventModel.providerId ?? String.blank,
            "date": addEventModel.date ?? String.blank,
            "time": addEventModel.time ?? String.blank,
            "appointmentType": addEventModel.appointmentType ?? String.blank,
            "source": addEventModel.source ?? String.blank,
            "appointmentDate": addEventModel.appointmentDate ?? String.blank
        ]
        self.requestManager.request(forPath: ApiUrl.newAppointment, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: parameters, encoding: .jsonEncoding)) { (result: Result<AppoinmentModel, GrowthNetworkError>) in
            switch result {
            case .success(let appoinmentData):
                self.delegate?.appoinmentCreated(apiResponse: appoinmentData)
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

extension AddEventViewModel : AddEventViewModelProtocol {
   
    var getPatientsAppointmentList: [PatientsModel] {
        return self.patientsAppointmentList
    }
    
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
