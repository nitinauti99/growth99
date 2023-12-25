//
//  UpgradeTwoWayTextViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 24/12/23.
//

import Foundation
import UIKit

protocol UpgradeTwoWayTextViewControllerProtocol{
    func twoWayConfigurationDataRecived()
    func errorReceived(error: String)
}

class UpgradeTwoWayTextViewController: UIViewController {
    var viewModel: TwoWayTextConfigurationViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Configuration"
    }
  
    @IBAction func viewDemoAction(){
        let googleUrlString = "https://support.growth99.com/portal/en/kb/articles/two-way-texting-feature-in-the-g99-application"
        if let googleUrl = NSURL(string: googleUrlString) {
            if UIApplication.shared.canOpenURL(googleUrl as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(googleUrl as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(googleUrl as URL)
                }
            }
        }
    }
    
    @IBAction func upgradeNowAction(sender: UIButton){
        let alert = UIAlertController(title: "Upgrade Message", message: "For Upgrade login into web application", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UpgradeTwoWayTextViewController : UpgradeTwoWayTextViewControllerProtocol {
    
    func twoWayConfigurationDataRecived(){
        self.view.HideSpinner()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
}
