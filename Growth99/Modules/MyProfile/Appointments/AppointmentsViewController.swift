//
//  AppointmentsViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

class AppointmentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.appointment
    }

}
