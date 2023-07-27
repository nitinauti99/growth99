//
//  TriggerEditDefaultTableViewCell.swift
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
    
    @IBOutlet weak var leadStatusChangeButton: UIButton!
    @IBOutlet weak var leadStatusChangeButtonTopHeight: NSLayoutConstraint!
    @IBOutlet weak var leadNextButton: UIButton!
    
    var isTriggerForLeadContain: Bool = false
    var isInitialStatusContain: String = ""
    var isFinalStatusContain: String = ""
    
    var indexPath = IndexPath()
    var tableView: UITableView?
    var selectedVC: UIViewController?
    var selectedLeadSources: [String] = []
    var selectedLeadLandingPages: [EditLandingPageNamesModel] = []
    var selectedleadForms: [EditLandingPageNamesModel] = []
    var selectedLeadSourceUrl = [LeadSourceUrlListModel]()
    var selectedLeadTags = [MassEmailSMSTagListModelEdit]()
    var triggerListInfoEdit = [TriggerEditDetailModel]()
    weak var delegate: TriggerLeadEdiTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(tableView: UITableView?, index: IndexPath, triggerListEdit: TriggerEditModel?, viewModel: TriggerEditDetailViewModelProtocol?, viewController: UIViewController) {
        self.indexPath = index
        self.tableView = tableView
        selectedVC = viewController
        var landingArray = [EditLandingPageNamesModel]()
        var formArray = [EditLandingPageNamesModel]()
        var sourceUrlArray = [LeadSourceUrlListModel]()
        var ledTagArray = [MassEmailSMSTagListModelEdit]()
        
        self.leadFromTextField.text = triggerListEdit?.triggerConditions?.joined(separator: ",")
        self.selectedLeadSources = triggerListEdit?.triggerConditions ?? []
        
        if triggerListEdit?.landingPages?.count ?? 0 > 0 {
            for landingItem in triggerListEdit?.landingPages ?? [] {
                let getLandingData = viewModel?.getLandingPageNamesDataEdit.filter({ $0.id == landingItem})
                for landingChildItem in getLandingData ?? [] {
                    let landArr = EditLandingPageNamesModel(name: landingChildItem.name ?? "", id: landingChildItem.id ?? 0)
                    landingArray.append(landArr)
                }
            }
            self.leadSelectLandingTextField.text = landingArray.map({$0.name ?? ""}).joined(separator: ",")
            self.selectedLeadLandingPages = landingArray
            self.showLeadSelectLanding(isShown: true)
        }
        
        if triggerListEdit?.forms?.count ?? 0 > 0 {
            for formsItem in triggerListEdit?.forms ?? [] {
                let getLandingForm = viewModel?.getTriggerQuestionnairesDataEdit.filter({ $0.id == formsItem})
                for landingChildItem in getLandingForm ?? [] {
                    let formArr = EditLandingPageNamesModel(name: landingChildItem.name ?? "", id: landingChildItem.id ?? 0)
                    formArray.append(formArr)
                }
            }
            self.leadLandingSelectFromTextField.text = formArray.map({$0.name ?? ""}).joined(separator: ",")
            self.selectedleadForms = formArray
            self.showleadLandingSelectFrom(isShown: true)
        }
        
        if triggerListEdit?.sourceUrls?.count ?? 0 > 0 {
            for formsItem in triggerListEdit?.sourceUrls ?? [] {
                let getLandingForm = viewModel?.getTriggerLeadSourceUrlDataEdit.filter({ $0.id == formsItem})
                for landingChildItem in getLandingForm ?? [] {
                    let soureUrlArr = LeadSourceUrlListModel(sourceUrl: landingChildItem.sourceUrl ?? "", id: landingChildItem.id ?? 0)
                    sourceUrlArray.append(soureUrlArr)
                }
            }
            self.leadSelectSourceTextField.text = sourceUrlArray.map({$0.sourceUrl ?? ""}).joined(separator: ",")
            self.selectedLeadSourceUrl = sourceUrlArray
            self.showleadSelectSource(isShown: true)
        }
        
        if triggerListEdit?.isTriggerForLeadStatus == true {
            self.leadStatusChangeButton.isSelected = true
            self.isInitialStatusContain = triggerListEdit?.fromLeadStatus ?? ""
            self.isFinalStatusContain = triggerListEdit?.toLeadStatus ?? ""
            self.isTriggerForLeadContain = triggerListEdit?.isTriggerForLeadStatus ?? false
            self.showLeadStatusChange(isShown: true)
            self.leadInitialStatusTextField.text = triggerListEdit?.fromLeadStatus ?? ""
            self.leadFinalStatusTextField.text = triggerListEdit?.toLeadStatus ?? ""
        }
    }
    
    @IBAction func showSelectSourceButtonAction(sender: UIButton) {
        sender.isSelected.toggle()
        leadSelectSourceTextFieldHight.constant = sender.isSelected ? 45 : 0
        leadSelectSourceTextField.rightImage = sender.isSelected ? UIImage(named: "dropDown") : nil
        leadSelectSourceTextField.text = sender.isSelected ? "" : ""
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    @IBAction func leadStatusChangeButtonAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let isSelected = sender.isSelected
        let constantHeight: CGFloat = isSelected ? 16 : 0
        let zeroConstant: CGFloat = 0
        let textFieldHeight: CGFloat = 45
        
        leadSTriggerWhenStatusTopeight.constant = constantHeight
        leadSTriggerWhenStatusLblHeight.constant = isSelected ? 20 : zeroConstant
        leadInitialStatusFromLblTopHeight.constant = constantHeight
        leadInitialStatusFromLblHeight.constant = isSelected ? 20 : zeroConstant
        leadInitialStatusTextFieldHight.constant = isSelected ? textFieldHeight : zeroConstant
        leadFinalStatusToLblHeight.constant = constantHeight
        leadFinalStatusToLblTopHeight.constant = isSelected ? 20 : zeroConstant
        leadFinalStatusTextFieldHight.constant = isSelected ? textFieldHeight : zeroConstant
        
        leadInitialStatusTextField.text = isSelected ? "" : nil
        leadInitialStatusTextField.rightImage = isSelected ? UIImage(named: "dropDown") : nil
        leadFinalStatusTextField.text = isSelected ? "" : nil
        leadFinalStatusTextField.rightImage = isSelected ? UIImage(named: "dropDown") : nil
        
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    func showLeadSelectLanding(isShown: Bool) {
        let constantValue: CGFloat = isShown ? 20 : 0
        self.leadSelectLandingLblTopHeight.constant = constantValue
        self.leadSelectLandingLblHeight.constant = constantValue
        self.leadSelectLandingTextFieldHight.constant = isShown ? 45 : 0
        
        if isShown {
            self.leadSelectLandingTextField.rightImage = UIImage(named: "dropDown")
        } else {
            self.leadSelectLandingTextField.rightImage = nil
            self.leadSelectLandingTextField.text = ""
        }
        
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    func showleadLandingSelectFrom(isShown: Bool) {
        self.leadLandingSelectFromLblTopHeight.constant = isShown ? 20 : 0
        self.leadLandingSelectFromLblHeight.constant = isShown ? 20 : 0
        self.leadLandingSelectFromTextFieldHight.constant = isShown ? 45 : 0
        self.leadLandingSelectFromTextField.rightImage = isShown ? UIImage(named: "dropDown") : nil
        self.leadLandingSelectFromTextField.text = isShown ? "" : nil
        
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    func showleadSelectSource(isShown: Bool) {
        self.showleadSourceTagButton.isSelected = isShown
        self.showleadSourceTagButtonHeight.constant = isShown ? 25 : 0
        self.leadSelectSourceLblTopHeight.constant = isShown ? 20 : 0
        self.leadSelectSourceLblHeight.constant = isShown ? 20 : 0
        self.leadSelectSourceTextFieldHight.constant = isShown ? 45 : 0
        self.leadSelectSourceTextField.rightImage = isShown ? UIImage(named: "dropDown") : nil
        self.leadSelectSourceTextField.text = isShown ? "" : nil
        
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    func showLeadStatusChange(isShown: Bool) {
        if isShown {
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
    
    @IBAction func leadInitialStatusButtonAction(sender: UIButton) {
        self.delegate?.leadInitialStatusButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func leadFinalStatusButtonAction(sender: UIButton) {
        self.delegate?.leadFinalStatusButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
}
