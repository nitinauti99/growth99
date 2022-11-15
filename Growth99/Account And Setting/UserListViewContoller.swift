//
//  UserListViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 15/11/22.
//

import Foundation
import UIKit

class UserListViewContoller: UIViewController {

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
