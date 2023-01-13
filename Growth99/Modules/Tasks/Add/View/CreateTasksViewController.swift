//
//  CreateTasksViewController.swift
//  Growth99
//
//  Created by nitin auti on 12/01/23.
//

import UIKit

class CreateTasksViewController: UIViewController {

    @IBOutlet private weak var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor;
        descriptionTextView.layer.borderWidth = 1.0;
    }
    
}
