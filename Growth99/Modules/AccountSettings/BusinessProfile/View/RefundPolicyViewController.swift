//
//  RefundPolicyViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 15/02/23.
//

import UIKit

class RefundPolicyViewController: UIViewController {
    
    @IBOutlet private weak var paymentRefundableTF: CustomTextField!
    @IBOutlet private weak var refundablePercentageTF: CustomTextField!
    @IBOutlet private weak var paymentRefundableBtn: UIButton!
        
    var bussinessInfoData: BusinessSubDomainModel?
    
    var paymentRefundable: Bool = true
    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if bussinessInfoData?.paymentRefundable == true {
            paymentRefundableBtn.isSelected = true
        } else {
            paymentRefundableBtn.isSelected = false
        }
        self.paymentRefundableTF.text = "\(bussinessInfoData?.paymentRefundableBeforeHours ?? 0)"
        self.refundablePercentageTF.text = self.forTrailingZero(temp: bussinessInfoData?.refundablePaymentPercentage ?? 0.0)
    }
    
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    @IBAction func paymentRefundableBtnTapped(_ sender: Any) {
        paymentRefundableBtn.isSelected = !paymentRefundableBtn.isSelected
        if paymentRefundableBtn.isSelected {
            paymentRefundable = true
        } else {
            paymentRefundable = false
        }
    }
    
    @IBAction func savebtnTapped(_ sender: Any) {
        guard let refundablePercentage = refundablePercentageTF.text, !refundablePercentage.isEmpty else {
            refundablePercentageTF.showError(message: Constant.ErrorMessage.refundPercentageEmptyError)
            return
        }
        self.view.ShowSpinner()
        let paymentRefund = Int(paymentRefundableTF.text ?? String.blank) ?? 0
        let refundePercentage = Int(refundablePercentageTF.text ?? String.blank) ?? 0
        saveSubDomainInfo(paymentRefundable: paymentRefundable, paymentRefundableText: paymentRefund, refundablePercentage: refundePercentage)
    }
    
    func saveSubDomainInfo(paymentRefundable: Bool, paymentRefundableText: Int, refundablePercentage: Int) {
        let parameter: [String : Any] = ["paymentRefundable": paymentRefundable, "paymentRefundableBeforeHours": paymentRefundableText, "refundablePaymentPercentage": refundablePercentage]
        let finaleUrl = ApiUrl.paymentRefund + "\(bussinessInfoData?.id ?? 0)"
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<BusinessSubDomainModel, GrowthNetworkError>) in
            switch result {
            case .success(_):
                self.view?.HideSpinner()
                self.view?.showToast(message: "Information updated successfully", color: UIColor().successMessageColor())
            case .failure(let error):
                self.view?.HideSpinner()
                self.view?.showToast(message: error.localizedDescription, color: .red)
            }
        }
    }
}
