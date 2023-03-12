//
//  TriggerDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerTimeCellDelegate: AnyObject {
    func nextButtonTime(cell: TriggerTimeTableViewCell, index: IndexPath)
    func triggerTimeFromTapped(cell: TriggerTimeTableViewCell)
}

class TriggerTimeTableViewCell: UITableViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet weak var triggerTimeFromTextField: CustomTextField!

    weak var delegate: TriggerTimeCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
       triggerTimeFromTextField.tintColor = .clear
        triggerTimeFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), mode: .date)
    }
    
    @objc func doneButtonPressed() {
        self.delegate?.triggerTimeFromTapped(cell: self)
    }
    
    func updatetriggerTimeFromTextField(with content: String) {
        triggerTimeFromTextField.text = content
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonTime(cell: self, index: indexPath)
    }
}
