//
//  EditLeadViewController.swift
//  Growth99
//
//  Created by nitin auti on 05/12/22.
//

import UIKit

protocol EditLeadViewControllerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
    func updateLeadAmmountSaved()
    func updateLeadDadaRecived()
}

class EditLeadViewController: UIViewController, EditLeadViewControllerProtocol {
  
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
    
    func LeadDataRecived() {
        viewModel?.updateLeadAmmount(questionnaireId: LeadData?.id ?? 0, ammount: Int(ammountTextField.text ?? String.blank) ?? 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.navigationController?.popViewController(animated: true)
        })
        viewModel?.getLeadList(page: 0, size: 10, statusFilter: "", sourceFilter: "", search: "", leadTagFilter: "")
    }
    
    func updateLeadDadaRecived() {
        self.view.HideSpinner()
        NotificationCenter.default.post(name: Notification.Name("NotificationLeadList"), object: nil)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
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
    
    func updateLeadAmmountSaved() {
        
    }

    
    @IBAction func submitButtonClicked() {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            nameTextField.showError(message: Constant.CreateLead.firstNameEmptyError)
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: Constant.CreateLead.phoneNumberEmptyError)
            return
        }
        
        guard let phoneNumberIsValid = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberIsValid else {
            phoneNumberTextField.showError(message: Constant.CreateLead.phoneNumberInvalidError)
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.CreateLead.emailEmptyError)
            return
        }
        guard let emailIsValid = viewModel?.isValidEmail(email), emailIsValid else {
            emailTextField.showError(message: Constant.CreateLead.emailInvalidError)
            return
        }
                
        guard let ammount = ammountTextField.text, !ammount.isEmpty else {
            ammountTextField.showError(message: Constant.CreateLead.firstNameEmptyError)
            return
        }
        view.ShowSpinner()
        let id = Int(idTextField.text ?? String.blank) ?? 0
        viewModel?.updateLead(questionnaireId: id, name: nameTextField.text ?? String.blank, email: emailTextField.text ?? String.blank, phoneNumber: phoneNumberTextField.text ?? String.blank, leadStatus: leadStatusTextField.text ?? String.blank)
     }
}


