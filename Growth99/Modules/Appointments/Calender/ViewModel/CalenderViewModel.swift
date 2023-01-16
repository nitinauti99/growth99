//
//  CalenderViewModel.swift
//  Growth99
//
//  Created by Exaze Technologies on 16/01/23.
//

import Foundation

protocol CalenderViewModelProtocol {
    func getallClinics()
    var getAllClinicsData: [Clinics] { get }
    
    func getServiceList()
    var serviceData: [ServiceList] { get }
    
    func sendProviderList(providerParams: Int)
    var providerData: [UserDTOList] { get }
    
    func getCalenderInfoList(clinicId: Int, providerId: Int, serviceId: Int)
    var appointmentInfoListData: [AppointmentDTOList] { get }
}


class CalenderViewModel: CalenderViewModelProtocol {
    
    var delegate: CalenderViewContollerProtocol?
    var allClinics: [Clinics]?
    var serviceListData: [ServiceList] = []
    var providerListData: [UserDTOList] = []
    var appoinmentListData: [AppointmentDTOList] = []
    
    init(delegate: CalenderViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    
    func getallClinics() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allClinics):
                self.allClinics = allClinics
                self.delegate?.clinicsReceived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    var getAllClinicsData: [Clinics] {
        return self.allClinics ?? []
    }
    
    func getServiceList() {
        self.requestManager.request(forPath: ApiUrl.getAllServices, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ServiceListModel, GrowthNetworkError>) in
            switch result {
            case .success(let serviceData):
                self.serviceListData = serviceData.serviceList ?? []
                self.delegate?.serviceListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var serviceData: [ServiceList] {
        return self.serviceListData
    }
    
    func sendProviderList(providerParams: Int) {
        let apiURL = ApiUrl.providerList.appending("\(providerParams)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<ProviderListModel, GrowthNetworkError>) in
            switch result {
            case .success(let providerData):
                self.providerListData = providerData.userDTOList ?? []
                self.delegate?.providerListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    var providerData: [UserDTOList] {
        return self.providerListData
    }
    
    func getCalenderInfoList(clinicId: Int, providerId: Int, serviceId: Int) {
        let url = "\(clinicId)&providerId=\(providerId)&serviceId=\(serviceId)"
        let apiURL = ApiUrl.calenderInfo.appending("\(url)")
        self.requestManager.request(forPath: apiURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<CalenderInfoListModel, GrowthNetworkError>) in
            switch result {
            case .success(let appointmentDTOListData):
                self.appoinmentListData = appointmentDTOListData.appointmentDTOList ?? []
                self.delegate?.appointmentListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    var appointmentInfoListData: [AppointmentDTOList] {
        return self.appoinmentListData
    }
    
}
