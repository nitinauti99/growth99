//
//  AppointmentTriggersListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

class AppointmentTriggersListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.appointmentTriggers
        navigationItem.backButtonTitle = String.blank
    }
}
