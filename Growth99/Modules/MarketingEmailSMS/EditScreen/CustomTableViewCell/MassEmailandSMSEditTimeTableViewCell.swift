//
//  MassEmailandSMSEditTimeTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSEditTimeCellDelegate: AnyObject {
    func submitButtonTime(cell: MassEmailandSMSEditTimeTableViewCell, index: IndexPath)
    func cancelButtonTime(cell: MassEmailandSMSEditTimeTableViewCell, index: IndexPath)
    func massSMSDateSelectionTapped(cell: MassEmailandSMSEditTimeTableViewCell)
    func massSMSTimeSelectionTapped(cell: MassEmailandSMSEditTimeTableViewCell)

}

class MassEmailandSMSEditTimeTableViewCell: UITableViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var massSMSTriggerDateTextField: CustomTextField!
    @IBOutlet weak var massSMSTriggerTimeTextField: CustomTextField!

    weak var delegate: MassEmailandSMSEditTimeCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        massSMSTriggerDateTextField.tintColor = .clear
        massSMSTriggerDateTextField.addInputViewDatePicker(target: self, selector: #selector(dateButtonPressed), mode: .date)
        massSMSTriggerTimeTextField.tintColor = .clear
        massSMSTriggerTimeTextField.addInputViewDatePicker(target: self, selector: #selector(timeButtonPressed), mode: .time)
    }
    
    @objc func dateButtonPressed() {
        self.delegate?.massSMSDateSelectionTapped(cell: self)
    }
    
    @objc func timeButtonPressed() {
        self.delegate?.massSMSTimeSelectionTapped(cell: self)
    }
    
    func updateMassEmailDateTextField(with content: String) {
        massSMSTriggerDateTextField.text = content
    }
    
    func updateMassEmailTimeTextField(with content: String) {
        massSMSTriggerTimeTextField.text = content
    }
    
    // MARK: - Add and remove time methods
    @IBAction func submitButtonAction(sender: UIButton) {
        self.delegate?.submitButtonTime(cell: self, index: indexPath)
    }
    
    // MARK: - Add and remove time methods
    @IBAction func cancelButtonAction(sender: UIButton) {
        self.delegate?.cancelButtonTime(cell: self, index: indexPath)
    }
}
