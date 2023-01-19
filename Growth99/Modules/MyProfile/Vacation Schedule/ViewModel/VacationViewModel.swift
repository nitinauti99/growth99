//
//  VacationViewModel.swift
//  Growth99
//
//  Created by admin on 26/11/22.
//

import Foundation

protocol VacationViewModelProtocol {
    func getallClinics()
    var getAllClinicsData: [Clinics] { get }
    var getVacationData: [VacationsListModel] { get }
    func getVacationDeatils(selectedClinicId: Int)
    func sendRequestforVacation(vacationParams: [String: Any])
    
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    func serverToLocal(date: String) -> String
    func serverToLocalTime(timeString: String) -> String
    func serverToLocalInput(date: String) -> String
    func serverToLocalTimeInput(timeString: String) -> String
    
}

class VacationViewModel {
    var allClinicsforVacation: [Clinics]?
    var vacationList: [VacationsListModel]?
    
    let inFormatter = DateFormatter()
    let outFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let todaysDate = Date()
    
    var delegate: VacationScheduleViewControllerCProtocol?
    
    init(delegate: VacationScheduleViewControllerCProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getallClinics() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allClinics):
                self.allClinicsforVacation = allClinics
                self.delegate?.clinicsRecived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func getVacationDeatils(selectedClinicId: Int) {
        let url = "\(UserRepository.shared.userId ?? 0)/clinic/\(selectedClinicId)/schedules/vacation"
        self.requestManager.request(forPath: ApiUrl.userProfile.appending(url), method: .GET, headers: self.requestManager.Headers()) { (result: Result<[VacationsListModel], GrowthNetworkError>) in
            switch result {
            case .success(let list):
                self.vacationList = list
                self.delegate?.vacationsListResponseRecived()
            case .failure(let error):
                self.delegate?.apiErrorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func sendRequestforVacation(vacationParams: [String: Any]) {
        let url = "\(UserRepository.shared.userId ?? 0)/vacation-schedules"
        self.requestManager.request(forPath: ApiUrl.vacationSubmit.appending(url), method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: vacationParams, encoding: .jsonEncoding)) { (result: Result<ResponseModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.apiResponseRecived(apiResponse: response)
            case .failure(let error):
                self.delegate?.apiErrorReceived(error: error.localizedDescription)
            }
        }
    }
    
}

extension VacationViewModel: VacationViewModelProtocol {
   
    var getAllClinicsData: [Clinics] {
        return self.allClinicsforVacation ?? []
    }
    
    var getVacationData: [VacationsListModel] {
        return self.vacationList ?? []
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
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func serverToLocalTime(timeString: String) -> String {
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "HH:mm:ss"

        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = "hh:mm a"
        outFormatter.amSymbol = "AM"
        outFormatter.pmSymbol = "PM"
        let date = inFormatter.date(from: timeString) ?? Date()
        return outFormatter.string(from: date)
    }
    
    
    func serverToLocalInput(date: String) -> String {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date)
    }
    
    func serverToLocalTimeInput(timeString: String) -> String {
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
