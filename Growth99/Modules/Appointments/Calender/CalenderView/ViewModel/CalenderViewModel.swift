//
//  CalenderViewModel.swift
//  Growth99
//
//  Created by Exaze Technologies on 16/01/23.
//

import Foundation

protocol CalenderViewModelProtocol {
    func getallClinics()
    var  getAllClinicsData: [Clinics] { get }
    
    func getServiceList()
    var  serviceData: [ServiceList] { get }
    
    func sendProviderList(providerParams: Int)
    var  providerData: [UserDTOList] { get }
    
    func getCalenderInfoList(clinicId: Int, providerId: Int, serviceId: Int)
    var  appointmentInfoListData: [AppointmentDTOList] { get }
    
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    
    func appointmentListCountGreaterthan() -> Int
    func appointmentListCountLessthan() -> Int
    
    func serverToLocal(date: String) -> String
}


class CalenderViewModel: CalenderViewModelProtocol {
    
    var delegate: CalenderViewContollerProtocol?
    var allClinics: [Clinics]?
    var serviceListData: [ServiceList] = []
    var providerListData: [UserDTOList] = []
    var appoinmentListData: [AppointmentDTOList] = []
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    
    init(delegate: CalenderViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getallClinics() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allClinics):
                self.allClinics = allClinics
                self.delegate?.clinicsReceived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    var getAllClinicsData: [Clinics] {
        return self.allClinics ?? []
    }
    
    func getServiceList() {
        self.requestManager.request(forPath: ApiUrl.getAllServices, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ServiceListModel, GrowthNetworkError>) in
            switch result {
            case .success(let serviceData):
                self.serviceListData = serviceData.serviceList ?? []
                self.delegate?.serviceListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var serviceData: [ServiceList] {
        return self.serviceListData
    }
    
    func sendProviderList(providerParams: Int) {
        let apiURL = ApiUrl.providerList.appending("\(providerParams)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<ProviderListModel, GrowthNetworkError>) in
            switch result {
            case .success(let providerData):
                self.providerListData = providerData.userDTOList ?? []
                self.delegate?.providerListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    var providerData: [UserDTOList] {
        return self.providerListData
    }
    
    func getCalenderInfoList(clinicId: Int, providerId: Int, serviceId: Int) {
        let url = "\(clinicId)&providerId=\(providerId)&serviceId=\(serviceId)"
        let apiURL = ApiUrl.calenderInfo.appending("\(url)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<CalenderInfoListModel, GrowthNetworkError>) in
            switch result {
            case .success(let appointmentDTOListData):
                self.appoinmentListData = appointmentDTOListData.appointmentDTOList ?? []
                self.delegate?.appointmentListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    var appointmentInfoListData: [AppointmentDTOList] {
        return self.appoinmentListData
    }
    
    func appointmentListCountGreaterthan() -> Int {
        return self.appoinmentListData.filter({$0.appointmentStartDate?.toDate() ?? Date() > Date()}).count
    }
    
    func appointmentListCountLessthan() -> Int {
        return self.appoinmentListData.filter({$0.appointmentStartDate?.toDate() ?? Date() < Date()}).count
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
        dateFormatter.dateFormat = "EEEE - MMM d"
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
    
}
