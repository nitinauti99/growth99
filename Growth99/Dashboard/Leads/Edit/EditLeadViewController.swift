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

    var LeadData: leadModel?
    var patientQuestionAnswers = Array<Any>()
    var viewModel: EditLeadViewModelProtocol?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = EditLeadViewModel(delegate: self)
        setUpUI()
    }
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    func LeadDataRecived() {
        view.HideSpinner()
        do {
            sleep(5)
        }
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("NotificationLeadList"), object: nil)
    }
    
    func errorReceived(error: String) {
        
    }
    
   private func setUpUI(){
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
    
    func updateLeadAmmountSaved() {
        let id = Int(idTextField.text ?? "") ?? 0
        viewModel?.updateLead(questionnaireId: id, name: nameTextField.text ?? "", email: emailTextField.text ?? "", phoneNumber: phoneNumberTextField.text ?? "", leadStatus: leadStatusTextField.text ?? "")
    }

    
    @IBAction func submitButtonClicked() {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            nameTextField.showError(message: Constant.CreateLead.firstNameEmptyError)
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
        
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: Constant.CreateLead.phoneNumberEmptyError)
            return
        }
        
        guard let phoneNumberIsValid = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberIsValid else {
            phoneNumberTextField.showError(message: Constant.CreateLead.phoneNumberInvalidError)
            return
        }
        
        guard let ammount = ammountTextField.text, !ammount.isEmpty else {
            ammountTextField.showError(message: Constant.CreateLead.firstNameEmptyError)
            return
        }
        view.ShowSpinner()
        viewModel?.updateLeadAmmount(questionnaireId: LeadData?.id ?? 0, ammount: Int(ammount) ?? 0)
    }
}
