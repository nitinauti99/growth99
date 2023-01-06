//
//  AppointmentsViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

class AppointmentsViewController: UIViewController {

    private var menuVC = DrawerViewContoller()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.navigationItem.titleView = UIImageView.navigationBarLogo()
    }

}
