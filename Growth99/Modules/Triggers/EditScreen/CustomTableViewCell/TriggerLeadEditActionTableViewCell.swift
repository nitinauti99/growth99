//
//  TriggerDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerLeadEdiTableViewCellDelegate: AnyObject {
    func nextButtonLead(cell: TriggerLeadEditActionTableViewCell, index: IndexPath)
    func leadFormButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func leadLandingButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func leadSelectFormsButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func leadSourceButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func leadInitialStatusButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func leadFinalStatusButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func leadTagButtonSelection(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func showLeadTagButtonClicked(cell: TriggerLeadEditActionTableViewCell, index: IndexPath, buttonSender: UIButton)
}

class TriggerLeadEditActionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    
    @IBOutlet weak var leadFromButton: UIButton!
    @IBOutlet weak var leadFromTextField: CustomTextField!
    
    @IBOutlet weak var leadSelectLandingLblTopHeight: NSLayoutConstraint!
    @IBOutlet weak var leadSelectLandingLblHeight: NSLayoutConstraint!
    @IBOutlet weak var leadSelectLandingButton: UIButton!
    @IBOutlet weak var leadSelectLandingTextField: CustomTextField!
    @IBOutlet weak var leadSelectLandingTextFieldHight: NSLayoutConstraint!
    
    @IBOutlet weak var leadLandingSelectFromLblTopHeight: NSLayoutConstraint!
    @IBOutlet weak var leadLandingSelectFromLblHeight: NSLayoutConstraint!
    @IBOutlet weak var leadLandingSelectFromButton: UIButton!
    @IBOutlet weak var leadLandingSelectFromTextField: CustomTextField!
    @IBOutlet weak var leadLandingSelectFromTextFieldHight: NSLayoutConstraint!
    
    @IBOutlet weak var leadSelectSourceLblTopHeight: NSLayoutConstraint!
    @IBOutlet weak var leadSelectSourceLblHeight: NSLayoutConstraint!
    @IBOutlet weak var leadSelectSourceButton: UIButton!
    @IBOutlet weak var leadSelectSourceTextField: CustomTextField!
    @IBOutlet weak var leadSelectSourceTextFieldHight: NSLayoutConstraint!
    @IBOutlet weak var showleadSourceTagButton: UIButton!
    @IBOutlet weak var showleadSourceTagButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var leadTagButton: UIButton!
    @IBOutlet weak var leadTagTextField: CustomTextField!
    @IBOutlet weak var leadTagTextFieldHight: NSLayoutConstraint!
    
    @IBOutlet weak var leadSTriggerWhenStatusTopeight: NSLayoutConstraint!
    @IBOutlet weak var leadSTriggerWhenStatusLblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var leadInitialStatusFromLblTopHeight: NSLayoutConstraint!
    @IBOutlet weak var leadInitialStatusFromLblHeight: NSLayoutConstraint!
    @IBOutlet weak var leadInitialStatusButton: UIButton!
    @IBOutlet weak var leadInitialStatusTextField: CustomTextField!
    @IBOutlet weak var leadInitialStatusTextFieldHight: NSLayoutConstraint!
    
    @IBOutlet weak var leadFinalStatusToLblTopHeight: NSLayoutConstraint!
    @IBOutlet weak var leadFinalStatusToLblHeight: NSLayoutConstraint!
    @IBOutlet weak var leadFinalStatusButton: UIButton!
    @IBOutlet weak var leadFinalStatusTextField: CustomTextField!
    @IBOutlet weak var leadFinalStatusTextFieldHight: NSLayoutConstraint!
    
    @IBOutlet weak var showleadTagButton: UIButton!
    @IBOutlet weak var addleadTagButtonTopHeight: NSLayoutConstraint!
    @IBOutlet weak var leadStatusChangeButton: UIButton!
    @IBOutlet weak var leadStatusChangeButtonTopHeight: NSLayoutConstraint!
    
    @IBOutlet weak var leadNextButton: UIButton!
    
    weak var delegate: TriggerLeadEdiTableViewCellDelegate?
    var indexPath = IndexPath()
    var tableView: UITableView?
    var triggerListInfoEdit = [TriggerEditDetailModel]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(tableView: UITableView?, index: IndexPath, triggerListEdit: [TriggerEditDetailModel]) {
        self.indexPath = index
        self.tableView = tableView
        triggerListInfoEdit = triggerListEdit
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonLead(cell: self, index: indexPath)
    }
    
    @IBAction func leadFromButtonAction(sender: UIButton) {
        self.delegate?.leadFormButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func leadSelectLandingButtonAction(sender: UIButton) {
        self.delegate?.leadLandingButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func leadSelectFormsButtonAction(sender: UIButton) {
        self.delegate?.leadSelectFormsButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func leadSelectSourceAction(sender: UIButton) {
        self.delegate?.leadSourceButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func showSelectSourceButtonAction(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            leadSelectSourceTextFieldHight.constant = 0
            leadSelectSourceTextField.rightImage = nil
            leadSelectSourceTextField.text = ""
        } else {
            sender.isSelected = true
            leadSelectSourceTextFieldHight.constant = 45
            leadSelectSourceTextField.rightImage = UIImage(named: "dropDown")
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    @IBAction func leadInitialStatusButtonAction(sender: UIButton) {
        self.delegate?.leadInitialStatusButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func leadFinalStatusButtonAction(sender: UIButton) {
        self.delegate?.leadFinalStatusButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func leadTagButtonAction(sender: UIButton) {
        self.delegate?.leadTagButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func leadStatusChangeButtonAction(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            
            addleadTagButtonTopHeight.constant = 0
            
            leadSTriggerWhenStatusTopeight.constant = 0
            leadSTriggerWhenStatusLblHeight.constant = 0
            
            leadInitialStatusTextField.text = ""
            leadInitialStatusTextField.rightImage = nil
            leadInitialStatusFromLblTopHeight.constant = 0
            leadInitialStatusFromLblHeight.constant = 0
            leadInitialStatusTextFieldHight.constant = 0
            
            leadFinalStatusTextField.text = ""
            leadFinalStatusTextField.rightImage = nil
            leadFinalStatusToLblHeight.constant = 0
            leadFinalStatusToLblTopHeight.constant = 0
            leadFinalStatusTextFieldHight.constant = 0
        } else {
            sender.isSelected = true
            
            addleadTagButtonTopHeight.constant = 16
            
            leadSTriggerWhenStatusTopeight.constant = 16
            leadSTriggerWhenStatusLblHeight.constant = 20
            
            leadInitialStatusFromLblTopHeight.constant = 16
            leadInitialStatusFromLblHeight.constant = 20
            leadInitialStatusTextFieldHight.constant = 45
            
            leadFinalStatusToLblHeight.constant = 16
            leadFinalStatusToLblTopHeight.constant = 20
            leadFinalStatusTextFieldHight.constant = 45
            
            leadInitialStatusTextField.rightImage = UIImage(named: "dropDown")
            leadFinalStatusTextField.rightImage = UIImage(named: "dropDown")
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
        self.scrollToBottomView()
    }
    
    @IBAction func showLeadTagsButtonAction(sender: UIButton) {
        self.delegate?.showLeadTagButtonClicked(cell: self, index: indexPath, buttonSender: sender)
    }
    
    func showLeadSelectLanding(isShown: Bool) {
        if isShown {
            self.leadSelectLandingLblTopHeight.constant = 20
            self.leadSelectLandingLblHeight.constant = 20
            self.leadSelectLandingTextFieldHight.constant = 45
            self.leadSelectLandingTextField.rightImage = UIImage(named: "dropDown")
        } else {
            self.leadSelectLandingLblTopHeight.constant = 0
            self.leadSelectLandingLblHeight.constant = 0
            self.leadSelectLandingTextFieldHight.constant = 0
            self.leadSelectLandingTextField.rightImage = nil
            self.leadSelectLandingTextField.text = ""
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    func showleadLandingSelectFrom(isShown: Bool) {
        if isShown {
            self.leadLandingSelectFromLblTopHeight.constant = 20
            self.leadLandingSelectFromLblHeight.constant = 20
            self.leadLandingSelectFromTextFieldHight.constant = 45
            self.leadLandingSelectFromTextField.rightImage = UIImage(named: "dropDown")
        } else {
            self.leadLandingSelectFromLblTopHeight.constant = 0
            self.leadLandingSelectFromLblHeight.constant = 0
            self.leadLandingSelectFromTextFieldHight.constant = 0
            self.leadLandingSelectFromTextField.rightImage = nil
            self.leadLandingSelectFromTextField.text = ""
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    func showleadSelectSource(isShown: Bool) {
        if isShown {
            self.showleadSourceTagButton.isSelected = true
            self.showleadSourceTagButtonHeight.constant = 25
            self.leadSelectSourceLblTopHeight.constant = 20
            self.leadSelectSourceLblHeight.constant = 20
            self.leadSelectSourceTextFieldHight.constant = 45
            self.leadSelectSourceTextField.rightImage = UIImage(named: "dropDown")
        } else {
            
            self.showleadSourceTagButton.isSelected = false
            self.showleadSourceTagButtonHeight.constant = 0
            self.leadSelectSourceLblTopHeight.constant = 0
            self.leadSelectSourceLblHeight.constant = 0
            self.leadSelectSourceTextFieldHight.constant = 0
            self.leadSelectSourceTextField.rightImage = nil
            self.leadSelectSourceTextField.text = ""
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    func showLeadStatusChange(isShown: Bool) {
        if isShown {
            self.addleadTagButtonTopHeight.constant = 16
            
            self.leadSTriggerWhenStatusTopeight.constant = 16
            self.leadSTriggerWhenStatusLblHeight.constant = 20
            
            self.leadInitialStatusFromLblTopHeight.constant = 16
            self.leadInitialStatusFromLblHeight.constant = 20
            self.leadInitialStatusTextFieldHight.constant = 45
            
            self.leadFinalStatusToLblHeight.constant = 16
            self.leadFinalStatusToLblTopHeight.constant = 20
            self.leadFinalStatusTextFieldHight.constant = 45
            
            self.leadInitialStatusTextField.rightImage = UIImage(named: "dropDown")
            self.leadFinalStatusTextField.rightImage = UIImage(named: "dropDown")
        } else {
            self.addleadTagButtonTopHeight.constant = 0
            
            self.leadSTriggerWhenStatusTopeight.constant = 0
            self.leadSTriggerWhenStatusLblHeight.constant = 0
            
            self.leadInitialStatusFromLblTopHeight.constant = 0
            self.leadInitialStatusFromLblHeight.constant = 0
            self.leadInitialStatusTextFieldHight.constant = 0
            
            self.leadFinalStatusToLblHeight.constant = 0
            self.leadFinalStatusToLblTopHeight.constant = 0
            self.leadFinalStatusTextFieldHight.constant = 0
            
            self.leadInitialStatusTextField.rightImage = nil
            self.leadFinalStatusTextField.rightImage = nil
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    func scrollToBottomView() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.triggerListInfoEdit.count-1, section: 0)
            self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func showleadTagTectField(isShown: Bool) {
        if isShown {
            self.leadTagTextFieldHight.constant = 45
            self.leadTagTextField.rightImage = UIImage(named: "dropDown")
        } else {
            self.leadTagTextFieldHight.constant = 0
            self.leadTagTextField.rightImage = nil
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
}
