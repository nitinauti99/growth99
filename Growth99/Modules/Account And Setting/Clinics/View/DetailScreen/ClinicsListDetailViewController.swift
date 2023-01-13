//
//  ClinicsListDetailViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 12/01/23.
//

import UIKit

class ClinicsListDetailViewController: UIViewController {

    
    @IBOutlet private weak var aboutClinicTextView: UITextView!
    @IBOutlet private weak var giftCardTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupUI()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.createClinic
    }
    
    func setupUI() {
        aboutClinicTextView.layer.borderColor = UIColor.gray.cgColor
        aboutClinicTextView.layer.borderWidth = 1.0
        giftCardTextView.layer.borderColor = UIColor.gray.cgColor
        giftCardTextView.layer.borderWidth = 1.0
    }

}
