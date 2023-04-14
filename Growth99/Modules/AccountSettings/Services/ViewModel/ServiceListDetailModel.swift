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
    
    func getAddServiceList()
    
    func getallQuestionnaires()
    var  getAllQuestionnairesData: [QuestionnaireListModel] { get }
    
    func getallServiceCategories(selectedClinics: [Int])
    var  getAllServiceCategoriesData: [Clinics] { get }
    
    func createServiceAPICall(name: String, serviceCategoryId: Int, durationInMinutes: Int,
                              serviceCost: Int, description: String, serviceURL: String,
                              consentIds: Array<Int>, questionnaireIds: Array<Int>,
                              clinicIds: Array<Int>, file: String, files: String,
                              preBookingCost: Int, imageRemoved: Bool, isPreBookingCostAllowed: Bool,
                              showInPublicBooking: Bool, priceVaries: Bool, httpMethod: HTTPMethod, isScreenFrom: String, serviceId: Int)
    func getUserSelectedService(serviceID: Int)
    var  getUserSelectedServiceData: ServiceDetailModel? { get }
    func uploadSelectedServiceImage(image: UIImage, selectedServiceId:Int)
    var  getAddServiceListData: [ServiceList] { get }
    func isFirstName(_ firstName: String) -> Bool
}

class ServiceListDetailModel: ServiceListDetailViewModelProtocol {

    var delegate: ServicesListDetailViewContollerProtocol?
    var allClinics: [Clinics]?
    var allConsent: [ConsentListModel]?
    var allQuestionnaires: [QuestionnaireListModel]?
    var allserviceCategories: [Clinics]?
    var serviceDetailListData: ServiceDetailModel?
    var apiURL: String = String.blank
    var serviceAddList: [ServiceList] = []

    init(delegate: ServicesListDetailViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func getAddServiceList() {
        self.requestManager.request(forPath: ApiUrl.getAllServices, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<ServiceListModel, GrowthNetworkError>) in
            switch result {
            case .success(let serviceData):
                self.serviceAddList = serviceData.serviceList ?? []
                self.delegate?.serviceAddListDataRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
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
    
    var  getAddServiceListData: [ServiceList] {
        return self.serviceAddList
    }

    func createServiceAPICall(name: String, serviceCategoryId: Int, durationInMinutes: Int,
                              serviceCost: Int, description: String, serviceURL: String,
                              consentIds: Array<Int>, questionnaireIds: Array<Int>,
                              clinicIds: Array<Int>, file: String, files: String,
                              preBookingCost: Int, imageRemoved: Bool, isPreBookingCostAllowed: Bool,
                              showInPublicBooking: Bool, priceVaries: Bool, httpMethod: HTTPMethod, isScreenFrom: String, serviceId: Int) {
        
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
        
        if isScreenFrom == Constant.Profile.createService {
            apiURL = ApiUrl.createService
        } else {
            apiURL = ApiUrl.editService + "\(serviceId)"
        }
        self.requestManager.request(forPath: apiURL, method: httpMethod, headers: self.requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.createServiceSucessfullyReceived(message: isScreenFrom)
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
    
    func uploadSelectedServiceImage(image: UIImage, selectedServiceId: Int) {
        UserRepository.shared.selectedServiceId = selectedServiceId
        self.requestManager.request(requestable: ServicesImage.upload(image: image.pngData() ?? Data())) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func isFirstName(_ firstName: String) -> Bool {
        let regex = Constant.Regex.nameWithNumbers
        let isFirstName = NSPredicate(format:"SELF MATCHES %@", regex)
        return isFirstName.evaluate(with: firstName)
    }
}


enum ServicesImage {
    case upload(image: Data)
}

extension ServicesImage: Requestable {
    
    var baseURL: String {
        EndPoints.baseURL
    }

    var headerFields: [HTTPHeader]? {
        [.custom(key: "x-tenantid", value: UserRepository.shared.Xtenantid ?? String.blank),
             .custom(key: "Content-Type", value: "application/json"),
             .authorization("Bearer "+(UserRepository.shared.authToken ?? String.blank))]
    }
    
    var requestMode: RequestMode {
        .noAuth
    }
    
    var path: String {
        "/api/services/".appending("\(UserRepository.shared.selectedServiceId ?? 0)/image")
    }
    
    var method: HTTPMethod {
        .POST
    }
    
    var task: RequestTask {
        switch self {
        case let .upload(data):
            let multipartFormData = [MultipartFormData(formDataType: .data(data), fieldName: "file", name: "", mimeType: "image/png")]
            return .multipartUpload(multipartFormData)
        }
    }
}

