//
//  PateintEditViewModel.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.
//

import Foundation

protocol PateintEditViewModelProtocol {
    func getPateintList(pateintId: Int) 
    func updatePateintsDetail(patientsId: Int, parameters: [String:Any])
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool
    func isValidEmail(_ email: String) -> Bool
    func isValid(testStr:String) -> Bool
    var getPateintEditData: PateintsEditDetailModel? { get }
}

class PateintEditViewModel {
    var delegate: PateintEditViewControllerProtocol?
    var pateintsDetailList: PateintsEditDetailModel?

    init(delegate: PateintEditViewControllerProtocol? = nil) {
        self.delegate = delegate
    }
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))
    
    func getPateintList(pateintId: Int) {
        let finaleUrl = ApiUrl.patientsEditDetail + "\(pateintId)"

        self.requestManager.request(forPath: finaleUrl, method: .GET, headers: self.requestManager.Headers()) {  (result: Result<PateintsEditDetailModel, GrowthNetworkError>) in
            switch result {
            case .success(let pateintList):
                self.pateintsDetailList = pateintList
                self.delegate?.recivedPateintDetail()
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
    
    func updatePateintsDetail(patientsId: Int, parameters: [String:Any]) {
        let finaleUrl = ApiUrl.crearePatients.appending("/\(patientsId)")
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: self.requestManager.Headers(),task: .requestParameters(parameters: parameters, encoding: .jsonEncoding)) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                print(data)
                self.delegate?.pateintCreatedSuccessfully(responseMessage: "Pateint created succefully")
            case .failure(let error):
                self.delegate?.errorReceived(error: error.localizedDescription)
                print("Error while performing request \(error)")
            }
        }
    }
}

extension PateintEditViewModel: PateintEditViewModelProtocol{
   
    var getPateintEditData: PateintsEditDetailModel? {
        return self.pateintsDetailList
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        guard phoneNumber.count > 10, phoneNumber.count < 10, !phoneNumber.isEmpty else {
            return false
        }
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^[1-9][0-9]{9}$")
        return predicateTest.evaluate(with: phoneNumber)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValid(testStr:String) -> Bool {
        guard testStr.count > 1, !testStr.isEmpty else {
            return false
        }
       let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z]*$")
        return predicateTest.evaluate(with: testStr)
    }
}

