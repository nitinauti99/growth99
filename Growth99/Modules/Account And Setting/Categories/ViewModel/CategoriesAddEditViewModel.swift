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
    func editCategories(selectedCategorieId: Int)
    func getCategoriesInfo(categoryId: Int)
    var  getAllCategoriesData: ServiceDetailModel? { get }
}

class CategoriesAddEditViewModel: CategoriesAddEditViewModelProtocol {
    var delegate: CategoriesAddViewContollerProtocol?
    var allClinics: [Clinics]?
    var serviceCategoryList: ServiceDetailModel?
    var addCategoriesResponse: CategoriesAddEditModel?
    
    init(delegate: CategoriesAddViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)

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
    
    func editCategories(selectedCategorieId: Int) {
        self.requestManager.request(forPath: ApiUrl.createCategories.appending("/\(selectedCategorieId)"), method: .GET, headers: self.requestManager.Headers()) { (result: Result<CategoriesAddEditModel, GrowthNetworkError>) in
            switch result {
            case .success(let addResponse):
                self.addCategoriesResponse = addResponse
//                self.delegate?.editCategoriesResponse()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    var getAllClinicsData: [Clinics] {
        return self.allClinics ?? []
    }
}
