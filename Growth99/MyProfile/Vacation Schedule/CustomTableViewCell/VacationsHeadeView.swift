//
//  VacationsHeadeView.swift
//  Growth99
//
//  Created by admin on 04/12/22.
//

import UIKit

protocol VacationsHeadeViewDelegate: AnyObject {
    func addTimeButton(view: VacationsHeadeView)
    func delateSectionButtonTapped(view: VacationsHeadeView)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateFromTextField.tintColor = .clear
        dateToTextField.tintColor = .clear
        dateFromTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        dateToTextField.addInputViewDatePicker(target: self, selector: #selector(dateToButtonPressed1), mode: .date)
    }
    
    // MARK: - Date from picker done method
    @objc func dateFromButtonPressed() {
        buttondateFromTextFieldCallback(dateFromTextField)
    }
    
    // MARK: - Date from picker done method
    @objc func dateToButtonPressed1() {
       buttondateToTextFieldCallback(dateToTextField)
    }
    
    // MARK: - Update textfield methos
    func updateDateFromTextField(with content: String) {
        dateFromTextField.text = content
    }
    
    func updateDateToTextField(with content: String) {
        dateToTextField.text = content
    }
    
    // MARK: - Add and delete section from headerview
    @IBAction func addTimeButtonAction(sender: UIButton) {
        delegate?.addTimeButton(view: self)
    }
    
    @IBAction func deleteSectionButtonAction(sender: UIButton) {
        delegate?.delateSectionButtonTapped(view: self)
    }
}
