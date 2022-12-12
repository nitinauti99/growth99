//
//  WorkingCustomTableViewCell.swift
//  Growth99
//
//  Created by admin on 12/12/22.
//

import UIKit


protocol WorkingCellSubclassDelegate: AnyObject {
    func buttonWorkingtimeFromTapped(cell: WorkingCustomTableViewCell)
    func buttonWorkingtimeToTapped(cell: WorkingCustomTableViewCell)
    func buttonWorkingdaysTapped(cell: WorkingCustomTableViewCell)
}

class WorkingCustomTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var daysTextField: CustomTextField!
    @IBOutlet weak var timeFromTextField: CustomTextField!
    @IBOutlet weak var timeToTextField: CustomTextField!

    var userScheduleTimings: [UserScheduleTimings]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        daysTextField.tintColor = .clear
        timeFromTextField.tintColor = .clear
        timeToTextField.tintColor = .clear
        timeFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), mode: .time)
        timeToTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed1), mode: .time)
    }
    
    weak var delegate: WorkingCellSubclassDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @objc func doneButtonPressed() {
        self.delegate?.buttonWorkingtimeFromTapped(cell: self)
    }
    
    @objc func doneButtonPressed1() {
        self.delegate?.buttonWorkingtimeToTapped(cell: self)
    }
    
    func updateTimeFromTextField(with content: String) {
        timeFromTextField.text = content
    }
    
    func updateTimeToTextField(with content: String) {
        timeToTextField.text = content
    }
}
