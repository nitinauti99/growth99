//
//  VerifyForgotPasswordViewController.swift
//  Growth99
//
//  Created by nitin auti on 04/11/22.
//

import Foundation
import UIKit

protocol VerifyForgotPasswordViewProtocol: AnyObject {
    func LoaginDataRecived()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView.createBorderForView(redius: 10, width: 1)
        viewModel = VerifyForgotPasswordViewModel(delegate: self)
        self.subView.addBottomShadow(color: .gray)
        self.setUpUI()
    }
    
    func setUpUI(){
        self.continueButton.layer.cornerRadius = 12
        self.continueButton.clipsToBounds = true
        signUpLbl.updateHyperLinkText { _ in
            self.openRegistrationView()
        }
        signInLbl.updateHyperLinkText { _ in
            self.openLoginView()
        }
    }
    
    func LoaginDataRecived() {
        self.view.HideSpinner()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    @IBAction func sendRequestButton(sender: UIButton){
       
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.VerifyForgotPassword.emailEmptyError)
            return
        }
        guard let emailIsValid = viewModel?.isValidEmail(email), emailIsValid else {
            emailTextField.showError(message: Constant.VerifyForgotPassword.emailInvalidError)
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.showError(message: Constant.VerifyForgotPassword.passwordEmptyError)
            return
        }

        guard let passwordValidate = viewModel?.isValidPassword(password), passwordValidate else {
            passwordTextField.showError(message: Constant.VerifyForgotPassword.passwordInvalidError)
            return
        }

        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            confirmPasswordTextField.showError(message: Constant.VerifyForgotPassword.confirmPasswordEmptyError)
            return
        }
        
        guard let passwordValidate = viewModel?.isValidPasswordAndCoinfirmationPassword(password, confirmPassword), passwordValidate else {
            confirmPasswordTextField.showError(message: Constant.VerifyForgotPassword.PasswordMissmatchError)
            return
        }
        
        guard let veificationCode = veificationCodeTextField.text, !veificationCode.isEmpty else {
            veificationCodeTextField.showError(message: Constant.VerifyForgotPassword.ConfirmationCodeInvalidError)
            return
        }
        
         self.view.ShowSpinner()
         viewModel?.verifyForgotPasswordRequest(email: email, password: password, confirmPassword: confirmPassword, confirmationPCode: veificationCode)
    }
    
    func openRegistrationView(){
        let RVC = UIStoryboard(name: "RegistrationViewController", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController")
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    func openLoginView(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
