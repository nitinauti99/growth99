//
//  CategoriesListViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

protocol CategoriesListViewModelProtocol {
    func getUserList()
    var  userData: [CategoriesListModel] { get }
    func userDataAtIndex(index: Int) -> CategoriesListModel?
    var  userFilterDataData: [CategoriesListModel] { get }
    func userFilterDataDataAtIndex(index: Int)-> CategoriesListModel?
}

class CategoriesListViewModel {
    var delegate: CategoriesListViewContollerProtocol?
    var categoriesListData: [CategoriesListModel] = []
    var categoriesFilterData: [CategoriesListModel] = []
    var allClinics: [Clinics]?

    init(delegate: CategoriesListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getUserList() {
        self.requestManager.request(forPath: ApiUrl.categoriesList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[CategoriesListModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.categoriesListData = userData
                self.delegate?.LeadDataRecived()
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
    
    func userDataAtIndex(index: Int)-> CategoriesListModel? {
        return self.categoriesListData[index]
    }
    
    func userFilterDataDataAtIndex(index: Int)-> CategoriesListModel? {
        return self.categoriesListData[index]
    }
}

extension CategoriesListViewModel: CategoriesListViewModelProtocol {
    
    var userFilterDataData: [CategoriesListModel] {
        return self.categoriesFilterData
    }
    
    var userData: [CategoriesListModel] {
        return self.categoriesListData
    }
}
