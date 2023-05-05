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
    func businessDetailReceived()
    func bussinessSelectionDataRecived()
}

class LogInViewController: UIViewController, LogInViewControllerProtocol,BussinessSelectionViewContollerProtocol {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var loginSignUpLbl: HyperLinkLabel!
    @IBOutlet weak var forgotPasswoardLbl: HyperLinkLabel!
    @IBOutlet weak var loginButton: UIButton!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var viewModel: LogInViewModelProtocol?
    let emailMessage = NSLocalizedString("Email is required.", comment: "")
    let user = UserRepository.shared
    var bussinessInfoData: bussinessDetailInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginView.addBottomShadow(color: .gray,opacity: 0.5)
        self.viewModel = LogInViewModel(delegate: self)
        self.setupTexFieldValidstion()
        self.setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.emailTextField.text = "harsha.shanir@yopmail.com"
//        self.passwordTextField.text = "Shanir@123"
    }
    
    private func setupTexFieldValidstion() {
        self.emailTextField.addTarget(self, action:
                                            #selector(LogInViewController.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
        self.passwordTextField.addTarget(self, action:
                                            #selector(LogInViewController.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
    }
    
    func setUpUI(){
        self.loginButton.layer.cornerRadius = 12
        self.loginButton.clipsToBounds = true
//        loginSignUpLbl.updateHyperLinkText { _ in
//            self.openRegistrationView()
//        }
        forgotPasswoardLbl.updateHyperLinkText { _ in
            self.openForgotPasswordView()
        }
    }
    
    func bussinessSelectionDataRecived() {
        let data = viewModel?.getBussinessSelcetionData ?? []
        if data.count == 0 {
            self.view.HideSpinner()
            return
        }
      
        if data.count == 1 {
            self.view.ShowSpinner()
            viewModel?.getBusinessInfo(Xtenantid: data[0].tenantId ?? 0)
        }else{
            self.view.HideSpinner()
            let BussinessSelectionVC = UIStoryboard(name: "BussinessSelectionViewController", bundle: nil).instantiateViewController(withIdentifier: "BussinessSelectionViewController") as! BussinessSelectionViewController
            BussinessSelectionVC.bussinessSelectionData = viewModel?.getBussinessSelcetionData ?? []
            BussinessSelectionVC.modalPresentationStyle = .overFullScreen
            BussinessSelectionVC.bussinessDelegate = self
            self.present(BussinessSelectionVC, animated: true)
        }
    }
    
    func bussinessSelectionDataRecived(data: BussinessSelectionModel){
        print(data)
        self.view.ShowSpinner()
        viewModel?.getBusinessInfo(Xtenantid: data.tenantId ?? 0)
    }

    func businessDetailReceived() {
        viewModel?.loginValidate(email: emailTextField.text ?? String.blank, password: passwordTextField.text ?? String.blank)
    }
    
    func LoaginDataRecived() {
        self.view.HideSpinner()
        self.openHomeView()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
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
        let forgotPasswordVC = UIStoryboard(name: "ForgotPasswordViewController", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
    
    func openHomeView(){
        guard let tabbarController = UIViewController.loadStoryboard("BaseTabbar", "tabbarScreen") as? BaseTabbarViewController else {
            fatalError("Failed to load BaseTabbarViewController from storyboard.")
        }
        self.view.window?.rootViewController = tabbarController
    }
 
    @IBAction func logIn(sender: UIButton){
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
        guard let passwordValid = viewModel?.isValidPassword(password), passwordValid else {
            passwordTextField.showError(message: Constant.ErrorMessage.passwordInvalidError)
            return
        }
        self.view.ShowSpinner()
        viewModel?.getBussinessSelection(email:emailTextField.text ?? String.blank)
    }
}

extension LogInViewController: UITextViewDelegate {

    @objc private func textFieldDidChange(_ textField: UITextField) {
        
        if textField == emailTextField,  textField.text == "" {
            emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
        }
        
        if textField == passwordTextField, textField.text == "" {
            passwordTextField.showError(message: Constant.ErrorMessage.passwordEmptyError)
        }

        if textField == emailTextField, textField.text != "" , let emailValidate = viewModel?.isValidEmail(emailTextField.text ?? String.blank), emailValidate == false {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
        }
        
        if textField == passwordTextField, textField.text != "" , let passwrdValidate = viewModel?.isValidPassword(passwordTextField.text ?? String.blank), passwrdValidate == false {
            passwordTextField.showError(message: Constant.ErrorMessage.passwordInvalidError)
        }
    }
}
