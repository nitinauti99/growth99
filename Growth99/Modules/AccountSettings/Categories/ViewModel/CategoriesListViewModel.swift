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
    
    func getCategoriesDataAtIndex(index: Int)-> ServiceCategoryList?
    func getCategoriesFilterDataAtIndex(index: Int)-> ServiceCategoryList?
    
    var  getCategoriesListData: [ServiceCategoryList] { get }
    var  getCategoriesFilterListData: [ServiceCategoryList] { get }
    func removeSelectedCategorie(categorieId: Int)
    func deleteSelectedCategorie(categorieId: Int)
}

class CategoriesListViewModel {
    var delegate: CategoriesListViewContollerProtocol?
    var allClinics: [Clinics]?
    
    var categoriesList: [ServiceCategoryList] = []
    var categoriesListFilterData: [ServiceCategoryList] = []
    
    
    init(delegate: CategoriesListViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getCategoriesList() {
        self.requestManager.request(forPath: ApiUrl.categoriesList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<CategoriesListModel, GrowthNetworkError>) in
            switch result {
            case .success(let categoriesListData):
                self.categoriesList = categoriesListData.serviceCategoryList.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)})
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
        let finaleUrl = ApiUrl.deleteCheckCategories.appending("\(categorieId)")
        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[CategeroryDeleteModel], GrowthNetworkError>) in
            switch result {
            case .success(let response):
                if response.isEmpty {
                    self.delegate?.categoriesRemovedSuccefully(categorySelectedId: categorieId)
                } else if (response.count > 0) {
                    self.delegate?.errorReceived(error: "This category may be deleted only after removing all services under it")
                } else {
                    self.delegate?.errorReceived(error: "Unexpected response")
                }
            case .failure(let error):
                // Log the actual error received from the server
                print("Error received from server: \(error)")
                
                // Pass the error message to the delegate
                self.delegate?.errorReceived(error: "An error occurred while processing your request.")
            }
        }
    }

    
    func deleteSelectedCategorie(categorieId: Int) {
        let finaleUrl = ApiUrl.deleteCategories.appending("\(categorieId)")
        self.requestManager.request(forPath: finaleUrl, method: .DELETE, headers: self.requestManager.Headers()) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.selecetedCategoriesRemovedSuccefully(message: "Category deleted successfully")
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
    
    func getCategoriesDataAtIndex(index: Int)-> ServiceCategoryList? {
        return self.getCategoriesListData[index]
    }
    
    func getCategoriesFilterDataAtIndex(index: Int)-> ServiceCategoryList? {
        return self.categoriesListFilterData[index]
    }
    
    var getCategoriesListData: [ServiceCategoryList] {
        return self.categoriesList
    }
    
    var getCategoriesFilterListData: [ServiceCategoryList] {
        return self.categoriesListFilterData
    }
}
