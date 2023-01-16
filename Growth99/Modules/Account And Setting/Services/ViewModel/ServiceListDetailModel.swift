//
//  ServiceListDetailModel.swift
//  Growth99
//
//  Created by Exaze Technologies on 13/01/23.
//

import Foundation


protocol ServiceListDetailViewModelProtocol {
    func getallClinics()
    var  getAllClinicsData: [Clinics] { get }
    
    func getallConsents()
    var  getAllConsentsData: [ConsentListModel] { get }
    
    func getallQuestionnaires()
    var  getAllQuestionnairesData: [QuestionnaireListModel] { get }
    
    func getallServiceCategories(selectedClinics: [Int])
    var getAllServiceCategoriesData: [Clinics] { get }
    
}

class ServiceListDetailModel: ServiceListDetailViewModelProtocol {
    var delegate: ServicesListDetailViewContollerProtocol?
    var allClinics: [Clinics]?
    var allConsent: [ConsentListModel]?
    var allQuestionnaires: [QuestionnaireListModel]?
    var allserviceCategories: [Clinics]?
    
    init(delegate: ServicesListDetailViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getallClinics() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let clinicsData):
                self.allClinics = clinicsData
                self.delegate?.clinicsReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getAllClinicsData: [Clinics] {
        return self.allClinics ?? []
    }
    
    func getallConsents() {
        self.requestManager.request(forPath: ApiUrl.consentList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[ConsentListModel], GrowthNetworkError>) in
            switch result {
            case .success(let consentData):
                self.allConsent = consentData
                self.delegate?.consentReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getAllConsentsData: [ConsentListModel] {
        return self.allConsent ?? []
    }
    
    func getallQuestionnaires() {
        self.requestManager.request(forPath: ApiUrl.questionnaireList, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[QuestionnaireListModel], GrowthNetworkError>) in
            switch result {
            case .success(let questionnairesData):
                self.allQuestionnaires = questionnairesData
                self.delegate?.questionnairesReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getAllQuestionnairesData: [QuestionnaireListModel] {
        return self.allQuestionnaires ?? []
    }
    
    func getallServiceCategories(selectedClinics: [Int]){
        let finaleUrl = ApiUrl.serviceCategories + selectedClinics.map { String($0) }.joined(separator: ",")
        self.requestManager.request(forPath: finaleUrl, method: .GET,headers: self.requestManager.Headers()) { (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let allserviceCategories):
                self.allserviceCategories = allserviceCategories
                self.delegate?.serviceCategoriesReceived()
            case .failure(let error):
                print(error)
                self.delegate?.errorReceived(error: error.localizedDescription)
            }
        }
    }
    
    var getAllServiceCategoriesData: [Clinics] {
        return self.allserviceCategories ?? []
    }
    
}
