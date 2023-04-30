//
//  PostCalenderViewModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

protocol PostCalenderViewModelProtocol {
   
    func getPostCalenderList()
    var  postCalenderListData: [PostCalenderListModel] { get }
    
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    
    func appointmentListCountGreaterthan() -> Int
    func appointmentListCountLessthan() -> Int
    
    func serverToLocal(date: String) -> String
    func serverToLocalCalender(date: String) -> String
}


class PostCalenderViewModel: PostCalenderViewModelProtocol {

    var delegate: PostCalenderViewContollerProtocol?
    var postCalenderList: [PostCalenderListModel] = []
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    
    init(delegate: PostCalenderViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
   
    func getPostCalenderList() {
        self.requestManager.request(forPath: ApiUrl.socialMediaPostsList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[PostCalenderListModel], GrowthNetworkError>) in
            switch result {
            case .success(let postCalenderList):
                self.postCalenderList = postCalenderList
                self.delegate?.postCalenderListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    var postCalenderListData: [PostCalenderListModel] {
        return self.postCalenderList
    }
    
    func appointmentListCountGreaterthan() -> Int {
        return self.postCalenderList.filter({$0.scheduledDate?.toDate() ?? Date() > Date()}).count
    }
    
    func appointmentListCountLessthan() -> Int {
        return self.postCalenderList.filter({$0.scheduledDate?.toDate() ?? Date() < Date()}).count
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
    
    func serverToLocalCalender(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let dateString = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "h:mm a"
            let timeString = dateFormatter.string(from: dateString)
            return timeString
        }
        return ""
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
