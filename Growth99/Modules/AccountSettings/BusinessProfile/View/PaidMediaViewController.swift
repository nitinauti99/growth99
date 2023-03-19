//
//  PaidMediaViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 15/02/23.
//

import UIKit

class PaidMediaViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet private weak var paidMediaCodeTextView: UITextView!
    @IBOutlet private weak var errorLabel: UILabel!

    var bussinessInfoData: BusinessSubDomainModel?
    
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paidMediaCodeTextView.layer.borderColor = UIColor.gray.cgColor
        paidMediaCodeTextView.layer.borderWidth = 1.0
        paidMediaCodeTextView.layer.cornerRadius = 5
        paidMediaCodeTextView.text = bussinessInfoData?.paidMediaCode
        paidMediaCodeTextView.delegate = self
    }
    
    @IBAction func savebtnTapped(_ sender: Any) {
        if paidMediaCodeTextView.text.isEmpty {
            errorLabel.text = Constant.ErrorMessage.emptyURLError
            errorLabel.isHidden = false
        } else if !paidMediaCodeTextView.text.validateUrl() {
            errorLabel.text = Constant.ErrorMessage.invalidURLError
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
            self.view.ShowSpinner()
            savePaidMediaInfo(paidMediaCodeText: paidMediaCodeTextView.text)
        }
    }
    
    @IBAction func deletebtnTapped(_ sender: Any) {
        if paidMediaCodeTextView.text != String.blank {
            paidMediaCodeTextView.text = String.blank
            self.view.ShowSpinner()
            savePaidMediaInfo(paidMediaCodeText: paidMediaCodeTextView.text)
        }
    }
    
    func savePaidMediaInfo(paidMediaCodeText: String) {
        let parameter: [String : Any] = ["paidMediaCode": paidMediaCodeText]
        let finaleUrl = ApiUrl.bussinessInfo + "\(bussinessInfoData?.id ?? 0)/paidMedia"
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
