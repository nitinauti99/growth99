//
//  VacationScheduleViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

class VacationScheduleViewController: UIViewController {

    private var menuVC = DrawerViewContoller()
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        menuVC = sidemenuVC as! DrawerViewContoller
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.navigationItem.titleView = UIImageView.navigationBarLogo()
        navigationItem.leftBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "menu")
    }
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
    }
}
