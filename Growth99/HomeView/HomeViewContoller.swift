//
//  HomeViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 05/11/22.
//

import Foundation
import UIKit

protocol HomeViewContollerProtocool {
    func userDataRecived()
    func errorReceived(error: String)
}

class HomeViewContoller: UIViewController, HomeViewContollerProtocool {
   
    @IBOutlet weak var firsNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    let appDel = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var dropDown: DropDown!
    var viewModel: HomeViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(delegate: self)
        self.view.ShowSpinner()
        viewModel?.getUserData(userId: UserRepository.shared.userId ?? 0)
        self.setUpMenuButton()
        dropDown.optionArray = ["Option 1", "Option 2", "Option 3", "Option 11", "Option 111", "Option 12", "Option 13"]
        dropDown.optionIds = [1,23,54,22]
        dropDown.isSearchEnable = true

        // Image Array its optional
       // dropDown.ImageArray = [👩🏻‍🦳,🙊,🥞]

        // The the Closure returns Selected Index and String
        dropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
          }
        
        //  UINavigationBar.appearance().backgroundColor = .green
        //  backgorund color with gradient
        //  or
        //  UINavigationBar.appearance().barTintColor = .green  // solid color
        //  UIBarButtonItem.appearance().tintColor = .magenta
        //  UINavigationBar.appearance().titleTextAttributes =        [NSAttributedString.Key.foregroundColor : UIColor.blue]
        //  UITabBar.appearance().barTintColor = .yellow
    }
    
    func setUpMenuButton(){
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "menu"), for: .normal)
        menuButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        menuButton.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        let BarButtonItem = UIBarButtonItem()
        BarButtonItem.customView = menuButton
        self.navigationItem.rightBarButtonItems = [BarButtonItem]
    }
    
    func userDataRecived() {
         self.view.HideSpinner()
         self.firsNameTextField.text = viewModel?.getUserProfileData.firstName
         self.lastNameTextField.text = viewModel?.getUserProfileData.lastName
         self.emailTextField.text = viewModel?.getUserProfileData.email
         self.phoneNumberTextField.text = viewModel?.getUserProfileData.phone
         self.phoneNumberTextField.addTarget(self, action: #selector(HomeViewContoller.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(HomeViewContoller.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
         self.firsNameTextField.addTarget(self, action: #selector(HomeViewContoller.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
       
        if textField == firsNameTextField,  textField.text == "" {
            firsNameTextField.showError(message: Constant.Registration.firstNameEmptyError)
        }
        
        if textField == lastNameTextField, textField.text == "" {
            lastNameTextField.showError(message: Constant.Registration.lastNameEmptyError)
        }
        
        if textField == phoneNumberTextField, textField.text == "" {
            phoneNumberTextField.showError(message: Constant.Registration.phoneNumberEmptyError)
         }
        
        if textField == phoneNumberTextField, let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumberTextField.text ?? ""), phoneNumberValidate == false {
            phoneNumberTextField.showError(message: Constant.Registration.phoneNumberInvalidError)
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
    }
    
    
    @objc func myTargetFunction(textField: UITextField) {
        print("touchDown for \(textField.tag)")
        dropDown?.showList()  // To show the Drop Down Menu

    }
    
    @objc func logoutUser(){
        appDel.drawerController.setDrawerState(.opened, animated: true)
    }
    
   @IBAction func openForgotPasswordView(){
        let forgotPasswordVC = UIStoryboard(name: "ForgotPasswordViewController", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController")
        self.navigationController?.pushViewController(forgotPasswordVC, animated: true)
    }
}

extension HomeViewContoller: UITextFieldDelegate {
   
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
  
}
