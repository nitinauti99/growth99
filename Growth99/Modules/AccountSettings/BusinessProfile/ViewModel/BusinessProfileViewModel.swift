//
//  BusinessProfileViewModel.swift
//  Growth99
//
//  Created by nitin auti on 17/01/23.
//

import Foundation
protocol BusinessProfileViewModelProtocol {
    func saveBusinessInfo(name: String, trainingBusiness: Bool)
    func uploadSelectedImage(image: UIImage)
    func validateName(_ firstName: String) -> Bool
}

class BusinessProfileViewModel {
    var delegate: BusinessProfileViewControllerProtocol?
    var serviceListData: [ServiceList] = []
    var serviceFilterData: [ServiceList] = []
    let user = UserRepository.shared
    
    init(delegate: BusinessProfileViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    func saveBusinessInfo(name: String, trainingBusiness: Bool) {
        let finaleUrl = ApiUrl.bussinessInfo + "\(UserRepository.shared.Xtenantid ?? String.blank)"
        let parameter: [String : Any] = ["name": name, "trainingBusiness": trainingBusiness]
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { [weak self] (result: Result<BusinessResponseModel, GrowthNetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response): 
                self.delegate?.businessInformationReponse(isImageUpload: false, responseMessage: "Business updated successfully!", businessName: response.name ?? String.blank, businessLogoUrl: response.logoUrl ?? String.blank)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func uploadSelectedImage(image: UIImage) {
        self.requestManager.request(requestable: BusinessImage.upload(image: image.pngData() ?? Data())) { [weak self] (result: Result<BusinessResponseModel, GrowthNetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.delegate?.businessInformationReponse(isImageUpload: true, responseMessage: "", businessName: response.name ?? String.blank, businessLogoUrl: response.logoUrl ?? String.blank)
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func validateName(_ firstName: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z]+$")
        let range = NSRange(location: 0, length: firstName.utf16.count)
        let matches = regex.matches(in: firstName, range: range)
        return !matches.isEmpty
    }
}

extension BusinessProfileViewModel: BusinessProfileViewModelProtocol { }

enum BusinessImage {
    case upload(image: Data)
}

extension BusinessImage: Requestable {
    
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
        "/api/businesses/\(UserRepository.shared.Xtenantid ?? "")/logo"
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
