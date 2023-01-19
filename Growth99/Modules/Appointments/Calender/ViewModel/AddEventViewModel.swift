//
//  AddEventViewModel.swift
//  Growth99
//
//  Created by Exaze Technologies on 18/01/23.
//

import Foundation

protocol AddEventViewModelProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool

    var getAllDatesData: [String] { get }
    var getAllTimessData: [String] { get }
    func getTimeList(dateStr: String, clinicIds: Int, providerId: Int, serviceIds: Array<Int>, appointmentId: Int)
    func getDatesList(clinicIds: Int, providerId: Int, serviceIds: Array<Int>)
    func timeInputCalender(date: String) -> String
    func serverToLocal(date: String) -> String
    func utcToLocal(dateStr: String) -> String?
}

class AddEventViewModel {
    
    var delegate: AddEventViewControllerProtocol?
    var allDates: [String] = []
    var allTimes: [String] = []

    init(delegate: AddEventViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getDatesList(clinicIds: Int, providerId: Int, serviceIds: Array<Int>) {
        let apiURL = ApiUrl.vacationSubmit.appending("\(providerId)/schedules/dates")
        let parameter: Parameters = ["clinicId": clinicIds,
                                     "providerId": providerId,
                                     "serviceIds": serviceIds,
        ]
        self.requestManager.request(forPath: apiURL, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<[String], GrowthNetworkError>) in
            switch result {
            case .success(let datesData):
                self.allDates = datesData
                self.delegate?.datesDataReceived()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    func getTimeList(dateStr: String, clinicIds: Int, providerId: Int, serviceIds: Array<Int>, appointmentId: Int) {
        let apiURL = ApiUrl.vacationSubmit.appending("\(providerId)/schedules/times")
        let parameter: Parameters = ["date": dateStr,
                                     "clinicId": clinicIds,
                                     "providerId": providerId,
                                     "serviceIds": serviceIds,
                                     "appointmentId": appointmentId
        ]
        self.requestManager.request(forPath: apiURL, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<[String], GrowthNetworkError>) in
            switch result {
            case .success(let timesData):
                self.allTimes = timesData
                self.delegate?.timesDataReceived()
            case .failure(let error):
                self.delegate?.errorEventReceived(error: error.localizedDescription)
            }
        }
    }
    
    var getAllDatesData: [String] {
        return allDates
    }
    
    var getAllTimessData: [String] {
        return allTimes
    }
    
    func timeInputCalender(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return dateFormatter.string(from: date)
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }

    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
}

extension AddEventViewModel : AddEventViewModelProtocol {
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        if phoneNumber.count == 10 {
            return true
        }
        return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
