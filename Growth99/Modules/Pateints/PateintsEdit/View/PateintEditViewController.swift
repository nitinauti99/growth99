//
//  PateintEditViewController.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.

import Foundation
import UIKit

protocol PateintEditViewControllerProtocol: AnyObject {
    func pateintCreatedSuccessfully(responseMessage: String)
    func errorReceived(error: String)
    func recivedPateintDetail()
}

class PateintEditViewController: UIViewController,  PateintEditViewControllerProtocol {
    
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
    var viewModel: PateintEditViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [PateintListModel]()
    var pateintId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PateintEditViewModel(delegate: self)
        self.view.ShowSpinner()
        viewModel?.getPateintList(pateintId: pateintId)
        dateFormater = DateFormater()
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.gray.cgColor
        noteTextView.layer.cornerRadius = 5
        genderTextField.addTarget(self, action: #selector(openGenderSelction(_ : )), for: .touchDown)
        dateTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
    }
    
    @objc func dateFromButtonPressed() {
        dateTextField.text = self.dateFormater?.dateFormatterString(textField: dateTextField)
    }
    
    func recivedPateintDetail() {
        self.view.HideSpinner()
        self.setUPUI()
    }
    
    func setUPUI(){
        let item = viewModel?.pateintEditDetailData
        
        self.firsNameTextField.text = item?.firstName
        self.lastNameTextField.text = item?.lastName
        self.emailTextField.text = item?.email
        self.phoneNumberTextField.text = item?.phone
        self.genderTextField.text = item?.gender
        self.dateTextField.text = item?.dateOfBirth
        self.addressLine1TextField.text = item?.addressLine1
        self.addressLine2TextField.text = item?.addressLine2
        self.cityTextField.text = item?.city
        self.stateTextField.text = item?.state
        self.countryTextField.text = item?.country
        self.zipCodeTextField.text = item?.zipcode
        self.noteTextView.text = item?.notes

        self.phoneNumberTextField.addTarget(self, action:
                                                #selector(PateintEditViewController.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
        self.lastNameTextField.addTarget(self, action:
                                            #selector(PateintEditViewController.textFieldDidChange(_:)),
                                         for: UIControl.Event.editingChanged)
        self.firsNameTextField.addTarget(self, action:
                                            #selector(PateintEditViewController.textFieldDidChange(_:)),
                                         for: UIControl.Event.editingChanged)
        
        self.emailTextField.addTarget(self, action:
                                        #selector(PateintEditViewController.textFieldDidChange(_:)),
                                      for: UIControl.Event.editingChanged)
    }
    
    func pateintCreatedSuccessfully(responseMessage: String) {
        self.view.HideSpinner()
       self.view.showToast(message: responseMessage, color: .black)
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
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
        
        guard let textField = firsNameTextField.text,  !textField.isEmpty else {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }
        
        guard let textField = lastNameTextField.text, !textField.isEmpty else {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
            return
        }
        
        guard let textField  = genderTextField.text,  !textField.isEmpty else {
            genderTextField.showError(message: Constant.ErrorMessage.genderEmptyError)
            return
        }
        
        guard let textField  = phoneNumberTextField.text, !textField.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            return
        }
        
        guard let textField  = phoneNumberTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(textField), phoneNumberValidate == false, !textField.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
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

extension PateintEditViewController: UITextFieldDelegate  {
    
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
        
        guard let textField = firsNameTextField.text,  !textField.isEmpty else {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }
        
        guard let textField = lastNameTextField.text, !textField.isEmpty else {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
            return
        }
        
        guard let textField  = genderTextField.text,  !textField.isEmpty else {
            genderTextField.showError(message: Constant.ErrorMessage.genderEmptyError)
            return
        }
        
        guard let textField  = phoneNumberTextField.text, !textField.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            return
        }
        
        guard let textField  = phoneNumberTextField.text, let phoneNumberValidate = viewModel?.isValidPhoneNumber(textField), phoneNumberValidate == false, !textField.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
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
    }
}
