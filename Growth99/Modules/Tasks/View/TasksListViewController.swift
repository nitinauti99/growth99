//
//  TasksListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

class TasksListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.tasks
        navigationItem.backButtonTitle = String.blank
    }
}
