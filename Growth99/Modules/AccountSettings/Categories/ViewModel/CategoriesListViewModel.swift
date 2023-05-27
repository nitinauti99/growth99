//
//  CategoriesListViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

protocol CategoriesListViewModelProtocol {
    func getCategoriesList()
    
    func getCategoriesFilterData(searchText: String)
    
    func getCategoriesDataAtIndex(index: Int)-> CategoriesListModel?
    func getCategoriesFilterDataAtIndex(index: Int)-> CategoriesListModel?
    
    var  getCategoriesListData: [CategoriesListModel] { get }
    var  getCategoriesFilterListData: [CategoriesListModel] { get }
    func removeSelectedCategorie(categorieId: Int)
}

class CategoriesListViewModel {
    var delegate: CategoriesListViewContollerProtocol?
    var allClinics: [Clinics]?
    
    var categoriesList: [CategoriesListModel] = []
    var categoriesListFilterData: [CategoriesListModel] = []
    
    
    init(delegate: CategoriesListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getCategoriesList() {
        self.requestManager.request(forPath: ApiUrl.categoriesList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[CategoriesListModel], GrowthNetworkError>) in
            switch result {
            case .success(let categoriesListData):
                self.categoriesList = categoriesListData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
                self.delegate?.CategoriesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getallClinics() {
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
    
    func removeSelectedCategorie(categorieId: Int) {
        let finaleUrl = ApiUrl.deleteCategories.appending("\(categorieId)")
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.categoriesRemovedSuccefully(message: "Category deleted successfully")
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "This category may be deleted only after removing all services under it")
                } else {
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension CategoriesListViewModel: CategoriesListViewModelProtocol {
    
    func getCategoriesFilterData(searchText: String) {
        self.categoriesListFilterData = self.getCategoriesListData.filter { task in
            let searchText = searchText.lowercased()
            let nameMatch = task.name?.lowercased().prefix(searchText.count).elementsEqual(searchText) ?? false
            let idMatch = String(task.id ?? 0).prefix(searchText.count).elementsEqual(searchText)
            return nameMatch || idMatch
        }
    }
    
    func getCategoriesDataAtIndex(index: Int)-> CategoriesListModel? {
        return self.getCategoriesListData[index]
    }
    
    func getCategoriesFilterDataAtIndex(index: Int)-> CategoriesListModel? {
        return self.categoriesListFilterData[index]
    }
    
    var getCategoriesListData: [CategoriesListModel] {
        return self.categoriesList
    }
    
    var getCategoriesFilterListData: [CategoriesListModel] {
        return self.categoriesListFilterData
    }
}
