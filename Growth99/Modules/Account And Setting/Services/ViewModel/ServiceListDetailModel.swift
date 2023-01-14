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
}

class ServiceListDetailModel: ServiceListDetailViewModelProtocol {
    var delegate: ServicesListDetailViewContollerProtocol?
    var allClinics: [Clinics]?
    
    init(delegate: ServicesListDetailViewContollerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getallClinics() {
        self.requestManager.request(forPath: ApiUrl.allClinics, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<[Clinics], GrowthNetworkError>) in
            switch result {
            case .success(let clinicsData):
                self.allClinics = clinicsData
                self.delegate?.clinicsRecived()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    var getAllClinicsData: [Clinics] {
        return self.allClinics ?? []
    }
}
