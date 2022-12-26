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

    // MARK: - Button closures
    var buttonRemoveTapCallback: () -> ()  = { }
    var buttonAddTimeTapCallback: () -> ()  = { }
    var userScheduleTimings: [UserScheduleTimings]?
    weak var delegate: CellSubclassDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeFromTextField.tintColor = .clear
        timeToTextField.tintColor = .clear
        timeFromTextField.addInputViewDatePicker(target: self, selector: #selector(timeFromDoneButtonPressed), mode: .time)
        timeToTextField.addInputViewDatePicker(target: self, selector: #selector(timeToDoneButtonPressed), mode: .time)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    // MARK: - Time from picker done method
    @objc func timeFromDoneButtonPressed() {
        self.delegate?.buttontimeFromTapped(cell: self)
    }
    
    // MARK: - Time to picker done method
    @objc func timeToDoneButtonPressed() {
        self.delegate?.buttontimeToTapped(cell: self)
    }
    
    // MARK: - Update textfield methos
    func updateTimeFromTextField(with content: String) {
        timeFromTextField.text = content
    }
    
    func updateTimeToTextField(with content: String) {
        timeToTextField.text = content
    }
    
    // MARK: - Add and remove time methods
    @IBAction func addTimeButtonAction(sFender: UIButton) {
        buttonAddTimeTapCallback()
    }
    
    @IBAction func removeTimeButtonAction(sender: UIButton) {
        buttonRemoveTapCallback()
    }
}
