//
//  TrackingCodeViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 15/02/23.
//

import UIKit

class TrackingCodeViewController: UIViewController {

    @IBOutlet private weak var scriptHeaderTextView: UITextView!
    @IBOutlet private weak var scriptBodyTextView: UITextView!
    @IBOutlet private weak var scriptThankTextView: UITextView!

    var bussinessInfoData: BusinessSubDomainModel?

    private var requestManager = GrowthRequestManager(configuration: URLSessionConfiguration.default)

    override func viewDidLoad() {
        super.viewDidLoad()
        scriptHeaderTextView.layer.borderColor = UIColor.gray.cgColor
        scriptHeaderTextView.layer.borderWidth = 1.0
        scriptHeaderTextView.layer.cornerRadius = 5
        
        scriptBodyTextView.layer.borderColor = UIColor.gray.cgColor
        scriptBodyTextView.layer.borderWidth = 1.0
        scriptBodyTextView.layer.cornerRadius = 5
        
        scriptThankTextView.layer.borderColor = UIColor.gray.cgColor
        scriptThankTextView.layer.borderWidth = 1.0
        scriptThankTextView.layer.cornerRadius = 5
        
        scriptHeaderTextView.text = bussinessInfoData?.googleAnalyticsGlobalCode
        scriptBodyTextView.text = bussinessInfoData?.googleAnalyticsGlobalCodeUrl
        scriptThankTextView.text = bussinessInfoData?.landingPageTrackCode
    }
    
    @IBAction func savebtnTapped(_ sender: Any) {
        self.view.ShowSpinner()
        saveTrackingCodeInfo(scriptHeader: scriptHeaderTextView.text, scriptBody: scriptBodyTextView.text, scriptThank: scriptThankTextView.text)
    }
    
    func saveTrackingCodeInfo(scriptHeader: String, scriptBody: String, scriptThank: String) {
        let parameter: [String : Any] = ["googleAnalyticsGlobalCode": scriptHeader, "googleAnalyticsGlobalCodeUrl": scriptBody, "landingPageTrackCode": scriptThank]
        let finaleUrl = ApiUrl.bussinessInfo + "\(bussinessInfoData?.id ?? 0)/trackingcode"
        self.requestManager.request(forPath: finaleUrl, method: .PUT, headers: requestManager.Headers(), task: .requestParameters(parameters: parameter, encoding: .jsonEncoding)) { (result: Result<BusinessSubDomainModel, GrowthNetworkError>) in
            switch result {
            case .success(_):
                self.view?.HideSpinner()
                self.view?.showToast(message: "Information updated sucessfully.", color: UIColor().successMessageColor())
            case .failure(let error):
                self.view?.HideSpinner()
                self.view?.showToast(message: error.localizedDescription, color: .red)
            }
        }
    }
}
