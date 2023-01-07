//
//  CategoriesListViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

protocol CategoriesListViewModelProtocol {
    func getCategoriesList()
    var  categoriesData: [CategoriesListModel] { get }
    func categoriesDataAtIndex(index: Int) -> CategoriesListModel?
    var  categoriesFilterDataData: [CategoriesListModel] { get }
    func categoriesFilterDataAtIndex(index: Int)-> CategoriesListModel?
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
    
    func getCategoriesList() {
        self.requestManager.request(forPath: ApiUrl.categoriesList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[CategoriesListModel], GrowthNetworkError>) in
            switch result {
            case .success(let userData):
                self.categoriesListData = userData
                self.delegate?.CategoriesDataRecived()
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
    
    func categoriesDataAtIndex(index: Int)-> CategoriesListModel? {
        return self.categoriesListData[index]
    }
    
    func categoriesFilterDataAtIndex(index: Int)-> CategoriesListModel? {
        return self.categoriesListData[index]
    }
}

extension CategoriesListViewModel: CategoriesListViewModelProtocol {
    
    var categoriesFilterDataData: [CategoriesListModel] {
        return self.categoriesFilterData
    }
    
    var categoriesData: [CategoriesListModel] {
        return self.categoriesListData
    }
}
