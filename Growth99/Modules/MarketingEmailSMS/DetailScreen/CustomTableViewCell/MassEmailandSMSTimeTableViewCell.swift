//
//  MassEmailandSMSDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSTimeCellDelegate: AnyObject {
    func nextButtonTime(cell: MassEmailandSMSTimeTableViewCell, index: IndexPath)
    func massEmailTimeFromTapped(cell: MassEmailandSMSTimeTableViewCell)
}

class MassEmailandSMSTimeTableViewCell: UITableViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet weak var massEmailTimeFromTextField: CustomTextField!

    weak var delegate: MassEmailandSMSTimeCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        massEmailTimeFromTextField.tintColor = .clear
        massEmailTimeFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), mode: .date)
    }
    
    @objc func doneButtonPressed() {
        self.delegate?.massEmailTimeFromTapped(cell: self)
    }
    
    func updateMassEmailTimeFromTextField(with content: String) {
        massEmailTimeFromTextField.text = content
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonTime(cell: self, index: indexPath)
    }
}