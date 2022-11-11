//
//  ViewController.swift
//  Growth99
//
//  Created by nitin auti on 08/10/22.
//

import UIKit

protocol LogInViewControllerProtocol: AnyObject {
    func LoaginDataRecived()
    func errorReceived(error: String)
}

class LogInViewController: UIViewController, LogInViewControllerProtocol {
   
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var loginSignUpLbl: HyperLinkLabel!
    @IBOutlet weak var forgotPasswoardLbl: HyperLinkLabel!
    @IBOutlet weak var loginButton: UIButton!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var viewModel: LogInViewModelProtocol?
    let emailMessage = NSLocalizedString("Email is required.", comment: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginView.addBottomShadow(color: .gray,opacity: 0.5)
        self.viewModel = LogInViewModel(delegate: self)
        self.setupTexFieldValidstion()
        emailTextField.text = "nitinauti99@gmail.com"
        passwordTextField.text = "Password1@!"
        self.setUpUI()
    }

    func setUpUI(){
        self.loginButton.layer.cornerRadius = 12
        self.loginButton.clipsToBounds = true
        loginSignUpLbl.updateHyperLinkText { _ in
            self.openRegistrationView()
        }
        forgotPasswoardLbl.updateHyperLinkText { _ in
            self.openForgotPasswordView()
        }
    }
    
    func LoaginDataRecived() {
        self.view.HideSpinner()
        self.openHomeView()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    private func setupTexFieldValidstion() {
        self.emailTextField.addTarget(self, action:
                                            #selector(LogInViewController.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
        self.passwordTextField.addTarget(self, action:
                                            #selector(LogInViewController.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == emailTextField,  textField.text == "" {
            emailTextField.showError(message: Constant.Login.emailEmptyError)
        }
        
        if textField == passwordTextField, textField.text == "" {
            passwordTextField.showError(message: Constant.Login.passwordEmptyError)
        }

        if textField == emailTextField, textField.text != "" , let emailValidate = viewModel?.isValidEmail(emailTextField.text ?? ""), emailValidate == false {
            emailTextField.showError(message: Constant.Login.emailInvalidError)
        }
        
        if textField == passwordTextField, textField.text != "" , let passwrdValidate = viewModel?.isValidPassword(passwordTextField.text ?? ""), passwrdValidate == false {
            passwordTextField.showError(message: Constant.Login.passwordInvalidError)
        }
    }
 
    @IBAction func logIn(sender: UIButton){
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.Login.emailEmptyError)
            return
        }
        guard let emailIsValid = viewModel?.isValidEmail(email), emailIsValid else {
            emailTextField.showError(message: Constant.Login.emailInvalidError)
            return
        }

        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.showError(message: Constant.Login.passwordEmptyError)
            return
        }
        guard let passwordValid = viewModel?.isValidPassword(password), passwordValid else {
            passwordTextField.showError(message: Constant.Login.passwordInvalidError)
            return
        }
        self.view.ShowSpinner()
         viewModel?.loginValidate(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    @IBAction func showPassword(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            passwordTextField.isSecureTextEntry = true
        }else {
            passwordTextField.isSecureTextEntry = false
            sender.isSelected = true
        }
    }
    
    
    func openRegistrationView(){
        print("openRegistrationView")
        let registrationVC = UIStoryboard(name: "RegistrationViewController", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController")
        self.navigationController?.pushViewController(registrationVC, animated: true)
    }
    
    func openForgotPasswordView() {
        let firstname = UserRepository.shared.firstName
        let forgotPasswordVC = UIStoryboard(name: "ForgotPasswordViewController", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func openHomeView(){
        let drawerViewController = UIStoryboard(name: "DrawerViewContoller", bundle: nil).instantiateViewController(withIdentifier: "Drawer")
       
        let mainViewController = UIStoryboard(name: "HomeViewContoller", bundle: nil).instantiateViewController(withIdentifier: "HomeViewContoller")
        
        let navController = UINavigationController(rootViewController: mainViewController)
        appDel.drawerController.mainViewController = navController
        
        appDel.drawerController.drawerViewController = drawerViewController
       
        appDel.window?.rootViewController = appDel.drawerController
//      appDel.window?.makeKeyAndVisible()
    }
}

