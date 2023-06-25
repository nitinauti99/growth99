//
//  MassEmailandSMSDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSLeadCellDelegate: AnyObject {
    func nextButtonLead(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath)
    func leadStausButtonSelection(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func leadSourceButtonSelection(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func leadTagButtonSelection(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath, buttonSender: UIButton)
}

class MassEmailandSMSLeadActionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var leadNextButton: UIButton!
    
    @IBOutlet weak var leadStatusButton: UIButton!
    @IBOutlet weak var leadStatusTextField: CustomTextField!
    
    @IBOutlet weak var leadSourceButton: UIButton!
    @IBOutlet weak var leadSourceTextField: CustomTextField!
    @IBOutlet weak var leadSourceTextFieldHight: NSLayoutConstraint!
    @IBOutlet weak var showleadSourceButton: UIButton!
    
    @IBOutlet weak var leadTagButton: UIButton!
    @IBOutlet weak var leadTagTextField: CustomTextField!
    @IBOutlet weak var leadTagTextFieldHight: NSLayoutConstraint!
    @IBOutlet weak var showleadTagButton: UIButton!
    
    weak var delegate: MassEmailandSMSLeadCellDelegate?
    var indexPath = IndexPath()
    var tableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(tableView: UITableView?, index: IndexPath) {
        self.indexPath = index
        self.tableView = tableView
    }
    
    @IBAction func showleadSourceTextField(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            leadSourceTextFieldHight.constant = 0
            leadSourceTextField.rightImage = nil
            leadSourceTextField.text = ""
        } else {
            sender.isSelected = true
            leadSourceTextFieldHight.constant = 45
            leadSourceTextField.rightImage = UIImage(named: "dropDown")
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    @IBAction func showleadTagTextField(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            leadTagTextFieldHight.constant = 0
            leadTagTextField.rightImage = nil
            leadTagTextField.text = ""
        } else {
            sender.isSelected = true
            leadTagTextFieldHight.constant = 45
            leadTagTextField.rightImage = UIImage(named: "dropDown")
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    @IBAction func leadStatusButtonAction(sender: UIButton) {
        self.delegate?.leadStausButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func leadSourceButtonAction(sender: UIButton) {
        self.delegate?.leadSourceButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func leadTagButtonAction(sender: UIButton) {
        self.delegate?.leadTagButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonLead(cell: self, index: indexPath)
    }
}
