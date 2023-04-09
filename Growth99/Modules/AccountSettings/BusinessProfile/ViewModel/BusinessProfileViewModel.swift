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
        let parameter: [String : Any] = ["name": name,
                                         "trainingBusiness": trainingBusiness
        ]
        
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<BusinessModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.user.bussinessName = response.name
                self.delegate?.saveBusinessDetailReceived(responseMessage: "Information updated sucessfully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func uploadSelectedImage(image: UIImage) {
        
        self.requestManager.request(requestable: BusinessImage.upload(image: image.pngData() ?? Data())) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    self.delegate?.saveBusinessDetailReceived(responseMessage: "Information updated sucessfully")
                } else {
                    self.delegate?.saveBusinessDetailReceived(responseMessage: "response failed")
                }
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
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
