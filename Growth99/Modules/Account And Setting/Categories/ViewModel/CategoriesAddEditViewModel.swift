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

}

class CategoriesAddEditViewModel: CategoriesAddEditViewModelProtocol {
    var delegate: CategoriesAddViewContollerProtocol?
    var allClinics: [Clinics]?
    var addCategoriesResponse: CategoriesAddEditModel?
    
    init(delegate: CategoriesAddViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)

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
