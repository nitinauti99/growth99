//
//  MassEmailandSMSDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerModuleCellDelegate: AnyObject {
    func nextButtonModule(cell: TriggerModuleTableViewCell, index: IndexPath, moduleType: String)
}

class TriggerModuleTableViewCell: UITableViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet private weak var leadBtn: UIButton!
    @IBOutlet private weak var patientBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    var moduleTypeSelected: String = "lead"
    let radioController: RadioButtonController = RadioButtonController()
    
    weak var delegate: TriggerModuleCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        radioController.buttonsArray = [leadBtn, patientBtn]
        radioController.defaultButton = leadBtn
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonModule(cell: self, index: indexPath, moduleType: moduleTypeSelected)
    }
    
    @IBAction func leadButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        moduleTypeSelected = "lead"
    }
    
    @IBAction func patientButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        moduleTypeSelected = "appointment"
    }
}
