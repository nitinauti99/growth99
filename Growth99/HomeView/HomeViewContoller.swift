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
    @IBOutlet weak var clincsTextField: CustomTextField!
    @IBOutlet weak var userProvider: UISwitch!
    @IBOutlet weak var userProviderViewHight: NSLayoutConstraint!
    @IBOutlet weak var userProviderView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!

    let appDel = UIApplication.shared.delegate as! AppDelegate
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)

    @IBOutlet weak var dropDown: DropDown!
    
    var viewModel: HomeViewModelProtocol?
    var roleArray: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel(delegate: self)
        self.userProviderViewHight.constant = 0
        self.userProviderView.isHidden = true
        self.view.ShowSpinner()
        self.setupTexFieldValidstion()
        viewModel?.getUserData(userId: UserRepository.shared.userId ?? 0)
        self.setUpMenuButton()
        dropDown.isSearchEnable = true
        dropDown.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
          }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.view.frame.origin.y = -keyboardHeight.height
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        self.view.frame.origin.y = 0
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
        userProvider.setOn(false, animated: false)
        if viewModel?.getUserProfileData.isProvider ?? false {
            userProvider.setOn(true, animated: false)
            self.userProviderViewHight.constant = 300
            self.userProviderView.isHidden = false
        }
        
        let name = viewModel?.getUserProfileData.roles?.name ?? ""
        let id = viewModel?.getUserProfileData.roles?.id ?? 0
        dropDown.optionArray = [name]
        dropDown.optionIds = [id]
        self.firsNameTextField.text = viewModel?.getUserProfileData.firstName
        self.lastNameTextField.text = viewModel?.getUserProfileData.lastName
        self.emailTextField.text = viewModel?.getUserProfileData.email
        self.phoneNumberTextField.text = viewModel?.getUserProfileData.phone
    }
    
    @IBAction func switchIsChanged(sender: UISwitch) {
        if sender.isOn {
            self.userProviderViewHight.constant = 300
            self.userProviderView.isHidden = false
            self.view.layoutIfNeeded()
        } else {
            self.userProviderViewHight.constant = 0
            self.userProviderView.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func textFieldOpenDropDown(_ textField: UITextField) {
        let greenColor = UIColor.green

        let greenAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Countries",
            titleFont           : boldFont,
            titleTextColor      : .white,
            titleBackground     : greenColor,
            searchBarFont       : regularFont,
            searchBarPlaceholder: "Search Countries",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : regularFont,
            doneButtonTitle     : "Okay",
            doneButtonColor     : greenColor,
            doneButtonFont      : boldFont,
            itemCheckedImage    : UIImage(named:"green_ic_checked"),
            itemUncheckedImage  : UIImage(named:"green_ic_unchecked"),
            itemColor           : .black,
            itemFont            : regularFont
        )
        let countries = ["India", "Bangladesh", "Sri-Lanka", "Japan", "United States", "United Kingdom", "United Arab Emirates"]
        let picker = YBTextPicker.init(with: countries, appearance: greenAppearance,
            onCompletion: { (selectedIndexes, selectedValues) in
             if selectedValues.count > 0 {
                var values = [String]()
                for index in selectedIndexes{
                    values.append(countries[index])
                }
                //self.btnCountyPicker.setTitle(values.joined(separator: ", "), for: .normal)
            }else {
               // self.btnCountyPicker.setTitle("Select Countries", for: .normal)
              }
            },
            onCancel: {
                print("Cancelled")
            }
        )
//        if let title = btnCountyPicker.title(for: .normal){
//            if title.contains(","){
//                picker.preSelectedValues = title.components(separatedBy: ", ")
//            }
//        }
        picker.allowMultipleSelection = true
        
        picker.show(withAnimation: .Fade)
    }
    
    private func setupTexFieldValidstion() {
        self.phoneNumberTextField.addTarget(self, action:
                                            #selector(HomeViewContoller.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
        self.lastNameTextField.addTarget(self, action:
                                            #selector(HomeViewContoller.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
        self.firsNameTextField.addTarget(self, action:
                                            #selector(HomeViewContoller.textFieldDidChange(_:)),
                                            for: UIControl.Event.editingChanged)
        self.clincsTextField.addTarget(self, action: #selector(HomeViewContoller.textFieldOpenDropDown(_:)), for: .touchDown)
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
