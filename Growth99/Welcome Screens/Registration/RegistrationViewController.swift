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
            self.selectionButton.setImage(UIImage(named: "tickselected"), for: .selected)
            sender.isSelected = false
        }else{
            self.selectionButton.setImage(UIImage(named: "tickdefault"), for: .normal)
            sender.isSelected = true
        }
    }
    
    func LoaginDataRecived() {
        self.view.HideSpinner()
        self.openLogIInView()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
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

        guard let bussinessName = bussinessNameTextField.text, !bussinessName.isEmpty else {
            bussinessNameTextField.showError(message: Constant.ErrorMessage.passwordEmptyError)
            return
        }
        self.view.ShowSpinner()
        viewModel?.registration(firstName: firsName, lastName: lastName, email: email, phoneNumber: phoneNumber, password: password, repeatPassword: repeatPassword, businesName: bussinessName, agreeTerms: true)
    }
    
    func openLogIInView(){
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
