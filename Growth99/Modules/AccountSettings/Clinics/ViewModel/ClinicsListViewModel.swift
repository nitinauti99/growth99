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
                self.clinicList = clinicListData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
                self.delegate?.ClinicsDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func removeSelectedClinic(clinicId: Int) {
        let finaleUrl = ApiUrl.selectedClinic.appending("\(clinicId)")
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_ ):
                self.delegate?.clinicRemovedSuccefully(message: "Clinic removed successfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
}

extension ClinicsListViewModel: ClinicsListViewModelProtocol {

    func getClinicsFilterData(searchText: String) {
        self.clinicListFilterData = self.getClinicsListData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
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
