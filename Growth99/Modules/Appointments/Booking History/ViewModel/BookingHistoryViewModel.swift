//
//  BookingHistoryViewModel.swift
//  Growth99
//
//  Created by Mahender Reddy on 31/01/23.
//

import Foundation

protocol BookingHistoryViewModelProtocol {
    
    func getCalenderInfoListBookingHistory(clinicId: Int, providerId: Int, serviceId: Int)
    
    func getBookingHistoryFilterData(searchText: String)
    
    func getBookingHistoryDataAtIndex(index: Int)-> AppointmentDTOList?
    func getBookingHistoryFilterDataAtIndex(index: Int)-> AppointmentDTOList?
    
    var  getBookingHistoryListData: [AppointmentDTOList] { get }
    var  getBookingHistoryFilterListData: [AppointmentDTOList] { get }
    
    func removeSelectedBookingHistory(bookingHistoryId: Int)

    func serverToLocalTime(timeString: String) -> String
}

class BookingHistoryViewModel {
    
    var delegate: BookingHistoryViewContollerProtocol?
    var bookingHistoryList: [AppointmentDTOList] = []
    var bookingHistoryListFilterData: [AppointmentDTOList] = []
    
    init(delegate: BookingHistoryViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))

    func getCalenderInfoListBookingHistory(clinicId: Int, providerId: Int, serviceId: Int) {
        let url = "\(clinicId)&providerId=\(providerId)&serviceId=\(serviceId)"
        let apiURL = ApiUrl.calenderInfo.appending("\(url)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<CalenderInfoListModel, GrowthNetworkError>) in
            switch result {
            case .success(let appointmentDTOListData):
                self.bookingHistoryList = appointmentDTOListData.appointmentDTOList ?? []
                self.delegate?.appointmentListDataRecivedBookingHistory()
            case .failure(let error):
                self.delegate?.errorReceivedBookingHistory(error: error.localizedDescription)
            }
        }
    }
    
    func removeSelectedBookingHistory(bookingHistoryId: Int) {
        let finaleUrl = ApiUrl.removeProfileAppointment + "\(bookingHistoryId)"
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.appointmentRemovedSuccefully()
                }else if (response.statusCode == 500) {
                    self.delegate?.profileAppoinmentsErrorReceived(error: "Unable to delete paid appointments")
                }else{
                    self.delegate?.profileAppoinmentsErrorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.profileAppoinmentsErrorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
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

extension BookingHistoryViewModel: BookingHistoryViewModelProtocol {

    func getBookingHistoryFilterData(searchText: String) {
        self.bookingHistoryListFilterData = (self.getBookingHistoryListData.filter { $0.patientFirstName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func getBookingHistoryDataAtIndex(index: Int)-> AppointmentDTOList? {
        return self.getBookingHistoryListData[index]
    }
    
    func getBookingHistoryFilterDataAtIndex(index: Int)-> AppointmentDTOList? {
        return self.bookingHistoryListFilterData[index]
    }
    
    var getBookingHistoryListData: [AppointmentDTOList] {
        return self.bookingHistoryList
    }
   
    var getBookingHistoryFilterListData: [AppointmentDTOList] {
         return self.bookingHistoryListFilterData
    }
}
