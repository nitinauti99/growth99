//
//  LeadTriggersListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

class LeadTriggersListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.leadTriggers
        navigationItem.backButtonTitle = String.blank
    }
}
