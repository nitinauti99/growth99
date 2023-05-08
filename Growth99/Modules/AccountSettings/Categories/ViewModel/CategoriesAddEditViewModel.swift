//
//  CategoriesAddEditViewModel.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import Foundation

protocol CategoriesAddEditViewModelProtocol {
    func getallClinics()
    var  getAllClinicsData: [Clinics] { get }
    func createCategories(addCategoriesParams: [String: Any])
    func editCategories(addCategoriesParams: [String: Any], selectedCategorieId: Int)
    func getCategoriesInfo(categoryId: Int)
    var  getAllCategoriesData: ServiceDetailModel? { get }
    var  getAddCategoriesListData: [CategoriesListModel] { get }
    func getAddCategoriesList()
    func isFirstName(_ firstName: String) -> Bool
}

class CategoriesAddEditViewModel: CategoriesAddEditViewModelProtocol {
    var delegate: CategoriesAddViewContollerProtocol?
    var allClinics: [Clinics]?
    var serviceCategoryList: ServiceDetailModel?
    var addCategoriesResponse: CategoriesAddEditModel?
    var addCategoriesList: [CategoriesListModel] = []
    init(delegate: CategoriesAddViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getAddCategoriesList() {
        self.requestManager.request(forPath: ApiUrl.categoriesList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[CategoriesListModel], GrowthNetworkError>) in
            switch result {
            case .success(let categoriesListData):
                self.addCategoriesList = categoriesListData
                self.delegate?.addCategoriesDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getCategoriesInfo(categoryId: Int) {
        let finalURL = ApiUrl.createCategories + "/\(categoryId)"
        self.requestManager.request(forPath: finalURL, method: .GET, headers: self.requestManager.Headers()) { (result: Result<ServiceDetailModel, GrowthNetworkError>) in
            switch result {
            case .success(let allServiceCategoryList):
                self.serviceCategoryList = allServiceCategoryList
                self.delegate?.categoriesResponseReceived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    var getAllCategoriesData: ServiceDetailModel? {
        return self.serviceCategoryList
    }
    
    func getallClinics(){
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allClinics):
                self.allClinics = allClinics
                self.delegate?.clinicsRecived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func createCategories(addCategoriesParams: [String: Any]) {
        self.requestManager.request(forPath: ApiUrl.createCategories, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: addCategoriesParams, encoding: .jsonEncoding)) { (result: Result<CategoriesAddEditModel, GrowthNetworkError>) in
            switch result {
            case .success(let addResponse):
                self.addCategoriesResponse = addResponse
                self.delegate?.addCategoriesResponse()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    func editCategories(addCategoriesParams: [String: Any], selectedCategorieId: Int) {
        self.requestManager.request(forPath: ApiUrl.createCategories.appending("/\(selectedCategorieId)"), method: .PUT, headers: self.requestManager.Headers(), task: .requestParameters(parameters: addCategoriesParams, encoding: .jsonEncoding)) { (result: Result<CategoriesAddEditModel, GrowthNetworkError>) in
            switch result {
            case .success(let addResponse):
                self.addCategoriesResponse = addResponse
                self.delegate?.updatedCategoriesResponse()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    var getAllClinicsData: [Clinics] {
        return self.allClinics ?? []
    }
    
    var getAddCategoriesListData: [CategoriesListModel] {
        return self.addCategoriesList
    }
    
    func isFirstName(_ firstName: String) -> Bool {
        let regex = Constant.Regex.nameWithSpace
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: firstName)
    }
}
