//
//  PaidMediaViewController.swift
//  Growth99
//
//  Created by Exaze Technologies on 15/02/23.
//

import UIKit

class PaidMediaViewController: UIViewController {
    
    @IBOutlet private weak var paidMediaCodeTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        paidMediaCodeTextView.layer.borderColor = UIColor.gray.cgColor
        paidMediaCodeTextView.layer.borderWidth = 1.0
    }

}
