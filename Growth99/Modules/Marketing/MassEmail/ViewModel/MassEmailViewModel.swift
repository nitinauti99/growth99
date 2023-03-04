//
//  MassEmailViewModel.swift
//  Growth99
//
//  Created by Mahender Reddy on 31/01/23.
//

import Foundation

protocol MassEmailViewModelProtocol {
    
    func getCalenderInfoListMassEmail(clinicId: Int, providerId: Int, serviceId: Int)
    
    func getMassEmailFilterData(searchText: String)
    
    func getMassEmailDataAtIndex(index: Int)-> MassEmailSMSModel?
    func getMassEmailFilterDataAtIndex(index: Int)-> MassEmailSMSModel?
    
    var  getMassEmailListData: [MassEmailSMSModel] { get }
    var  getMassEmailFilterListData: [MassEmailSMSModel] { get }
    
    func removeSelectedMassEmail(MassEmailId: Int)

    func serverToLocalTime(timeString: String) -> String
}

class MassEmailViewModel {
    
    var delegate: MassEmailViewContollerProtocol?
    var massEmailList: [MassEmailSMSModel] = []
    var massEmailListFilterData: [MassEmailSMSModel] = []
    
    init(delegate: MassEmailViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))

    func getCalenderInfoListMassEmail(clinicId: Int, providerId: Int, serviceId: Int) {
        let url = "\(clinicId)&providerId=\(providerId)&serviceId=\(serviceId)"
        let apiURL = ApiUrl.calenderInfo.appending("\(url)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<MassEmailSMSModel, GrowthNetworkError>) in
            switch result {
            case .success(let massEmailSMSListData):
                self.massEmailList = massEmailSMSListData ?? []
                self.delegate?.appointmentListDataRecivedMassEmail()
            case .failure(let error):
                self.delegate?.errorReceivedMassEmail(error: error.localizedDescription)
            }
        }
    }
    
    func removeSelectedMassEmail(MassEmailId: Int) {
        /*let finaleUrl = ApiUrl.removeProfileAppointment + "\(MassEmailId)"
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.profileAppoinmentsRemoved()
                }else if (response.statusCode == 500) {
                    self.delegate?.profileAppoinmentsErrorReceived(error: "Unable to delete paid appointments")
                }else{
                    self.delegate?.profileAppoinmentsErrorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.profileAppoinmentsErrorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }*/
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

extension MassEmailViewModel: MassEmailViewModelProtocol {

    func getMassEmailFilterData(searchText: String) {
        self.massEmailListFilterData = (self.getMassEmailListData.filter { $0.patientFirstName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })
    }
    
    func getMassEmailDataAtIndex(index: Int)-> MassEmailSMSModel? {
        return self.getMassEmailListData[index]
    }
    
    func getMassEmailFilterDataAtIndex(index: Int)-> MassEmailSMSModel? {
        return self.massEmailListFilterData[index]
    }
    
    var getMassEmailListData: [MassEmailSMSModel] {
        return self.massEmailList
    }
   
    var getMassEmailFilterListData: [MassEmailSMSModel] {
         return self.massEmailListFilterData
    }
}
