//
//  CreateLeadViewController.swift
//  Growth99
//
//  Created by nitin auti on 04/12/22.
//

import Foundation
import UIKit

class CreateLeadViewController: UIViewController {
    
    @IBOutlet weak var firsNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var messageTextField: CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true)
    }
}

