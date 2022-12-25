//
//  WorkingScheduleViewModel.swift
//  Growth99
//
//  Created by admin on 30/11/22.
//

import Foundation

class WorkingScheduleViewModel {
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    var allClinicsforWorkingSchedule: [Clinics]?
    
    var delegate: WorkingScheduleViewControllerCProtocol?

    init(delegate: WorkingScheduleViewControllerCProtocol? = nil) {
        self.delegate = delegate
    }

    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)

    func getallClinicsforWorkingSchedule(completion: @escaping([Clinics]?, Error?) -> Void) {
        ServiceManager.request(request: ApiRouter.getRequestForAllClinics.urlRequest, responseType: [Clinics].self) { response in
            switch response {
            case .success(let allClinics):
                completion(allClinics, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
        
    func sendRequestforWorkingSchedule(vacationParams: [String: Any]) {
        let apiURL = ApiUrl.vacationSubmit.appending("\(UserRepository.shared.userId ?? 0)/schedules")
        self.requestManager.request(forPath: apiURL, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: vacationParams, encoding: .jsonEncoding)) { (result: Result<ResponseModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                print(response)
                self.delegate?.apiResponseRecived(apiResponse: response)
            case .failure(let error):
                self.delegate?.apiErrorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func getWorkingScheduleDeatils(selectedClinicId: Int) {
        let apiURL = ApiUrl.userProfile.appending("\(UserRepository.shared.userId ?? 0)/clinic/\(selectedClinicId)/schedules/working")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[WorkingScheduleListModel], GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.delegate?.wcListResponseRecived(apiResponse: response)
            case .failure(let error):
                self.delegate?.apiErrorReceived(error: error.localizedDescription)
            }
        }
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
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date! as Date)
    }
    
    
    func serverToLocalInput(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date! as Date)
    }
    
    func serverToLocalInputWorking(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date! as Date)
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
