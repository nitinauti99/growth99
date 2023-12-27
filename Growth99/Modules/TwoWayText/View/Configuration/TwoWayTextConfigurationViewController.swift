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
    @IBOutlet weak var twilioNumber: UILabel!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var notificationEmail: UILabel!

    
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
    
    func dataRecived(){
        self.enableTwoWaysmsSWitch.isOn = self.viewModel?.getConfigurationData.enableTwoWaySMS ?? false
        self.smsAutoReplySWitch.isOn = self.viewModel?.getConfigurationData.enableSmsAutoReply ?? false
        self.emailNotificationForSmsSWitch.isOn = self.viewModel?.getConfigurationData.enableEmailNotificationForMessages ?? false
        self.twilioNumber.text = "Two way Text Configuration (\( self.viewModel?.getConfigurationData.twilioNumber ?? ""))"
        self.topview.roundCornersView(corners: [.topLeft, .topRight], radius: 10)
        self.bottomView.roundCornersView(corners: [.bottomLeft, .bottomRight], radius: 10)
        
        let boldText  = self.viewModel?.getConfigurationData.notificationEmail ?? ""
        let normalText = "( You will now receive email notifications for all incoming text messages on "
        let normalText2 = " Please note that this feature will utilize your subscribed email quota. )"
        let attributedString = NSMutableAttributedString(string: normalText)
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]
        let boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        attributedString.append(boldString)
        let attributedString1 = NSMutableAttributedString(string: normalText2)
        attributedString.append(attributedString1)
        self.notificationEmail.attributedText = attributedString
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
    
    @IBAction func smsAutoReplySWitchAction(){
        self.view.ShowSpinner()
        viewModel?.getTwoWayConfigurationforSMandEmail(configurationKey: "smsAutoReply", status: smsAutoReplySWitch.isOn)
    }
    
    @IBAction func emailNotificationForsmsAction(){
        self.view.ShowSpinner()
        viewModel?.getTwoWayConfigurationforSMandEmail(configurationKey: "emailNotificationForSms", status: emailNotificationForSmsSWitch.isOn)
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
