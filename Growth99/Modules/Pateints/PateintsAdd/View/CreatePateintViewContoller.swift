//
//  CreatePateintViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import Foundation
import UIKit

protocol CreatePateintViewContollerProtocol: AnyObject {
    func pateintCreatedSuccessfully(responseMessage: String)
    func errorReceived(error: String)
}

class CreatePateintViewContoller: UIViewController {
   
    @IBOutlet weak var firsNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var genderTextField: CustomTextField!
    @IBOutlet weak var dateTextField: CustomTextField!
    @IBOutlet weak var addressLine1TextField: CustomTextField!
    @IBOutlet weak var addressLine2TextField: CustomTextField!
    @IBOutlet weak var cityTextField: CustomTextField!
    @IBOutlet weak var stateTextField: CustomTextField!
    @IBOutlet weak var countryTextField: CustomTextField!
    @IBOutlet weak var zipCodeTextField: CustomTextField!
    @IBOutlet weak var noteTextView: CustomTextView!
    @IBOutlet private weak var createdAtTextField: CustomTextField!
    @IBOutlet private weak var pateintListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var dateFormater : DateFormaterProtocol?
    var viewModel: CreatePateintViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreatePateintViewModel(delegate: self)
        self.title = Constant.Profile.createPatient
        dateFormater = DateFormater()
        dateTextField.tintColor = .clear
        dateTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
    }
    
    @objc func dateFromButtonPressed() {
        dateTextField.text = self.dateFormater?.dateFormatterStringBirthDate(textField: dateTextField)
    }

    @IBAction func cancelButtonClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func openGenderSelction(sender: UIButton) {
       let list =  ["Male","Female"]
       
       let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.genderTextField.text  = text
            selectionMenu.dismissAutomatically = true
         }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(list.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func cancelAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveAction(sender: UIButton) {
      
        guard let textField = firsNameTextField.text, !textField.isEmpty else {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }
        
        guard let firstName = firsNameTextField.text, let firstNameValidate = viewModel?.isFirstName(firstName), firstNameValidate else {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameInvalidError)
            return
        }
        
        guard let textField = lastNameTextField.text, !textField.isEmpty else  {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
            return
        }
        
        guard let lastName = lastNameTextField.text, let lastNameValidate = viewModel?.isLastName(lastName), lastNameValidate else {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameInvalidError)
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
            return
        }

        guard let emailValidate = viewModel?.isValidEmail(email), emailValidate else {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            return
        }
        
        guard let textField = phoneNumberTextField.text, !textField.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            return
         }
        
        guard let textField = phoneNumberTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(textField), phoneNumberValidate else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
            return
        }
        
        guard let textField = genderTextField.text,  !textField.isEmpty else  {
            genderTextField.showError(message: Constant.ErrorMessage.genderEmptyError)
            return
        }
        
        self.view.ShowSpinner()
        let param : [String: Any] = [
            "firstName": firsNameTextField.text ?? String.blank,
            "lastName": lastNameTextField.text ?? String.blank,
            "email": emailTextField.text ?? String.blank,
            "phone": phoneNumberTextField.text ?? String.blank,
            "gender": genderTextField.text ?? String.blank,
            "dateOfBirth": dateFormater?.localToServer(date: dateTextField.text ?? String.blank) ?? String.blank,
            "addressLine1": addressLine1TextField.text ?? String.blank,
            "addressLine2": addressLine2TextField.text ?? String.blank,
            "city": cityTextField.text ?? String.blank,
            "state": stateTextField.text ?? String.blank,
            "country": countryTextField.text ?? String.blank,
            "zipcode": zipCodeTextField.text ?? String.blank,
            "notes": noteTextView.text ?? String.blank,
            "username": emailTextField.text ?? String.blank
        ]
        self.viewModel?.cratePateint(parameters: param)
     }
    
}


extension CreatePateintViewContoller: CreatePateintViewContollerProtocol{
   
    func pateintCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
}
