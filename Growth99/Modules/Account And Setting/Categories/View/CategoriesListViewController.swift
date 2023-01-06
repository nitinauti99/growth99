//
//  CategoriesListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

class CategoriesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.categories
        navigationItem.backButtonTitle = String.blank
    }

}
