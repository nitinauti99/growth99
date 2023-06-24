//
//  MassEmailandSMSDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSModuleCellDelegate: AnyObject {
    func nextButtonModule(cell: MassEmailandSMSModuleTableViewCell, index: IndexPath, moduleType: String)
}

class MassEmailandSMSModuleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet private weak var leadBtn: UIButton!
    @IBOutlet private weak var patientBtn: UIButton!
    @IBOutlet private weak var bothBtn: UIButton!
    @IBOutlet weak var moduleNextButton: UIButton!
    var moduleTypeSelected: String = "lead"
    
    weak var delegate: MassEmailandSMSModuleCellDelegate?
    var indexPath = IndexPath()
    let radioController: RadioButtonController = RadioButtonController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        radioController.buttonsArray = [leadBtn, patientBtn, bothBtn]
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
        moduleTypeSelected = "patient"
    }
    
    @IBAction func bothButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        moduleTypeSelected = "both"
    }
}
