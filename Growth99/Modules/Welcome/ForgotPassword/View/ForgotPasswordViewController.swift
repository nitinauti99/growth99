//
//  ForgotPasswordViewController.swift
//  Growth99
//
//  Created by nitin auti on 13/10/22.
//

import Foundation
import UIKit

protocol ForgotPasswordViewControllerProtocol: AnyObject {
    func userDataByemailRecived()
    func emailDataRecived()
    func userDoesNotExist()
    func errorReceived(error: String)
}

class ForgotPasswordViewController: UIViewController, ForgotPasswordViewControllerProtocol {
   
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var signUpLbl: HyperLinkLabel!
    @IBOutlet weak var signInLbl: HyperLinkLabel!
    @IBOutlet weak var sendRequestButton: UIButton!
    @IBOutlet weak var emailTextField: CustomTextField!
    var viewModel: ForgotPasswordViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.green
        self.subView.createBorderForView(redius: 10, width: 1)
        self.viewModel = ForgotPasswordViewModel(delegate: self)
        self.subView.addBottomShadow(color: .gray)
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailTextField.text = ""
    }
    
    func setUpUI(){
        self.sendRequestButton.layer.cornerRadius = 12
        self.sendRequestButton.clipsToBounds = true
//        signUpLbl.updateHyperLinkText { _ in
//            self.openRegistrationView()
//        }
        
        signInLbl.updateHyperLinkText { _ in
            self.openLoginView()
        }
    }
    
    func userDataByemailRecived() {
        self.view.HideSpinner()
        self.viewModel?.sendRequestGetPassword(email: emailTextField.text ?? String.blank)
    }
    
    func emailDataRecived() {
        self.view.HideSpinner()
        self.openVerifyPasswordView()
    }
    
    func userDoesNotExist(){
        self.view.HideSpinner()
        self.view.showToast(message: " The user with given email doesn't exist!", color: .red)
    }

    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
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
         self.view.ShowSpinner()
         self.viewModel?.sendRequestCheckEmailExist(email: emailTextField.text ?? String.blank)
    }
    
    func openVerifyPasswordView(){
        let verifyPVC = UIStoryboard(name: "VerifyForgotPasswordViewController", bundle: nil).instantiateViewController(withIdentifier: "VerifyForgotPasswordViewController") as! VerifyForgotPasswordViewController
        verifyPVC.email = self.emailTextField.text ?? ""
        self.navigationController?.pushViewController(verifyPVC, animated: true)
    }
    
    func openRegistrationView(){
        let RVC = UIStoryboard(name: "RegistrationViewController", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController")
        self.navigationController?.pushViewController(RVC, animated: true)
    }
    
    func openLoginView(){
        self.navigationController?.popViewController(animated: true)
    }
}
