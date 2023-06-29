//
//  EditLeadViewController.swift
//  Growth99
//
//  Created by nitin auti on 05/12/22.
//

import UIKit

protocol EditLeadViewControllerProtocol: AnyObject {
    func LeadDataRecived(message: String)
    func errorReceived(error: String)
    func updateLeadAmmountSaved()
    func updateLeadDadaRecived()
}

class EditLeadViewController: UIViewController {
  
    @IBOutlet weak var idTextField: CustomTextField!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var ammountTextField: CustomTextField!
    @IBOutlet weak var sourceTextField: CustomTextField!
    @IBOutlet weak var leadStatusTextField: CustomTextField!

    @IBOutlet weak var saveButton : UIButton!
    @IBOutlet weak var CancelButton : UIButton!

    var LeadData: leadListModel?
    var patientQuestionAnswers = Array<Any>()
    var viewModel: EditLeadViewModelProtocol?
    var LeadId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = EditLeadViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Constant.Profile.editLead
        setUpUI()
    }
    
    @IBAction func closeButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
   
    
   private func setUpUI() {
       saveButton.roundCorners(corners: [.allCorners], radius: 10)
       CancelButton.roundCorners(corners: [.allCorners], radius: 10)
       idTextField.text = "\(LeadData?.id ?? 0)"
       nameTextField.text = LeadData?.fullName
       phoneNumberTextField.text = LeadData?.PhoneNumber
       emailTextField.text = LeadData?.Email
       ammountTextField.text = "\(LeadData?.amount ?? 0)"
       leadStatusTextField.text = LeadData?.leadStatus
       sourceTextField.text = LeadData?.leadSource

    }
    
    @IBAction func textFieldDidChange(sender: UIButton) {
        let leadStatusArray = ["NEW","COLD","WARM","HOT","WON","DEAD"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.leadStatusTextField.text = selectedItem
        }
        selectionMenu.reloadInputViews()
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadStatusArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func submitButtonClicked() {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            nameTextField.showError(message: Constant.ErrorMessage.nameEmptyError)
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            return
        }
        
        guard let phoneNumberIsValid = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberIsValid else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
            return
        }
        guard let emailIsValid = viewModel?.isValidEmail(email), emailIsValid else {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            return
        }
                
        
        view.ShowSpinner()
        let id = Int(idTextField.text ?? String.blank) ?? 0
        viewModel?.updateLead(questionnaireId: id, name: nameTextField.text ?? String.blank, email: emailTextField.text ?? String.blank, phoneNumber: phoneNumberTextField.text ?? String.blank, leadStatus: leadStatusTextField.text ?? String.blank)
     }
}



extension EditLeadViewController: EditLeadViewControllerProtocol {
    
    func LeadDataRecived(message: String) {
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        viewModel?.updateLeadAmmount(questionnaireId: LeadData?.id ?? 0, ammount: Int(ammountTextField.text ?? String.blank) ?? 0)
      
        //viewModel?.getLeadList(page: 0, size: 10, statusFilter: "", sourceFilter: "", search: "", leadTagFilter: "")
    }
    
    func updateLeadAmmountSaved() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateLeadDadaRecived() {
        self.view.HideSpinner()
        NotificationCenter.default.post(name: Notification.Name("NotificationLeadList"), object: nil)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}
