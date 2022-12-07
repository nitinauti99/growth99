//
//  VacationsHeadeView.swift
//  Growth99
//
//  Created by admin on 04/12/22.
//

import UIKit

protocol VacationsHeadeViewDelegate: AnyObject {
    func addTimeButton(view: VacationsHeadeView)
}

class VacationsHeadeView: UITableViewHeaderFooterView {
    @IBOutlet weak var addTimeButton: UIButton!
    @IBOutlet weak var addTimeButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTimeButtonTopHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateFromTextField: CustomTextField!
    @IBOutlet weak var dateToTextField: CustomTextField!
    
    weak var delegate: VacationsHeadeViewDelegate?
    
    var buttondateFromTextFieldCallback: (CustomTextField) -> ()  = { _ in }
    var buttondateToTextFieldCallback: (CustomTextField) -> ()  = { _ in }
    
    @IBAction func addTimeButtonAction(sender: UIButton) {
        delegate?.addTimeButton(view: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFromTextField.tintColor = .clear
        dateToTextField.tintColor = .clear
        dateFromTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        dateToTextField.addInputViewDatePicker(target: self, selector: #selector(dateToButtonPressed1), mode: .date)
    }
    
    @objc func dateFromButtonPressed() {
        buttondateFromTextFieldCallback(dateFromTextField)
    }
    
    @objc func dateToButtonPressed1() {
       buttondateToTextFieldCallback(dateToTextField)
    }
    
    func updateDateFromTextField(with content: String) {
        dateFromTextField.text = content
    }
    
    func updateDateToTextField(with content: String) {
        dateToTextField.text = content
    }
}
