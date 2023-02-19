//
//  DataStudioViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 15/02/23.
//

import UIKit

class DataStudioViewController: UIViewController, UITextViewDelegate {

    @IBOutlet private weak var dataStudioCodeTextView: UITextView!
    @IBOutlet private weak var errorLabel: UILabel!

    var bussinessInfoData: BusinessSubDomainModel?

    private var requestManager = RequestManager(configuration: URLSessionConfiguration.default, pinningPolicy: PinningPolicy(bundle: Bundle.main, type: .certificate))

    override func viewDidLoad() {
        super.viewDidLoad()
        dataStudioCodeTextView.layer.borderColor = UIColor.gray.cgColor
        dataStudioCodeTextView.layer.borderWidth = 1.0
        dataStudioCodeTextView.layer.cornerRadius = 5
        dataStudioCodeTextView.text = bussinessInfoData?.dataStudioCode
        dataStudioCodeTextView.delegate = self
    }
    
    @IBAction func savebtnTapped(_ sender: Any) {
        if dataStudioCodeTextView.text.isEmpty {
            errorLabel.text = Constant.ErrorMessage.emptyURLError
            errorLabel.isHidden = false
        } else if !dataStudioCodeTextView.text.validateUrl() {
            errorLabel.text = Constant.ErrorMessage.invalidURLError
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
            self.view.ShowSpinner()
            saveDataStudioInfo(dataStudioCodeText: dataStudioCodeTextView.text)
        }
    }
    
    @IBAction func deletebtnTapped(_ sender: Any) {
        if dataStudioCodeTextView.text != String.blank {
            dataStudioCodeTextView.text = String.blank
            self.view.ShowSpinner()
            saveDataStudioInfo(dataStudioCodeText: dataStudioCodeTextView.text)
        }
    }
    
    func saveDataStudioInfo(dataStudioCodeText: String) {
        let parameter: [String : Any] = ["dataStudioCode": dataStudioCodeText]
        let finaleUrl = ApiUrl.bussinessInfo + "\(bussinessInfoData?.id ?? 0)/dataStudio"
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<BusinessSubDomainModel, GrowthNetworkError>) in
            switch result {
            case .success(_):
                self.view?.HideSpinner()
                self.view?.showToast(message: "Information updated sucessfully.", color: .black)
            case .failure(let error):
                self.view?.HideSpinner()
                self.view?.showToast(message: error.localizedDescription, color: .black)
            }
        }
    }
}
