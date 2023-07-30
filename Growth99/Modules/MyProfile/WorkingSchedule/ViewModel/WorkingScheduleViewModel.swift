//
//  WorkingScheduleViewModel.swift
//  Growth99
//
//  Created by admin on 30/11/22.
//

import Foundation

protocol WorkingScheduleViewModelProtocol {
    var getAllClinicsData: [Clinics] { get }
    var getWorkingSheduleData: [WorkingScheduleListModel] { get }
    func getallClinics()
    func getWorkingScheduleDeatils(selectedClinicId: Int)
    func sendRequestforWorkingSchedule(vacationParams: [String: Any])
    func removeElementFromArray(index: IndexPath)
    func addElementInArray(tableView: UITableView)
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    func serverToLocal(date: String) -> String?
    func serverToLocalTime(timeString: String) -> String
    func serverToLocalInput(date: String) -> String
    func serverToLocalTimeInput(timeString: String) -> String
    func serverToLocalInputWorking(date: String) -> String
    func convertDateWorking(dateString: String) -> String
    func convertDateFromDateTo(dateString: String) -> String
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
    
    func removeElementFromArray(index: IndexPath){
        self.workingSheduleList?[index.section].userScheduleTimings?.remove(at: index.row)
    }
    
    func addElementInArray(tableView: UITableView){
        let workingUserScheduleTimingsTemp = WorkingUserScheduleTimings(id: 1, timeFromDate: String.blank, timeToDate: String.blank, days: [])
        
        if self.workingSheduleList?.count == 0 {
            let parm = WorkingScheduleListModel(id: 1, clinicId: 1, providerId: 1, fromDate: String.blank, toDate: String.blank, scheduleType: String.blank, userScheduleTimings: [])
            self.workingSheduleList?.append(parm)
            tableView.reloadData()
        }
        self.workingSheduleList?[0].userScheduleTimings?.append(workingUserScheduleTimingsTemp)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: (self.workingSheduleList?[0].userScheduleTimings?.count ?? 0) - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}

extension WorkingScheduleViewModel: WorkingScheduleViewModelProtocol {
    
    var getAllClinicsData: [Clinics] {
        return self.allClinicsforWorkingSchedule ?? []
    }
    
    var getWorkingSheduleData: [WorkingScheduleListModel] {
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
    
    func serverToLocal(date: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let serverDate = dateFormatter.date(from: date) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale.current
            outputFormatter.dateFormat = "MM/dd/yyyy"
            let formattedDate = outputFormatter.string(from: serverDate)
            return formattedDate
        } else {
            print("Invalid date format: \(date)")
            return nil
        }
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
    
    func convertDateWorking(dateString: String) -> String {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "MM/dd/yyyy"
        
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        if let date = dateFormatterInput.date(from: dateString) {
            return dateFormatterOutput.string(from: date)
        }
        
        return ""
    }
    
    func convertDateFromDateTo(dateString: String) -> String {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "MM/dd/yyyy"
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatterOutput.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatterInput.date(from: dateString) {
            return dateFormatterOutput.string(from: date)
        }
        
        return ""
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: timeString) ?? Date()
        dateFormatter.dateFormat = "HH:mm"
        let time24 = dateFormatter.string(from: date)
        return time24
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
