//
//  AddPostViewController.swift
//  Growth99
//
//  Created by Apple on 17/03/23.
//

import UIKit

class AddPostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
    
    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = "Add Post"
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(closeEventClicked), imageName: "iconCircleCross")
    }
    
    @objc func closeEventClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        self.dismiss(animated: true)
    }
}
