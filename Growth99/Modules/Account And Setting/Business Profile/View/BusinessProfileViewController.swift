//
//  BusinessProfileViewController.swift
//  Growth99
//
//  Created by admin on 27/12/22.
//

import UIKit

class BusinessProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = "Business Profile"
    }
}
