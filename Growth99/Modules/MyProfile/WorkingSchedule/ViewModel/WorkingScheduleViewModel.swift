//
//  WorkingScheduleViewModel.swift
//  Growth99
//
//  Created by admin on 30/11/22.
//

import Foundation

protocol WorkingScheduleViewModelProtocol {
    func getallClinics()
    var getAllClinicsData: [Clinics] { get }
    var getVacationData: [WorkingScheduleListModel] { get }
    func getWorkingScheduleDeatils(selectedClinicId: Int)
    func sendRequestforWorkingSchedule(vacationParams: [String: Any])
    
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    func serverToLocal(date: String) -> String
    func serverToLocalTime(timeString: String) -> String
    func serverToLocalInput(date: String) -> String
    func serverToLocalTimeInput(timeString: String) -> String
    func serverToLocalInputWorking(date: String) -> String
}

class WorkingScheduleViewModel {
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let formatter = DateFormatter()
    let todaysDate = Date()
    let dateFormatter = DateFormatter()
    let inFormatter = DateFormatter()
    let outFormatter = DateFormatter()

    var allClinicsforWorkingSchedule: [Clinics]?
    var workingSheduleList: [WorkingScheduleListModel]?

    var delegate: WorkingScheduleViewControllerCProtocol?

    init(delegate: WorkingScheduleViewControllerCProtocol? = nil) {
        self.delegate = delegate
    }

    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)

    func getallClinics() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allClinics):
                self.allClinicsforWorkingSchedule = allClinics
                self.delegate?.clinicsRecived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
        
    func getWorkingScheduleDeatils(selectedClinicId: Int) {
        let apiURL = ApiUrl.userProfile.appending("\(UserRepository.shared.userVariableId ?? 0)/clinic/\(selectedClinicId)/schedules/working")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[WorkingScheduleListModel], GrowthNetworkError>) in
            switch result {
            case .success(let list):
                self.workingSheduleList = list
                self.delegate?.wcListResponseRecived()
            case .failure(let error):
                self.delegate?.apiErrorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func sendRequestforWorkingSchedule(vacationParams: [String: Any]) {
        let apiURL = ApiUrl.vacationSubmit.appending("\(UserRepository.shared.userVariableId ?? 0)/schedules")
        self.requestManager.request(forPath: apiURL, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: vacationParams, encoding: .jsonEncoding)) { (result: Result<ResponseModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.delegate?.apiResponseRecived(apiResponse: response)
            case .failure(let error):
                self.delegate?.apiErrorReceived(error: error.localizedDescription)
            }
        }
    }
    
}

extension WorkingScheduleViewModel: WorkingScheduleViewModelProtocol {

    var getAllClinicsData: [Clinics] {
        return self.allClinicsforWorkingSchedule ?? []
    }
    
    var getVacationData: [WorkingScheduleListModel] {
        return self.workingSheduleList ?? []
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
        formatter.timeStyle = .short
        textField.resignFirstResponder()
        timePicker.reloadInputViews()
        return formatter.string(from: timePicker.date)
    }
    
    func serverToLocal(date: String) -> String {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: dateFormatter.date(from: date) ?? Date())
    }
    
    
    func serverToLocalInput(date: String) -> String {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: dateFormatter.date(from: date) ?? Date())
    }
    
    func serverToLocalInputWorking(date: String) -> String {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: dateFormatter.date(from: date) ?? Date())
    }
    
    func serverToLocalTime(timeString: String) -> String {
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = "HH:mm:ss"
        outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = "hh:mm a"
        outFormatter.amSymbol = "AM"
        outFormatter.pmSymbol = "PM"
        return outFormatter.string(from: inFormatter.date(from: timeString) ?? Date())
    }
    
    func serverToLocalTimeInput(timeString: String) -> String {
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: dateFormatter.date(from: timeString) ?? Date())
    }
}

class ViewModelItem {
    private var item: WorkingDaysModel
    var isSelected = false
    
    var title: String {
        return item.title
    }
    
    init(item: WorkingDaysModel) {
        self.item = item
    }
}

class WorkingDaysViewModel: NSObject {
    
    let daysArray = [WorkingDaysModel(title: "MONDAY"), WorkingDaysModel(title: "TUESDAY"), WorkingDaysModel(title: "WEDNASDAY"), WorkingDaysModel(title: "THURSDAY"), WorkingDaysModel(title: "FRIDAY"), WorkingDaysModel(title: "SATURDAY"), WorkingDaysModel(title: "SUNDAY")]

    var items = [ViewModelItem]()
    
    var selectedItems: [ViewModelItem] {
        return items.filter { return $0.isSelected }
    }
    
    override init() {
        super.init()
        items = daysArray.map { ViewModelItem(item: $0) }
    }
}
