//
//  ClinicsDetailListViewModel.swift
//  Growth99
//
//  Created by Sravan Goud on 14/02/23.
//

import Foundation

protocol ClinicsDetailListViewModelProtocol {
    func getselectedClinicDetail(clinicId: Int)
    func getTimeZonesList()
    var  getClinicsListData: ClinicsDetailListModel? { get }
    var  getTimeZonesListData: [String]? { get }
}

class ClinicsDetailListViewModel: ClinicsDetailListViewModelProtocol {
 
    var delegate: ClinicsDetailListVCProtocol?
    var clinicsDetailListData: ClinicsDetailListModel?
    var timeZonesList: [String]?
    var finaleUrl: String = ""

    init(delegate: ClinicsDetailListVCProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))

    func getselectedClinicDetail(clinicId: Int) {
        self.requestManager.request(forPath: ApiUrl.selectedClinic + "\(clinicId)", method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ClinicsDetailListModel, GrowthNetworkError>) in
            switch result {
            case .success(let selectedClinicInfo):
                self.clinicsDetailListData = selectedClinicInfo
                self.delegate?.clinicsDetailsDataReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

    func getTimeZonesList() {
        self.requestManager.request(forPath: ApiUrl.timezonesList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[String], GrowthNetworkError>) in
            switch result {
            case .success(let timeZonesData):
                self.timeZonesList = timeZonesData
                self.delegate?.timeZoneListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    
    
    
    func updateUserSelectedClinic(clinicId: Int , urlMethod: HTTPMethod, screenTitle: String) {
        if screenTitle == Constant.Profile.editClinic {
            finaleUrl = ApiUrl.selectedClinic + "\(clinicId)"
        } else {
            finaleUrl = ApiUrl.allClinics
        }
        self.requestManager.request(forPath: finaleUrl, method: urlMethod, headers: self.requestManager.Headers()) {  (result: Result<ClinicsDetailListModel, GrowthNetworkError>) in
            switch result {
            case .success(_):
                self.delegate?.clinicUpdateReceived(responeMessage: screenTitle)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getClinicsListData: ClinicsDetailListModel? {
        return self.clinicsDetailListData
    }
    
    var getTimeZonesListData: [String]? {
        return self.timeZonesList
    }
}
