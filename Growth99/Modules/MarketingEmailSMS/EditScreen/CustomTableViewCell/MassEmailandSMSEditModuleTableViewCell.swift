//
//  MassEmailandSMSDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSEditModuleCellDelegate: AnyObject {
    func nextButtonModule(cell: MassEmailandSMSEditModuleTableViewCell, index: IndexPath, moduleType: String)
    func leadButtonModule(cell: MassEmailandSMSEditModuleTableViewCell, index: IndexPath, moduleType: String)
    func patientButtonModule(cell: MassEmailandSMSEditModuleTableViewCell, index: IndexPath, moduleType: String)
    func bothButtonModule(cell: MassEmailandSMSEditModuleTableViewCell, index: IndexPath, moduleType: String)
    
}

class MassEmailandSMSEditModuleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet weak var leadBtn: UIButton!
    @IBOutlet weak var patientBtn: UIButton!
    @IBOutlet weak var bothBtn: UIButton!
    @IBOutlet weak var moduleNextButton: UIButton!
    var moduleTypeSelected: String = "lead"
    
    weak var delegate: MassEmailandSMSEditModuleCellDelegate?
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
        self.delegate?.leadButtonModule(cell: self, index: indexPath, moduleType: moduleTypeSelected)
    }
    
    @IBAction func patientButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        moduleTypeSelected = "patient"
        self.delegate?.patientButtonModule(cell: self, index: indexPath, moduleType: moduleTypeSelected)
    }
    
    @IBAction func bothButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        moduleTypeSelected = "both"
        self.delegate?.bothButtonModule(cell: self, index: indexPath, moduleType: moduleTypeSelected)
    }
}
