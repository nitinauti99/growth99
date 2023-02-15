//
//  DataStudioViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 15/02/23.
//

import UIKit

class DataStudioViewController: UIViewController {

    @IBOutlet private weak var dataStudioCodeTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataStudioCodeTextView.layer.borderColor = UIColor.gray.cgColor
        dataStudioCodeTextView.layer.borderWidth = 1.0
    }
}
