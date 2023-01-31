//
//  BookingHistoryViewModel.swift
//  Growth99
//
//  Created by Mahender Reddy on 31/01/23.
//

import Foundation

protocol BookingHistoryViewModelProtocol {
    func getallClinicsBookingHistory()
    var getAllClinicsDataBookingHistory: [Clinics] { get }
    
    func getServiceListBookingHistory()
    var serviceDataBookingHistory: [ServiceList] { get }
    
    func sendProviderListBookingHistory(providerParams: Int)
    var providerDataBookingHistory: [UserDTOList] { get }
    
    func getCalenderInfoListBookingHistory(clinicId: Int, providerId: Int, serviceId: Int)
    var appointmentInfoListDataBookingHistory: [AppointmentDTOList] { get }
    
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    
    func appointmentListCountGreaterthanBookingHistory() -> Int
    func appointmentListCountLessthanBookingHistory() -> Int
    
    func serverToLocal(date: String) -> String
    func utcToLocal(timeString: String) -> String?
    func serverToLocalTime(timeString: String) -> String
    func serverToLocalCreatedDate(date: String) -> String
}


class BookingHistoryViewModel:BookingHistoryViewModelProtocol {
    
    func appointmentListCountLessthanBookingHistory() -> Int {
        return 0
    }
    
    
    var delegate: BookingHistoryViewContollerProtocol?
    var allClinicsBookingHistory: [Clinics]?
    var serviceListDataBookingHistory: [ServiceList] = []
    var providerListDataBookingHistory: [UserDTOList] = []
    var appoinmentListDataBookingHistory: [AppointmentDTOList] = []
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    
    init(delegate: BookingHistoryViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getallClinicsBookingHistory() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allClinics):
                self.allClinicsBookingHistory = allClinics
                self.delegate?.clinicsReceivedBookingHistory()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceivedBookingHistory(error: error.localizedDescription)
            }
        }
    }
    
    var getAllClinicsDataBookingHistory: [Clinics] {
        return self.allClinicsBookingHistory ?? []
    }
    
    func getServiceListBookingHistory() {
        self.requestManager.request(forPath: ApiUrl.getAllServices, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ServiceListModel, GrowthNetworkError>) in
            switch result {
            case .success(let serviceData):
                self.serviceListDataBookingHistory = serviceData.serviceList ?? []
                self.delegate?.serviceListDataRecivedBookingHistory()
            case .failure(let error):
                self.delegate?.errorReceivedBookingHistory(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var serviceDataBookingHistory: [ServiceList] {
        return self.serviceListDataBookingHistory
    }
    
    func sendProviderListBookingHistory(providerParams: Int) {
        let apiURL = ApiUrl.providerList.appending("\(providerParams)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<ProviderListModel, GrowthNetworkError>) in
            switch result {
            case .success(let providerData):
                self.providerListDataBookingHistory = providerData.userDTOList ?? []
                self.delegate?.providerListDataRecivedBookingHistory()
            case .failure(let error):
                self.delegate?.errorReceivedBookingHistory(error: error.localizedDescription)
            }
        }
    }
    
    var providerDataBookingHistory: [UserDTOList] {
        return self.providerListDataBookingHistory
    }
    
    func getCalenderInfoListBookingHistory(clinicId: Int, providerId: Int, serviceId: Int) {
        let url = "\(clinicId)&providerId=\(providerId)&serviceId=\(serviceId)"
        let apiURL = ApiUrl.calenderInfo.appending("\(url)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<CalenderInfoListModel, GrowthNetworkError>) in
            switch result {
            case .success(let appointmentDTOListData):
                self.appoinmentListDataBookingHistory = appointmentDTOListData.appointmentDTOList ?? []
                self.delegate?.appointmentListDataRecivedBookingHistory()
            case .failure(let error):
                self.delegate?.errorReceivedBookingHistory(error: error.localizedDescription)
            }
        }
    }
    var appointmentInfoListDataBookingHistory: [AppointmentDTOList] {
        return self.appoinmentListDataBookingHistory
    }
    
    func appointmentListCountGreaterthanBookingHistory() -> Int {
        return self.appoinmentListDataBookingHistory.filter({$0.appointmentStartDate?.toDate() ?? Date() > Date()}).count
    }
    
    func appointmentListCountLessthan() -> Int {
        return self.appoinmentListDataBookingHistory.filter({$0.appointmentStartDate?.toDate() ?? Date() < Date()}).count
    }
    
    func dateFormatterString(textField: CustomTextField) -> String {
        datePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let todaysDate = Date()
        datePicker.minimumDate = todaysDate
        textField.resignFirstResponder()
        datePicker.reloadInputViews()
        return dateFormatter.string(from: datePicker.date)
    }
    
    func timeFormatterString(textField: CustomTextField) -> String {
        timePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        timePicker.datePickerMode = .time
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        textField.resignFirstResponder()
        timePicker.reloadInputViews()
        return formatter.string(from: timePicker.date)
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM d yyyy"
        return dateFormatter.string(from: date)
    }
    
    func serverToLocalCreatedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM d yyyy"
        return dateFormatter.string(from: date)
    }
    
    func serverToLocalInput(date: String) -> String {
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
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date)
    }
    
    func serverToLocalTime(timeString: String) -> String {
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "HH:mm:ss"

        let outFormatter = DateFormatter()
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = "hh:mm a"
        outFormatter.amSymbol = "AM"
        outFormatter.pmSymbol = "PM"

        let date = inFormatter.date(from: timeString) ?? Date()
        return outFormatter.string(from: date)
    }
    
    func serverToLocalTimeInput(timeString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: timeString) ?? Date()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date24 = dateFormatter.string(from: date)
        return date24
    }
    
    func utcToLocal(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
}
