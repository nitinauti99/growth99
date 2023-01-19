//
//  BusinessProfileViewModel.swift
//  Growth99
//
//  Created by nitin auti on 17/01/23.
//

import Foundation
protocol BusinessProfileViewModelProtocol {
    func saveBusinessInfo(name: String, trainingBusiness: Bool) 
}

class BusinessProfileViewModel {
    var delegate: BusinessProfileViewControllerProtocol?
    var serviceListData: [ServiceList] = []
    var serviceFilterData: [ServiceList] = []
    let user = UserRepository.shared

    init(delegate: BusinessProfileViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func saveBusinessInfo(name: String, trainingBusiness: Bool) {
        let finaleUrl = ApiUrl.bussinessInfo + "\(UserRepository.shared.Xtenantid ?? "")"
        let parameter: [String : Any] = ["name": name,
                                         "trainingBusiness": trainingBusiness
                                         ]
        
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<BusinessModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                print(response)
                self.user.bussinessName = response.name
                self.delegate?.saveBusinessDetailReceived(responseMessage: "saved bussiness info")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }

}

extension BusinessProfileViewModel: BusinessProfileViewModelProtocol { }
