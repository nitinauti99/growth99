//
//  TwoWayTextConfigurationViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 04/12/23.
//

import Foundation
import UIKit

protocol TwoWayTextConfigurationViewControllerProtocol{
    func twoWayConfigurationDataRecived()
    func errorReceived(error: String)
}

class TwoWayTextConfigurationViewController: UIViewController {
    @IBOutlet weak var enableTwoWaysmsSWitch: UISwitch!
    @IBOutlet weak var smsAutoReplySWitch: UISwitch!
    @IBOutlet weak var emailNotificationForSmsSWitch: UISwitch!

    var viewModel: TwoWayTextConfigurationViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Configuration"
        self.viewModel = TwoWayTextConfigurationViewModel(delegate: self)
        self.view.ShowSpinner()
        self.enableTwoWaysmsSWitch.isOn = false
        self.smsAutoReplySWitch.isOn = false
        self.emailNotificationForSmsSWitch.isOn = false
        self.viewModel?.getTwoWayConfigurationData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func dataRecived(){
        enableTwoWaysmsSWitch.isOn = self.viewModel?.getConfigurationData.enableTwoWaySMS ?? false
        smsAutoReplySWitch.isOn = self.viewModel?.getConfigurationData.enableSmsAutoReply ?? false
        emailNotificationForSmsSWitch.isOn = self.viewModel?.getConfigurationData.enableEmailNotificationForMessages ?? false
    }
    
    @IBAction func contactSupport(){
        let googleUrlString = "googlegmail:///co?to=support@growth99.com"
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
    
    @IBAction func enableTwoWaySMSAction(){
        self.view.ShowSpinner()
        viewModel?.getTwoWayConfiguration(status: enableTwoWaysmsSWitch.isOn)
    }
    
}

extension TwoWayTextConfigurationViewController : TwoWayTextConfigurationViewControllerProtocol {
   
    func twoWayConfigurationDataRecived(){
        self.view.HideSpinner()
        self.dataRecived()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
}
