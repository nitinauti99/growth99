//
//  ContactViewController.swift
//  Growth99
//
//  Created by Mahender Reddy on 14/06/23.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showMailComposer()
    }
    
    func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["support@growth99.com"])
        present(composer, animated: true)
    }
}

extension ContactViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true, completion: nil)
            return
        }
        switch result {
        case .cancelled:
            break
        case .failed:
            break
        case .saved:
            break
        case .sent:
            break
        @unknown default:
            print("Facing issue while contact support")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
