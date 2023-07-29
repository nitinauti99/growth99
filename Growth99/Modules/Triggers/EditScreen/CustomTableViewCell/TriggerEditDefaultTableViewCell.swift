//
//  MassEmailandSMSDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerEditDefaultCellDelegate: AnyObject {
    func nextButtonDefault(cell: TriggerEditDefaultTableViewCell, index: IndexPath)
}

class TriggerEditDefaultTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet weak var massEmailSMSTextField: CustomTextField!
    @IBOutlet weak var moduleNextButton: UIButton!
    var userModuleName: String = ""
    
    weak var delegate: TriggerEditDefaultCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(triggerListEdit: TriggerEditModel?, index: IndexPath) {
        indexPath = index
        self.massEmailSMSTextField.text = triggerListEdit?.name ?? ""
        userModuleName = triggerListEdit?.name ?? ""
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sFender: UIButton) {
        self.delegate?.nextButtonDefault(cell: self, index: indexPath)
    }
}