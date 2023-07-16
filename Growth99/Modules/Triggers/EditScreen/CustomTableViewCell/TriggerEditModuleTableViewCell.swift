//
//  MassEmailandSMSDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerEditModuleCellDelegate: AnyObject {
    func nextButtonModule(cell: TriggerEditModuleTableViewCell, index: IndexPath, moduleType: String)
}

class TriggerEditModuleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var subViewInside: UIView!
    @IBOutlet weak var leadBtn: UIButton!
    @IBOutlet weak var patientBtn: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var moduleTypeSelected: String = "leads"
    let radioController: RadioButtonController = RadioButtonController()
    
    weak var delegate: TriggerEditModuleCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        radioController.buttonsArray = [leadBtn, patientBtn]
        radioController.defaultButton = leadBtn
    }
    
    func configureCell(index: IndexPath, sender: UIButton, modelType: String) {
        indexPath = index
        moduleTypeSelected = modelType
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonModule(cell: self, index: indexPath, moduleType: moduleTypeSelected)
    }
    
    @IBAction func leadButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        moduleTypeSelected = "leads"
    }
    
    @IBAction func patientButtonAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        moduleTypeSelected = "Appointment"
    }
}