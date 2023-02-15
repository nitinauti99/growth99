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
    var  getAllServiceCategoriesData: [Clinics] { get }
    
    func createServiceAPICall(name: String, serviceCategoryId: Int, durationInMinutes: Int,
                              serviceCost: Int, description: String, serviceURL: String,
                              consentIds: Array<Int>, questionnaireIds: Array<Int>,
                              clinicIds: Array<Int>, file: String, files: String,
                              preBookingCost: Int, imageRemoved: Bool, isPreBookingCostAllowed: Bool,
                              showInPublicBooking: Bool, priceVaries: Bool)
    func getUserSelectedService(serviceID: Int)
    var  getUserSelectedServiceData: ServiceDetailModel? { get }

}

class ServiceListDetailModel: ServiceListDetailViewModelProtocol {

    var delegate: ServicesListDetailViewContollerProtocol?
    var allClinics: [Clinics]?
    var allConsent: [ConsentListModel]?
    var allQuestionnaires: [QuestionnaireListModel]?
    var allserviceCategories: [Clinics]?
    var serviceDetailListData: ServiceDetailModel?

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

    func createServiceAPICall(name: String, serviceCategoryId: Int, durationInMinutes: Int,
                              serviceCost: Int, description: String, serviceURL: String,
                              consentIds: Array<Int>, questionnaireIds: Array<Int>,
                              clinicIds: Array<Int>, file: String, files: String,
                              preBookingCost: Int, imageRemoved: Bool, isPreBookingCostAllowed: Bool,
                              showInPublicBooking: Bool, priceVaries: Bool) {
        
        let parameter: [String : Any] = ["name": name,
                                         "serviceCategoryId": serviceCategoryId,
                                         "durationInMinutes": durationInMinutes,
                                         "serviceCost": serviceCost,
                                         "description": description,
                                         "serviceURL": serviceURL,
                                         "consentIds": consentIds,
                                         "questionnaireIds": questionnaireIds,
                                         "clinicIds": clinicIds,
                                         "file": file,
                                         "files": files,
                                         "preBookingCost": preBookingCost,
                                         "imageRemoved": imageRemoved,
                                         "isPreBookingCostAllowed": isPreBookingCostAllowed,
                                         "showInPublicBooking": showInPublicBooking,
                                         "priceVaries": priceVaries
        ]
        
        let finaleUrl = ApiUrl.createService
        self.requestManager.request(forPath: finaleUrl, method: .POST, headers: self.requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.createServiceSucessfullyReceived()
                } else if (response.statusCode == 500) {
                    self.delegate?.errorReceived(error: "We are facing issue while creating service")
                } else {
                    self.delegate?.errorReceived(error: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func getUserSelectedService(serviceID: Int) {
        self.requestManager.request(forPath: ApiUrl.editService + "\(serviceID)", method: .GET, headers: self.requestManager.Headers()) { (result: Result<ServiceDetailModel, GrowthNetworkError>) in
            switch result {
            case .success(let selectedServiceInfo):
                self.serviceDetailListData = selectedServiceInfo
                self.delegate?.selectedServiceDataReceived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getUserSelectedServiceData: ServiceDetailModel? {
        return self.serviceDetailListData
    }
}
