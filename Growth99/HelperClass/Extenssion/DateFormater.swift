//
//  DateFormater.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.
//

import Foundation

protocol DateFormaterProtocol: AnyObject {
    func serverToLocal(date: String) -> String
    func serverToLocalCreatedDate(date: String) -> String
    func serverToLocalWithoutTime(date: String) -> String
    func localToServer(date: String) -> String
    func utcToLocal(timeString: String) -> String?
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String 
}

class DateFormater: DateFormaterProtocol {
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: date) else { return ""}
        dateFormatter.dateFormat = "MMM dd yyyy h:mm a"
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
    
    func serverToLocalWithoutTime(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: date as Date)
    }
    
    func localToServer(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date)
    }
    
    func dateFormatterString(textField: CustomTextField) -> String {
        var datePicker = UIDatePicker()
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
        var timePicker = UIDatePicker()
        timePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        timePicker.datePickerMode = .time
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        textField.resignFirstResponder()
        timePicker.reloadInputViews()
        return formatter.string(from: timePicker.date)
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
