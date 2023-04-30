//
//  RegistrationViewController.swift
//  Growth99
//
//  Created by nitin auti on 10/10/22.
//

import UIKit

protocol RegistrationViewControllerProtocol: AnyObject {
    func LoaginDataRecived()
    func errorReceived(error: String)
}

class RegistrationViewController: UIViewController, RegistrationViewControllerProtocol {
   
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var regiistraionSignUpLbl: HyperLinkLabel!
    @IBOutlet weak var firsNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var repeatPasswordTextField: CustomTextField!
    @IBOutlet weak var bussinessNameTextField: CustomTextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var selectionButton: UIButton!

    @IBOutlet weak var hyperlinkTexview: UITextView!
    var viewModel: RegistrationViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        hyperlinkTexview.delegate = self
        viewModel = RegistrationViewModel(delegate: self)
        self.registrationView.createBorderForView()
        self.setUpUI()
        self.setupTexFieldValidstion()
    }

    func setUpUI(){
        self.registrationButton.layer.cornerRadius = 12
        self.registrationButton.clipsToBounds = true
        let attributedString = NSMutableAttributedString(string: Constant.ErrorMessage.privacyText)
        attributedString.setAttributes([.link: Constant.ErrorMessage.termsConditionsUrl], range: NSMakeRange(20, 18))
        attributedString.setAttributes([.link: Constant.ErrorMessage.privacyPolicyUrl], range: NSMakeRange(43, 14))
        self.hyperlinkTexview.attributedText = attributedString
        self.hyperlinkTexview.linkTextAttributes = [
            .foregroundColor: UIColor.init(hexString: "#009EDE"),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.boldSystemFont(ofSize: 13)
        ]
        regiistraionSignUpLbl.updateHyperLinkText { _ in
            self.openLogIInView()
        }
    }
    
    @IBAction func selectionButton(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
    
    func LoaginDataRecived() {
        self.view.HideSpinner()
        self.openLogIInView()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    private func setupTexFieldValidstion() {
        self.emailTextField.addTarget(self, action:
                                            #selector(self.textFieldDidChange(_:)),
                                         for: UIControl.Event.editingChanged)
        self.phoneNumberTextField.addTarget(self, action:
                                                #selector(self.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
        self.passwordTextField.addTarget(self, action:
                                                #selector(self.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
        self.repeatPasswordTextField.addTarget(self, action:
                                            #selector(self.textFieldDidChange(_:)),
                                         for: UIControl.Event.editingChanged)
    }
    
    @IBAction func registration(sender: UIButton){
        guard let firsName = firsNameTextField.text, !firsName.isEmpty else {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }

        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
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

        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            return
        }
        
        guard let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumber), phoneNumberValidate else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.showError(message: Constant.ErrorMessage.passwordEmptyError)
            return
        }

        guard let passwordValidate = viewModel?.isValidPassword(password), passwordValidate else {
            passwordTextField.showError(message: Constant.ErrorMessage.passwordInvalidError)
            return
        }

        guard let repeatPassword = repeatPasswordTextField.text, !repeatPassword.isEmpty else {
            repeatPasswordTextField.showError(message: Constant.ErrorMessage.repeatPasswordEmptyError)
            return
        }
        
//        guard let repeatPasswordValidate = viewModel?.isValidPassword(repeatPassword), repeatPasswordValidate else {
//            repeatPasswordTextField.showError(message: Constant.ErrorMessage.passwordInvalidError)
//            return
//        }
        guard let repeatPasswordValidate = passwordTextField.text, let password = repeatPasswordTextField.text, repeatPasswordValidate == password else {
             repeatPasswordTextField.showError(message: Constant.ErrorMessage.passwordMissmatchError)
             return
        }
        
        guard let bussinessName = bussinessNameTextField.text, !bussinessName.isEmpty else {
            bussinessNameTextField.showError(message: Constant.ErrorMessage.passwordEmptyError)
            return
        }
        
        self.view.ShowSpinner()
        viewModel?.registration(firstName: firsName, lastName: lastName, email: email, phoneNumber: phoneNumber, password: password, repeatPassword: repeatPassword, businesName: bussinessName, agreeTerms: true)
    }
    
    func openLogIInView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension RegistrationViewController: UITextViewDelegate {
   
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool
    {
        if (URL.absoluteString == Constant.ErrorMessage.termsConditionsUrl) {
            UIApplication.shared.open(URL)
        }
        if (URL.absoluteString == Constant.ErrorMessage.privacyPolicyUrl) {
            UIApplication.shared.open(URL)
        }
        return false
     }
}

extension RegistrationViewController: UITextFieldDelegate {
    
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
        
        if textField == emailTextField, let passwordValidate = viewModel?.isValidEmail(textField.text ?? String.blank), passwordValidate == false {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            return
        }
        
        if textField == phoneNumberTextField, let phoneNumberValidate = viewModel?.isValidPhoneNumber(textField.text ?? String.blank), phoneNumberValidate == false {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
            return
        }
        
        if textField == passwordTextField, let passwordValidate = viewModel?.isValidPassword(textField.text ?? String.blank), passwordValidate == false {
            passwordTextField.showError(message: Constant.ErrorMessage.passwordInvalidError)
            return
        }
        
        if textField == repeatPasswordTextField, let repeatPasswordValidate = repeatPasswordTextField.text, let passwordValidate = passwordTextField.text, repeatPasswordValidate !=  passwordValidate {
            repeatPasswordTextField.showError(message: Constant.ErrorMessage.passwordMissmatchError)
            return
        }
    }
}

