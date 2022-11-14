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
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VerifyForgotPasswordViewModel(delegate: self)
        setUpUI()
    }
    
    func setUpUI() {
        setUpMenuButton()
        
        saveButton.layer.cornerRadius = 12
        cancelButton.layer.cornerRadius = 12
    }
    
    func setUpMenuButton() {
        navigationItem.leftBarButtonItems = UIBarButtonItem.createApplicationLogo(target: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem.createMenu(target: self, action: #selector(logoutUser))
    }
    
    @objc func logoutUser(){
        appDel.drawerController.setDrawerState(.opened, animated: true)
    }
    
    func LoaginDataRecived(responseMessage: String) {
        self.view.HideSpinner()
        self.view.showToast(message: responseMessage)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    @IBAction func savePasswordButton(sender: UIButton) {

        guard let oldPassword = oldPasswordTextField.text, !oldPassword.isEmpty else {
            oldPasswordTextField.showError(message: Constant.ChangePassword.oldPasswordEmptyError)
            return
        }

        guard let passwordValidate = viewModel?.isValidPassword(oldPassword), passwordValidate else {
            oldPasswordTextField.showError(message: Constant.ChangePassword.oldPasswordEmptyError)
            return
        }

        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            newPasswordTextField.showError(message: Constant.ChangePassword.newPasswordEmptyError)
            return
        }
        
        guard let verifyNewPassword = verifyPasswordTextField.text, !verifyNewPassword.isEmpty else {
            newPasswordTextField.showError(message: Constant.ChangePassword.confirmPasswordEmptyError)
            return
        }
        
        guard let passwordValidate = viewModel?.isValidPasswordAndCoinfirmationPassword(newPassword, verifyNewPassword), passwordValidate else {
            verifyPasswordTextField.showError(message: Constant.ChangePassword.passwordMissmatchError)
            return
        }
         self.view.ShowSpinner()
        viewModel?.verifyChangePasswordRequest(email: "nitinauti99@gmail.com", oldPassword: oldPassword, newPassword: newPassword, verifyNewPassword: verifyNewPassword)
    }
    
    @IBAction func cancelPasswordButton(sender: UIButton) {
        
        
    }
}