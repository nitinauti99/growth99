//
//  LabelsViewController.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit

class LabelsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.postLabel
    }
}
