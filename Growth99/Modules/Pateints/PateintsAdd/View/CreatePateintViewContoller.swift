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

class CreatePateintViewContoller: UIViewController,  CreatePateintViewContollerProtocol {
   
    @IBOutlet private weak var firsNameTextField: CustomTextField!
    @IBOutlet private weak var lastNameTextField: CustomTextField!
    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var phoneNumberTextField: CustomTextField!
    @IBOutlet private weak var genderTextField: CustomTextField!
    @IBOutlet private weak var dateTextField: CustomTextField!
    @IBOutlet private weak var addressLine1TextField: CustomTextField!
    @IBOutlet private weak var addressLine2TextField: CustomTextField!
    @IBOutlet private weak var cityTextField: CustomTextField!
    @IBOutlet private weak var stateTextField: CustomTextField!
    @IBOutlet private weak var countryTextField: CustomTextField!
    @IBOutlet private weak var zipCodeTextField: CustomTextField!
    @IBOutlet private weak var noteTextView: UITextView!

    
    @IBOutlet private weak var createdAtTextField: CustomTextField!
    @IBOutlet private weak var pateintListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var dateFormater : DateFormaterProtocol?
    var viewModel: CreatePateintViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [PateintListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreatePateintViewModel(delegate: self)
        dateFormater = DateFormater()
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.gray.cgColor
        noteTextView.layer.cornerRadius = 5
        genderTextField.addTarget(self, action: #selector(openGenderSelction(_ : )), for: .touchDown)
        dateTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        self.setUPUI()

    }
    @objc func dateFromButtonPressed() {
        dateTextField.text = self.dateFormater?.dateFormatterString(textField: dateTextField)
    }
    
    func setUPUI(){
        self.phoneNumberTextField.addTarget(self, action:
                                                #selector(CreatePateintViewContoller.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
        self.lastNameTextField.addTarget(self, action:
                                            #selector(CreatePateintViewContoller.textFieldDidChange(_:)),
                                         for: UIControl.Event.editingChanged)
        self.firsNameTextField.addTarget(self, action:
                                            #selector(CreatePateintViewContoller.textFieldDidChange(_:)),
                                         for: UIControl.Event.editingChanged)
        self.emailTextField.addTarget(self, action:
                                        #selector(CreatePateintViewContoller.textFieldDidChange(_:)),
                                      for: UIControl.Event.editingChanged)
    }
    
    func pateintCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage)
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    @objc func openGenderSelction(_ textfield: UITextField) {
       let list =  ["Male","Female"]
       
       let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: list, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            self?.genderTextField.text  = text
            selectionMenu.dismissAutomatically = true
         }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: textfield, size: CGSize(width: textfield.frame.width, height: (Double(list.count * 44))), arrowDirection: .up), from: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
     }
    
    @IBAction func saveAction(sender: UIButton) {
      
        if let textField = firsNameTextField.text,  textField == "" {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
        }
        
        if let textField = lastNameTextField.text, textField == "" {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
        }
        
        if let textField = genderTextField.text,  textField == "" {
            genderTextField.showError(message: Constant.ErrorMessage.genderEmptyError)
        }
        
        if let textField = phoneNumberTextField.text, textField == "" {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
         }
        
        if let textField = phoneNumberTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(textField), phoneNumberValidate == false {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
            return
        }

        guard let emailValidate = viewModel?.isValidEmail(email), emailValidate else {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            return
        }
        
        self.view.ShowSpinner()
        let param : [String: Any] = [
            "firstName": firsNameTextField.text ?? "",
            "lastName": lastNameTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "phone": phoneNumberTextField.text ?? "",
            "gender": genderTextField.text ?? "",
            "dateOfBirth": dateFormater?.localToServer(date: dateTextField.text ?? "") ?? "",
            "addressLine1": addressLine1TextField.text ?? "",
            "addressLine2": addressLine2TextField.text ?? "",
            "city": cityTextField.text ?? "",
            "state": stateTextField.text ?? "",
            "country": countryTextField.text ?? "",
            "zipcode": zipCodeTextField.text ?? "",
            "notes": noteTextView.text ?? "",
            "username": emailTextField.text ?? ""
        ]
        viewModel?.cratePateint(parameters: param)
     }
}

extension CreatePateintViewContoller: UITextFieldDelegate  {
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = Int()
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        
        if  textField == phoneNumberTextField {
            maxLength = 10
            phoneNumberTextField.hideError()
            return newString.length <= maxLength
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let firsName = firsNameTextField.text,  firsName == "" {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }
       
        if let firstName  = firsNameTextField.text, let firstNameValidate = viewModel?.isValid(testStr: firstName), firstNameValidate == false {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameInvalidError)
            return
        }
        
        if let lastName = lastNameTextField.text, lastName == "" {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
            return
        }
        
        if let lastName  = lastNameTextField.text, let lastNameValidate = viewModel?.isValid(testStr: lastName), lastNameValidate == false {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameInvalidError)
            return
        }
        
        guard let emailText = emailTextField.text, !emailText.isEmpty else {
            emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
            return
        }
        
        guard let emailValidate = viewModel?.isValidEmail(emailText), emailValidate else {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            return
        }
        
        guard let phoneNumber  = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            return
        }
        
        guard let phoneNumber  = phoneNumberTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberValidate == false else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
            return
        }
        
        guard let gender  = genderTextField.text,  !gender.isEmpty else {
            genderTextField.showError(message: Constant.ErrorMessage.genderEmptyError)
            return
        }
       
    }
}
