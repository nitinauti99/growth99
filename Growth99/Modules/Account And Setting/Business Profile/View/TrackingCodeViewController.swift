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

    override func viewDidLoad() {
        super.viewDidLoad()
        scriptHeaderTextView.layer.borderColor = UIColor.gray.cgColor
        scriptHeaderTextView.layer.borderWidth = 1.0
        
        scriptBodyTextView.layer.borderColor = UIColor.gray.cgColor
        scriptBodyTextView.layer.borderWidth = 1.0
        
        scriptThankTextView.layer.borderColor = UIColor.gray.cgColor
        scriptThankTextView.layer.borderWidth = 1.0
    }

}
