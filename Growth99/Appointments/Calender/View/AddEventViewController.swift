//
//  AddEventViewController.swift
//  Growth99
//
//  Created by admin on 27/12/22.
//

import UIKit

class AddEventViewController: UIViewController {

    @IBOutlet private weak var notesTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.layer.borderColor = UIColor.gray.cgColor
        notesTextView.layer.borderWidth = 1.0
        setUpNavigationBar()
    }
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.appointment
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(closeEventClicked), imageName: "iconCircleCross")
    }

    @objc func closeEventClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismiss(animated: true)
    }

}
