//
//  PostCalendarViewModel.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation

protocol PostCalendarViewModelProtocol {
    
    func getPostCalendarList()
    var  postCalendarListData: [PostCalendarListModel] { get }
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    func appointmentListCountGreaterthan() -> Int
    func appointmentListCountLessthan() -> Int
    func convertUTCtoLocalTime(dateString: String) -> String
    func serverToLocal(date: String) -> String
    func serverToLocalCalendar(date: String) -> String
}

class PostCalendarViewModel: PostCalendarViewModelProtocol {
    
    var delegate: PostCalendarViewContollerProtocol?
    var postCalendarList: [PostCalendarListModel] = []
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    
    init(delegate: PostCalendarViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getPostCalendarList() {
        self.requestManager.request(forPath: ApiUrl.socialMediaPostsList, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[PostCalendarListModel], GrowthNetworkError>) in
            switch result {
            case .success(let postCalendarList):
                self.postCalendarList = postCalendarList
                self.delegate?.postCalendarListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    var postCalendarListData: [PostCalendarListModel] {
        return self.postCalendarList
    }
    
    func appointmentListCountGreaterthan() -> Int {
        return self.postCalendarList.filter({$0.scheduledDate?.toDate() ?? Date() > Date()}).count
    }
    
    func appointmentListCountLessthan() -> Int {
        return self.postCalendarList.filter({$0.scheduledDate?.toDate() ?? Date() < Date()}).count
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
    
    func convertUTCtoLocalTime(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "hh:mm a"
            let formattedTime = dateFormatter.string(from: date)
            return formattedTime
        }
        return ""
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
    
    func serverToLocalCalendar(date: String) -> String {
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
