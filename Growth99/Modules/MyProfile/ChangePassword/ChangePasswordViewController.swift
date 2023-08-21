//
//  ChangePasswordViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import Foundation
import UIKit

class ChangePasswordViewController: UIViewController, VerifyForgotPasswordViewProtocol {
    
    var viewModel: VerifyForgotPasswordViewModelProtocol?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var oldPasswordTextField: CustomTextField!
    @IBOutlet weak var newPasswordTextField: CustomTextField!
    @IBOutlet weak var verifyPasswordTextField: CustomTextField!
    let user = UserRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VerifyForgotPasswordViewModel(delegate: self)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        saveButton.layer.cornerRadius = 12
        cancelButton.layer.cornerRadius = 12
        self.navigationItem.title = Constant.Profile.changePasswordTitle
    }
    
    func LoaginDataRecived(responseMessage: String) {
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
    
    @IBAction func savePasswordButton(sender: UIButton) {
        
        guard let oldPassword = oldPasswordTextField.text, !oldPassword.isEmpty else {
            oldPasswordTextField.showError(message: Constant.ErrorMessage.oldPasswordEmptyError)
            return
        }
        
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            newPasswordTextField.showError(message: "New password required")
            return
        }
        
        guard let passwordValid = viewModel?.isValidPassword(newPassword), passwordValid else {
            newPasswordTextField.showError(message: "Password must contain one small character, one upper case character, one number and one of (!, @, $). It must be minimum 8 characters long.")
            return
        }
        
        guard let verifyNewPassword = verifyPasswordTextField.text, !verifyNewPassword.isEmpty else {
            newPasswordTextField.showError(message: "Password must contain one small character, one upper case character, one number and one of (!, @, $). It must be minimum 8 characters long.")
            return
        }
        
        guard let passwordValidate = viewModel?.isValidPasswordAndCoinfirmationPassword(newPassword, verifyNewPassword), passwordValidate else {
            verifyPasswordTextField.showError(message: Constant.ErrorMessage.PasswordMissmatchError)
            return
        }
        self.view.ShowSpinner()
        viewModel?.verifyChangePasswordRequest(email: user.primaryEmailId ?? "", oldPassword: oldPassword, newPassword: newPassword, verifyNewPassword: verifyNewPassword)
    }
    
    @IBAction func cancelPasswordButton(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
