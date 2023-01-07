//
//  ClinicsListViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation


protocol ClinicsListViewModelProtocol {
    func getClinicsList()
    var  clinicsData: [ClinicsListModel] { get }
    func clinicsDataAtIndex(index: Int) -> ClinicsListModel?
    var  clinicsFilterDataData: [ClinicsListModel] { get }
    func clinicsFilterDataAtIndex(index: Int)-> ClinicsListModel?
}

class ClinicsListViewModel {
    var delegate: ClinicsListViewContollerProtocol?
    var clinicsListData: [ClinicsListModel] = []
    var clinicsFilterData: [ClinicsListModel] = []
    var allClinics: [Clinics]?
    
    init(delegate: ClinicsListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getClinicsList() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[ClinicsListModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.clinicsListData = userData
                self.delegate?.ClinicsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getallClinics(){
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allClinics):
                self.allClinics = allClinics
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func clinicsDataAtIndex(index: Int)-> ClinicsListModel? {
        return self.clinicsListData[index]
    }
    
    func clinicsFilterDataAtIndex(index: Int)-> ClinicsListModel? {
        return self.clinicsListData[index]
    }
}

extension ClinicsListViewModel: ClinicsListViewModelProtocol {
    
    var clinicsFilterDataData: [ClinicsListModel] {
        return self.clinicsFilterData
    }
    
    var clinicsData: [ClinicsListModel] {
        return self.clinicsListData
    }
}
