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
    func updateUserSelectedClinic(clinicParms: [String: Any], clinicId: Int , urlMethod: HTTPMethod, screenTitle: String)
    func isValidEmail(_ email: String) -> Bool
    func validateName(_ firstName: String) -> Bool
}

class ClinicsDetailListViewModel: ClinicsDetailListViewModelProtocol {
 
    var delegate: ClinicsDetailListVCProtocol?
    var clinicsDetailListData: ClinicsDetailListModel?
    var timeZonesList: [String]?
    var finaleUrl: String = ""

    init(delegate: ClinicsDetailListVCProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)

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
    
    func updateUserSelectedClinic(clinicParms: [String: Any], clinicId: Int , urlMethod: HTTPMethod, screenTitle: String) {
        if screenTitle == Constant.Profile.editClinic {
            finaleUrl = ApiUrl.selectedClinic + "\(clinicId)"
        } else {
            finaleUrl = ApiUrl.creatClinic
        }
        self.requestManager.request(forPath: finaleUrl, method: urlMethod, headers: self.requestManager.Headers(), task: .requestParameters(parameters: clinicParms, encoding: .jsonEncoding)) {  (result: Result<ClinicsDetailListModel, GrowthNetworkError>) in
            switch result {
            case .success(let detailData):
                self.delegate?.clinicUpdateReceived(responeMessage: screenTitle)
                UserRepository.shared.timeZone = detailData.timezone
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func validateName(_ firstName: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z]+$")
        let range = NSRange(location: 0, length: firstName.utf16.count)
        let matches = regex.matches(in: firstName, range: range)
        return !matches.isEmpty
    }
}
