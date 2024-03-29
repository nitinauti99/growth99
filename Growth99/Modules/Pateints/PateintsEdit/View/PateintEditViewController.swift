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
        @IBOutlet weak var createdAtTextField: CustomTextField!
    @IBOutlet weak var pateintListTableView: UITableView!
    @IBOutlet weak var noteTextView: UITextView!
    
    var dateFormater: DateFormaterProtocol?
    var viewModel: PateintEditViewModelProtocol?
    var pateintId = Int()
    var isSearch : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PateintEditViewModel(delegate: self)
        self.title = Constant.Profile.editPatient
        self.view.ShowSpinner()
        viewModel?.getPateintList(pateintId: pateintId)
        dateFormater = DateFormater()
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.gray.cgColor
        noteTextView.layer.cornerRadius = 5
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
        let item = viewModel?.getPateintEditData
        self.firsNameTextField.text = item?.firstName
        self.lastNameTextField.text = item?.lastName
        self.emailTextField.text = item?.email
        self.phoneNumberTextField.text = item?.phone
        self.genderTextField.text = item?.gender
        self.dateTextField.text = dateFormater?.serverToLocalDate(date:item?.dateOfBirth ?? "")
        self.addressLine1TextField.text = item?.addressLine1
        self.addressLine2TextField.text = item?.addressLine2
        self.cityTextField.text = item?.city
        self.stateTextField.text = item?.state
        self.countryTextField.text = item?.country
        self.zipCodeTextField.text = item?.zipcode
        self.noteTextView.text = item?.notes
    }
    
    func setUPTextFieldAction(){
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
        viewModel?.updatePateintsDetail(patientsId: pateintId, parameters: param)
    }
}

