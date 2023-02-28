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
    @IBOutlet weak var noteTextView: UITextView!

    
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
        self.title = Constant.Profile.createPatient
        dateFormater = DateFormater()
        noteTextView.layer.borderWidth = 1
        noteTextView.layer.borderColor = UIColor.gray.cgColor
        noteTextView.layer.cornerRadius = 5
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
        viewModel?.cratePateint(parameters: param)
     }
}
