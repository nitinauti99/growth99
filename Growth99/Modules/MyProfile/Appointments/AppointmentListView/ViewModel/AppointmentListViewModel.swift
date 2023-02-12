//
//  AppointmentListViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 05/02/23.
//

import Foundation

protocol AppointmentViewModelProtocol {
    
    func getProfileApointmentsList()
    func getProfileFilterData(searchText: String)
    
    func getProfileDataAtIndex(index: Int)-> AppointmentListModel?
    func getProfileFilterDataAtIndex(index: Int)-> AppointmentListModel?
    
    var  getProfileAppoinmentListData: [AppointmentListModel] { get }
    var  getProfileAppoinmentFilterListData: [AppointmentListModel] { get }

    func removeProfileAppoinment(appoinmentId: Int)
    
    func serverToLocal(date: String) -> String
    func utcToLocal(timeString: String) -> String?
    func serverToLocalTime(timeString: String) -> String
    func serverToLocalCreatedDate(date: String) -> String
}

class AppointmentListViewModel {
    
    var delegate: AppointmentsViewContollerProtocol?
    var profileAppoinmentList: [AppointmentListModel] = []
    var profileAppoinmentListFilterData: [AppointmentListModel] = []
    
    init(delegate: AppointmentsViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getProfileApointmentsList() {
        let apiURL = ApiUrl.profileAppointments.appending("\(UserRepository.shared.userId ?? 0)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[AppointmentListModel], GrowthNetworkError>) in
            switch result {
            case .success(let profileAppoinments):
                self.profileAppoinmentList = profileAppoinments.sorted(by: { ($0.createdAt ?? "") > ($1.createdAt ?? "")})
                self.delegate?.profileAppointmentsReceived()
            case .failure(let error):
                self.delegate?.profileAppoinmentsErrorReceived(error: error.localizedDescription)
            }
        }
    }
    
    /*func removeProfileAppoinment(appoinmentId: Int) {
        let urlParameter: Parameters = [
            "userId": pateintId
        ]
        let finaleUrl = ApiUrl.removePatient + "userId=" + "\(pateintId)"
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: urlParameter, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.pateintRemovedSuccefully(mrssage: "Pateints removed successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
          }
    }*/
    
    func serverToLocal(date: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: date) ?? Date()
            dateFormatter.dateFormat = "MMM d yyyy"
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

extension AppointmentListViewModel: AppointmentViewModelProtocol {
    func removeProfileAppoinment(appoinmentId: Int) {
        
    }
    
    func getProfileFilterData(searchText: String) {
        self.profileAppoinmentListFilterData = (self.getProfileAppoinmentListData.filter { $0.patientFirstname?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
        
        print(self.profileAppoinmentListFilterData)
    }
    
    func getProfileDataAtIndex(index: Int)-> AppointmentListModel? {
        return self.getProfileAppoinmentListData[index]
    }
    
    func getProfileFilterDataAtIndex(index: Int)-> AppointmentListModel? {
        return self.profileAppoinmentListFilterData[index]
    }
   
    var getProfileAppoinmentFilterListData: [AppointmentListModel] {
         return self.profileAppoinmentListFilterData
    }

    var getProfileAppoinmentListData: [AppointmentListModel] {
        return self.profileAppoinmentList
    }
}
