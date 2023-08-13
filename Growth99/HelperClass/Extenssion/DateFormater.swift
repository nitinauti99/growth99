//
//  DateFormater.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.
//

import Foundation

protocol DateFormaterProtocol: AnyObject {
    func serverToLocalWithoutTime(date: String) -> String
    func localToServer(date: String) -> String
    func utcToLocal(timeString: String) -> String?
    func dateFormatterString(textField: CustomTextField) -> String
    func timeFormatterString(textField: CustomTextField) -> String
    func utcToLocalAccounts(timeString: String) -> String?
    func localToServerWithDate(date: String) -> String
    func localToServerSocial(date: String) -> String
    func dateFormatterStringBirthDate(textField: CustomTextField) -> String
    func serverToLocalforCalender(date: String, calenderTimeZone: String) -> String
    func serverToLocalDateConverter(date: String) -> String
    func serverToLocalPateintsAppointment(date: String) -> String
    func serverToLocalBirthDateFormate(date: String) -> String
    func serverToLocalPateintTimeLineDate(date: String) -> String
    func serverToLocalDateConverterOnlyDate(date: String) -> String
    func serverToLocalTimeAndDateFormate(date: String) -> String
    func localToServerCalender(date: String) -> String
    func convertDateStringToStringCalender(dateString: String) -> String
    func serverToLocalDateConverterOnlyDateWorkinngShedule(date: String) -> String
    func convertDateStringlocalToServer(dateString: String) -> String
    func convertDateStringlocalToServerTrigger(dateString: String) -> String
    func convertDateStringToStringTrigger(dateString: String) -> String
}

class DateFormater: DateFormaterProtocol {
    
    let timeZone =  UserRepository.shared.timeZone
    
    func serverToLocalDateConverter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
        if let date = dateFormatter.date(from: date) {
            let usDateFormatter = DateFormatter()
            usDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
            usDateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
            let usDateString = usDateFormatter.string(from: date)
            return usDateString
        }
        return ""
    }
    
    func serverToLocalDateConverterOnlyDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
        if let date = dateFormatter.date(from: date) {
            let usDateFormatter = DateFormatter()
            usDateFormatter.dateFormat = "MM-dd-yyyy"
            usDateFormatter.timeZone = TimeZone(identifier: "UTC")
            let usDateString = usDateFormatter.string(from: date)
            return usDateString
        }
        return ""
    }
    
    func serverToLocalDateConverterOnlyDateWorkinngShedule(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
        if let date = dateFormatter.date(from: date) {
            let usDateFormatter = DateFormatter()
            usDateFormatter.dateFormat = "MM/dd/yyyy"
            usDateFormatter.timeZone = TimeZone(identifier: "UTC")
            let usDateString = usDateFormatter.string(from: date)
            return usDateString
        }
        return ""
    }
    
    func serverToLocalPateintTimeLineDate(date: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            let date = dateFormatter.date(from: date) ?? Date()
            dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
            dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
            return dateFormatter.string(from: date)
        }

    func serverToLocalPateintsAppointment(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: date) {
            let usDateFormatter = DateFormatter()
            usDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
            usDateFormatter.timeZone = TimeZone(identifier: "UTC")
            let usDateString = usDateFormatter.string(from: date)
            return usDateString  // Prints: "Mar 26, 2023 08:30 AM"
        }
        return ""
    }
    
    func serverToLocalWithoutTime(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: date as Date)
    }
    
    func serverToLocalBirthDateFormate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: date)
    }
    
    /// conver date local to sever formate
 
    func localToServer(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.string(from: date)
    }
    
    func localToServerSocial(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date)
    }
    
    
    func localToServerCalender(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm a"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.timeZone = TimeZone(abbreviation: "EDT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date)
    }
    
    func convertDateStringToStringCalender(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
        if let date = dateFormatter.date(from: dateString) {
            let usDateFormatter = DateFormatter()
            usDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            usDateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
            let usDateString = usDateFormatter.string(from: date)
            return usDateString
        }
        return ""
    }
    
    func convertDateStringToStringTrigger(dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        guard let date = inputFormatter.date(from: dateString) else {
            return "Invalid Date"
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 19800)
        return outputFormatter.string(from: date)
    }
    
    func convertDateStringlocalToServer(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: dateString) {
            let usDateFormatter = DateFormatter()
            usDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            usDateFormatter.timeZone = TimeZone(abbreviation: timeZone ?? "")
            let usDateString = usDateFormatter.string(from: date)
            return usDateString
        }
        return ""
    }
    
    func convertDateStringlocalToServerTrigger(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: dateString) {
            let usDateFormatter = DateFormatter()
            usDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            usDateFormatter.timeZone = TimeZone(abbreviation: timeZone ?? "")
            let usDateString = usDateFormatter.string(from: date)
            return usDateString
        }
        return ""
    }
    
    func localToServerWithDate(date: String) -> String {
        let currentDate = Date()
        let dateFormatter22 = DateFormatter()
        dateFormatter22.string(from: currentDate)
        dateFormatter22.dateFormat = "yyyy-MM-dd'T'"
        dateFormatter22.locale = Locale(identifier: "en_US_POSIX")
        
        let dateWith = dateFormatter22.string(from: currentDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "HH:mm:ss'Z'"
        return dateWith + dateFormatter.string(from: date)
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
    
    func dateFormatterStringBirthDate(textField: CustomTextField) -> String {
        var datePicker = UIDatePicker()
        datePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let todaysDate = Date()
        datePicker.maximumDate = todaysDate
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
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone ?? "")
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.timeZone = TimeZone(abbreviation: timeZone ?? "")
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func utcToLocalAccounts(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func serverToLocalforCalender(date: String, calenderTimeZone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: date) {
            let usDateFormatter = DateFormatter()
            usDateFormatter.dateFormat = "h:mm a"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let usDateString = usDateFormatter.string(from: date)
            return usDateString
        }
        return ""
    }
    
    func serverToLocalTimeAndDateFormate(date: String) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

         let usDateFormatter = DateFormatter()
         usDateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
         dateFormatter.timeZone = TimeZone.current
         let date = dateFormatter.date(from: date) ?? Date()
         return usDateFormatter.string(from: date)
     }
}


  



//    func serverToLocalforClinics(date: String) -> String {
//        print("sheduled Date",date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
//        if let date = dateFormatter.date(from: date) {
//            let usDateFormatter = DateFormatter()
//            usDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
//            usDateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
//            let usDateString = usDateFormatter.string(from: date)
//            return usDateString
//        }
//        return ""
//    }

//    func serverToLocal(date: String) -> String {
//        print("sheduled Date",date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
//        if let date = dateFormatter.date(from: date) {
//            let usDateFormatter = DateFormatter()
//            usDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
//            usDateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
//            let usDateString = usDateFormatter.string(from: date)
//            return usDateString
//        }
//        return ""
//    }



//    func serverToLocalforPateints(date: String) -> String {
//        print("sheduled Date",date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
//        if let date = dateFormatter.date(from: date) {
//            let usDateFormatter = DateFormatter()
//            usDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
//            usDateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
//            let usDateString = usDateFormatter.string(from: date)
//            return usDateString
//        }
//        return ""
//    }

//    func serverToLocalforPost(date: String) -> String {
//        print("sheduled Date",date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
//        if let date = dateFormatter.date(from: date) {
//            let usDateFormatter = DateFormatter()
//            usDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
//            usDateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
//            let usDateString = usDateFormatter.string(from: date)
//            return usDateString
//        }
//        return ""
//    }

//    func localToServerSocialForPost(date: String) -> String {
//        print("sheduled Date",date)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
//        dateFormatter.dateFormat = "MM/dd/yyyy hh:mma"
//        let dateFormated = dateFormatter.date(from: date)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//        return dateFormatter.string(from: dateFormated!)
//    }

//    func serverToLocalforPostWithCurrentTimeZone(date: String) -> String {
//        print("sheduled Date",date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
//        if let date = dateFormatter.date(from: date) {
//            let usDateFormatter = DateFormatter()
//            usDateFormatter.dateFormat = "MM/dd/yyyy h:mm a"
//            usDateFormatter.timeZone = TimeZone.current
//            let usDateString = usDateFormatter.string(from: date)
//            return usDateString
//        }
//        return ""
//    }

//    func serverToLocalCreatedDate(date: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        let date = dateFormatter.date(from: date) ?? Date()
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
//        dateFormatter.dateFormat = "MMM d yyyy"
//        return dateFormatter.string(from: date)
//    }

//    func serverToLocalDate(date: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        let date = dateFormatter.date(from: date) ?? Date()
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        return dateFormatter.string(from: date)
//    }
