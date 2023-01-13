//
//  ServicesListDetailViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 13/01/23.
//

import UIKit

class ServicesListDetailViewController: UIViewController {

    @IBOutlet private weak var serviceDescTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupUI()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.createService
    }
    
    func setupUI() {
        serviceDescTextView.layer.borderColor = UIColor.gray.cgColor
        serviceDescTextView.layer.borderWidth = 1.0
    }
}
