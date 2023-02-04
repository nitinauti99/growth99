//
//  PatientAppointmentViewModel.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import Foundation

protocol PatientAppointmentViewModelProtocol {
    func getPatientAppointmentList(pateintId: Int)
    func patientListAtIndex(index: Int) -> PatientsAppointmentListModel?
    func patientListFilterListAtIndex(index: Int)-> PatientsAppointmentListModel?
    var  getPatientsAppointmentList: [PatientsAppointmentListModel] { get }
}

class PatientAppointmentViewModel {
 
    var delegate: PatientAppointmentViewControllerProtocol?
    var patientsAppointmentList: [PatientsAppointmentListModel] = []
    var patientsAppointmentFilterList: [PatientsAppointmentListModel] = []

    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    
    init(delegate: PatientAppointmentViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)


    func getPatientAppointmentList(pateintId: Int) {
        let finaleUrl = ApiUrl.PatientAppointmenList + "\(pateintId)" + "/appointments"
       
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[PatientsAppointmentListModel], GrowthNetworkError>) in
            switch result {
            case .success(let PateintsAppointmentList):
                self.patientsAppointmentList = PateintsAppointmentList
                self.delegate?.patientAppointmentListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedBookingHistory(error: error.localizedDescription)
            }
        }
    }
    
    
//    func dateFormatterString(textField: CustomTextField) -> String {
//        datePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let todaysDate = Date()
//        datePicker.minimumDate = todaysDate
//        textField.resignFirstResponder()
//        datePicker.reloadInputViews()
//        return dateFormatter.string(from: datePicker.date)
//    }
//
//    func timeFormatterString(textField: CustomTextField) -> String {
//        timePicker = textField.inputView as? UIDatePicker ?? UIDatePicker()
//        timePicker.datePickerMode = .time
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        textField.resignFirstResponder()
//        timePicker.reloadInputViews()
//        return formatter.string(from: timePicker.date)
//    }
//
//    func serverToLocal(date: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        let date = dateFormatter.date(from: date) ?? Date()
//        dateFormatter.dateFormat = "MMM d yyyy"
//        return dateFormatter.string(from: date)
//    }
//
//    func serverToLocalCreatedDate(date: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        let date = dateFormatter.date(from: date) ?? Date()
//        dateFormatter.dateFormat = "MMM d yyyy"
//        return dateFormatter.string(from: date)
//    }
//
//    func serverToLocalInput(date: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let date = dateFormatter.date(from: date) ?? Date()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//        return dateFormatter.string(from: date)
//    }
//
//    func serverToLocalInputWorking(date: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "MM/dd/yyyy"
//        let date = dateFormatter.date(from: date) ?? Date()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        return dateFormatter.string(from: date)
//    }
//
//    func serverToLocalTime(timeString: String) -> String {
//        let inFormatter = DateFormatter()
//        inFormatter.locale = Locale(identifier: "en_US_POSIX")
//        inFormatter.dateFormat = "HH:mm:ss"
//
//        let outFormatter = DateFormatter()
//        outFormatter.locale = Locale(identifier: "en_US_POSIX")
//        outFormatter.dateFormat = "hh:mm a"
//        outFormatter.amSymbol = "AM"
//        outFormatter.pmSymbol = "PM"
//
//        let date = inFormatter.date(from: timeString) ?? Date()
//        return outFormatter.string(from: date)
//    }
//
//    func serverToLocalTimeInput(timeString: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "hh:mm a"
//        let date = dateFormatter.date(from: timeString) ?? Date()
//        dateFormatter.dateFormat = "HH:mm"
//        dateFormatter.amSymbol = "AM"
//        dateFormatter.pmSymbol = "PM"
//        let date24 = dateFormatter.string(from: date)
//        return date24
//    }
//
//    func utcToLocal(timeString: String) -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        if let date = dateFormatter.date(from: timeString) {
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//            dateFormatter.dateFormat = "h:mm a"
//            return dateFormatter.string(from: date)
//        }
//        return nil
//    }
    
}

extension PatientAppointmentViewModel : PatientAppointmentViewModelProtocol {
   
    var getPatientsAppointmentList : [PatientsAppointmentListModel] {
        return self.patientsAppointmentList
    }
    
    func patientListAtIndex(index: Int) -> PatientsAppointmentListModel? {
        return self.patientsAppointmentList[index]
    }
    
    func patientListFilterListAtIndex(index: Int) -> PatientsAppointmentListModel? {
        return self.patientsAppointmentFilterList[index]
    }
    
}
