//
//  ClinicsListViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation


protocol ClinicsListViewModelProtocol {
    func getClinicsList()
   
    func getClinicsFilterData(searchText: String)
    
    func getClinicsDataAtIndex(index: Int)-> ClinicsListModel?
    func getClinicsFilterDataAtIndex(index: Int)-> ClinicsListModel?
    
    var  getClinicsListData: [ClinicsListModel] { get }
    var  getClinicsFilterListData: [ClinicsListModel] { get }
    
    func removeSelectedClinic(clinicId: Int)
}

class ClinicsListViewModel {
    var delegate: ClinicsListViewContollerProtocol?
    var allClinics: [Clinics]?
    var clinicList: [ClinicsListModel] = []
    var clinicListFilterData: [ClinicsListModel] = []

    
    init(delegate: ClinicsListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    func getClinicsList() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[ClinicsListModel], GrowthNetworkError>) in
            switch result {
            case .success(let clinicListData):
                self.clinicList = clinicListData
                self.delegate?.ClinicsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeSelectedClinic(clinicId: Int) {
        self.requestManager.request(forPath: ApiUrl.selectedClinic.appending("\(clinicId)"), method: .DELETE, headers: self.requestManager.Headers()) { (result: Result< PateintsTagRemove, GrowthNetworkError>) in
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.clinicRemovedSuccefully(message: data.success ?? String.blank)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension ClinicsListViewModel: ClinicsListViewModelProtocol {

    func getClinicsFilterData(searchText: String) {
        self.clinicListFilterData = (self.getClinicsListData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() || String($0.id ?? 0) == searchText })
    }
    
    func getClinicsDataAtIndex(index: Int)-> ClinicsListModel? {
        return self.getClinicsListData[index]
    }
    
    func getClinicsFilterDataAtIndex(index: Int)-> ClinicsListModel? {
        return self.clinicListFilterData[index]
    }
    
    var getClinicsListData: [ClinicsListModel] {
        return self.clinicList
    }
   
    var getClinicsFilterListData: [ClinicsListModel] {
         return self.clinicListFilterData
    }
}
