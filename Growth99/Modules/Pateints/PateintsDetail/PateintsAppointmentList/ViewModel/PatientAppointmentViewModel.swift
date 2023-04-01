//
//  PatientAppointmentViewModel.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import Foundation

protocol PatientAppointmentViewModelProtocol {
    func getPatientAppointmentList(pateintId: Int)
    func getPatientAppointmentsForAppointment(pateintId: Int)
    func patientListAtIndex(index: Int) -> PatientsAppointmentListModel?
    func patientListFilterListAtIndex(index: Int)-> PatientsAppointmentListModel?
    func filterData(searchText: String)
    var  getPatientsAppointmentList: [PatientsAppointmentListModel] { get }
    var  getPatientsAppointmentFilterList: [PatientsAppointmentListModel] { get }
    var  getPatientsForAppointments: AppointmentDTOList? { get }
}

class PatientAppointmentViewModel {
    var delegate: PatientAppointmentViewControllerProtocol?
    
    var patientsAppointmentList: [PatientsAppointmentListModel] = []
    var patientsAppointmentFilterList: [PatientsAppointmentListModel] = []
    var patientsModel : AppointmentDTOList?
    
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    
    init(delegate: PatientAppointmentViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
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
    
    func getPatientAppointmentsForAppointment(pateintId: Int) {
        let finaleUrl = ApiUrl.PatientAppointmenList + "\(pateintId)"
        
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) { (result: Result< AppointmentDTOList, GrowthNetworkError>) in
            switch result {
            case .success(let PateintsAppointmentList):
                self.patientsModel = PateintsAppointmentList
                self.delegate?.patientAppointmentDataRecived()
            case .failure(let error):
                self.delegate?.errorReceivedBookingHistory(error: error.localizedDescription)
            }
        }
    }
    
    func filterData(searchText: String) {
        self.patientsAppointmentFilterList = (self.patientsAppointmentList.filter { $0.patientName?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() || String($0.id ?? 0) == searchText })
    }
    
    func patientListAtIndex(index: Int) -> PatientsAppointmentListModel? {
        return self.patientsAppointmentList[index]
    }
    
    func patientListFilterListAtIndex(index: Int) -> PatientsAppointmentListModel? {
        return self.patientsAppointmentFilterList[index]
    }
}

extension PatientAppointmentViewModel : PatientAppointmentViewModelProtocol {
    
    var getPatientsAppointmentList : [PatientsAppointmentListModel] {
        return self.patientsAppointmentList
    }
    
    var getPatientsAppointmentFilterList: [PatientsAppointmentListModel] {
        return self.patientsAppointmentFilterList
    }
    
    var getPatientsForAppointments : AppointmentDTOList? {
        return self.patientsModel
    }
    
}
