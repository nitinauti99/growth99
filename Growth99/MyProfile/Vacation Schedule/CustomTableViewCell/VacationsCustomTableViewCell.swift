//
//  VacationsCustomTableViewCell.swift
//  Growth99
//
//  Created by admin on 03/12/22.
//

import UIKit

protocol CellSubclassDelegate: AnyObject {
    func buttontimeFromTapped(cell: VacationsCustomTableViewCell)
    func buttontimeToTapped(cell: VacationsCustomTableViewCell)

}

class VacationsCustomTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var addTimeButton: UIButton!
    @IBOutlet weak var removeTimeButton: UIButton!
    @IBOutlet weak var timeFromTextField: CustomTextField!
    @IBOutlet weak var timeToTextField: CustomTextField!

    var userScheduleTimings: [UserScheduleTimings]?

    var buttonRemoveTapCallback: () -> ()  = { }
    var buttonAddTimeTapCallback: () -> ()  = { }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeFromTextField.tintColor = .clear
        timeToTextField.tintColor = .clear
        timeFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), mode: .time)
        timeToTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed1), mode: .time)
    }
    
    weak var delegate: CellSubclassDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @objc func doneButtonPressed() {
        self.delegate?.buttontimeFromTapped(cell: self)
    }
    
    @objc func doneButtonPressed1() {
        self.delegate?.buttontimeToTapped(cell: self)
    }
    
    func updateTimeFromTextField(with content: String) {
        timeFromTextField.text = content
    }
    
    func updateTimeToTextField(with content: String) {
        timeToTextField.text = content
    }
    
    @IBAction func addTimeButtonAction(sFender: UIButton) {
        didTapAddTimeButton()
    }
    
    @IBAction func removeTimeButtonAction(sender: UIButton) {
        buttonRemoveTapCallback()
    }
    
    @objc func didTapAddTimeButton() {
        buttonAddTimeTapCallback()
    }
    
    @objc func didTapRemoveTimeButton() {
        buttonRemoveTapCallback()
    }
}
