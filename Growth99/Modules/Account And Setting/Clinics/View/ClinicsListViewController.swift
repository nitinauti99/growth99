//
//  ClinicsListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

class ClinicsListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        title = Constant.Profile.clinics
        self.navigationItem.backBarButtonItem?.title = String.blank
    }

}
