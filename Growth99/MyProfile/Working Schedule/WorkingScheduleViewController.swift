//
//  WorkingScheduleViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

class WorkingScheduleViewController: UIViewController {

    let appDel = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMenuButton()
    }
    
    func setUpMenuButton() {
        navigationItem.leftBarButtonItems = UIBarButtonItem.createApplicationLogo(target: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem.createMenu(target: self, action: #selector(logoutUser))
    }
    
    @objc func logoutUser(){
        appDel.drawerController.setDrawerState(.opened, animated: true)
    }

}
