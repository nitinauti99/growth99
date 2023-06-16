//
//  SubdomainViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 15/02/23.
//

import UIKit

class SubdomainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet private weak var subDomainNameTextField: CustomTextField!
    var bussinessInfoData: BusinessSubDomainModel?
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
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
                self.view?.showToast(message: "Information updated successfully", color: UIColor().successMessageColor())
            case .failure(let error):
                self.view?.HideSpinner()
                self.view?.showToast(message: error.localizedDescription, color: .red)
            }
        }
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField == subDomainNameTextField {
            guard let textField = subDomainNameTextField.text, !textField.isEmpty else {
                subDomainNameTextField.showError(message: Constant.ErrorMessage.subDomainNameEmptyError)
                return
            }
            guard let subDomainName = subDomainNameTextField.text, validateName(subDomainName) else {
                subDomainNameTextField.showError(message: "SubDomain Name is invalid.")
                return
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == subDomainNameTextField {
            guard let textField = subDomainNameTextField.text, !textField.isEmpty else {
                subDomainNameTextField.showError(message: Constant.ErrorMessage.subDomainNameEmptyError)
                return
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = Int()
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == subDomainNameTextField {
            maxLength = 30
            subDomainNameTextField.hideError()
            return newString.length <= maxLength
        }
        return true
    }
    
    func validateName(_ firstName: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9-]+$")
        let range = NSRange(location: 0, length: firstName.utf16.count)
        let matches = regex.matches(in: firstName, range: range)
        return !matches.isEmpty
    }
}
