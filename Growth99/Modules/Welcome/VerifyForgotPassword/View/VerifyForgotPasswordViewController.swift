//
//  VerifyForgotPasswordViewController.swift
//  Growth99
//
//  Created by nitin auti on 04/11/22.
//

import Foundation
import UIKit

protocol VerifyForgotPasswordViewProtocol: AnyObject {
    func LoaginDataRecived(responseMessage: String)
    func errorReceived(error: String)
    
}

class VerifyForgotPasswordViewController: UIViewController, VerifyForgotPasswordViewProtocol {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var signUpLbl: HyperLinkLabel!
    @IBOutlet weak var signInLbl: HyperLinkLabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var veificationCodeTextField: CustomTextField!

    var viewModel: VerifyForgotPasswordViewModelProtocol?
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView.createBorderForView(redius: 10, width: 1)
        self.viewModel = VerifyForgotPasswordViewModel(delegate: self)
        self.subView.addBottomShadow(color: .gray)
        self.setUpUI()
    }
    
    func setUpUI(){
        self.continueButton.layer.cornerRadius = 12
        self.continueButton.clipsToBounds = true
        self.emailTextField.text = email
        signUpLbl.updateHyperLinkText { _ in
            self.openRegistrationView()
        }
        signInLbl.updateHyperLinkText { _ in
            self.openLoginView()
        }
    }
    
    func LoaginDataRecived(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage, color: .systemGreen)
        self.navigationController?.popViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
    @IBAction func sendRequestButton(sender: UIButton){
       
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
            return
        }
        guard let emailIsValid = viewModel?.isValidEmail(email), emailIsValid else {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
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

        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            confirmPasswordTextField.showError(message: Constant.ErrorMessage.confirmPasswordEmptyError)
            return
        }
        
        guard let passwordValidate = viewModel?.isValidPasswordAndCoinfirmationPassword(password, confirmPassword), passwordValidate else {
            confirmPasswordTextField.showError(message: Constant.ErrorMessage.PasswordMissmatchError)
            return
        }
        
        guard let veificationCode = veificationCodeTextField.text, !veificationCode.isEmpty else {
            veificationCodeTextField.showError(message: Constant.ErrorMessage.ConfirmationCodeInvalidError)
            return
        }
        
        self.view.ShowSpinner()
        self.viewModel?.verifyForgotPasswordRequest(email: email, password: password, confirmPassword: confirmPassword, confirmationPCode: veificationCode)
    }
    
    func openRegistrationView(){
        let RVC = UIStoryboard(name: "RegistrationViewController", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController")
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    func openLoginView(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
