//
//  SubdomainViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 15/02/23.
//

import UIKit

class SubdomainViewController: UIViewController {

    @IBOutlet private weak var subDomainNameTextField: CustomTextField!
    var bussinessInfoData: BusinessSubDomainModel?
    
    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default)
    let user = UserRepository.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        subDomainNameTextField.text = bussinessInfoData?.subDomainName
    }
    
    @IBAction func savebtnTapped(_ sender: Any) {
        guard let name = subDomainNameTextField.text, !name.isEmpty else {
            subDomainNameTextField.showError(message: Constant.ErrorMessage.subDomainNameEmptyError)
            return
        }
        self.view.ShowSpinner()
        saveSubDomainInfo(subdomainName: name)
    }
    
    func saveSubDomainInfo(subdomainName: String) {
        let parameter: [String : Any] = ["subDomainName": subdomainName]
        let finaleUrl = ApiUrl.bussinessInfo + "\(bussinessInfoData?.id ?? 0)/subdomain"
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<BusinessSubDomainModel, GrowthNetworkError>) in
            switch result {
            case .success(let response):
                self.view?.HideSpinner()
                self.user.subDomainName = response.subDomainName
                self.view?.showToast(message: "Information updated sucessfully.", color: .black)
            case .failure(let error):
                self.view?.HideSpinner()
                self.view?.showToast(message: error.localizedDescription, color: .black)
            }
        }
    }
}
