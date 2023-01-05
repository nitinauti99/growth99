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
    
    private var menuVC = DrawerViewContoller()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VerifyForgotPasswordViewModel(delegate: self)
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        menuVC = sidemenuVC as! DrawerViewContoller
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        saveButton.layer.cornerRadius = 12
        cancelButton.layer.cornerRadius = 12
        self.navigationItem.title = Constant.Profile.changePasswordTitle
        navigationItem.leftBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "menu")
    }
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
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
            oldPasswordTextField.showError(message: Constant.ErrorMessage.oldPasswordEmptyError)
            return
        }

        guard let passwordValidate = viewModel?.isValidPassword(oldPassword), passwordValidate else {
            oldPasswordTextField.showError(message: Constant.ErrorMessage.oldPasswordEmptyError)
            return
        }

        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            newPasswordTextField.showError(message: Constant.ErrorMessage.passwordEmptyError)
            return
        }
        
        guard let verifyNewPassword = verifyPasswordTextField.text, !verifyNewPassword.isEmpty else {
            newPasswordTextField.showError(message: Constant.ErrorMessage.confirmPasswordEmptyError)
            return
        }
        
        guard let passwordValidate = viewModel?.isValidPasswordAndCoinfirmationPassword(newPassword, verifyNewPassword), passwordValidate else {
            verifyPasswordTextField.showError(message: Constant.ErrorMessage.PasswordMissmatchError)
            return
        }
         self.view.ShowSpinner()
        viewModel?.verifyChangePasswordRequest(email: "nitinauti99@gmail.com", oldPassword: oldPassword, newPassword: newPassword, verifyNewPassword: verifyNewPassword)
    }
    
    @IBAction func cancelPasswordButton(sender: UIButton) {
        
        
    }
}
