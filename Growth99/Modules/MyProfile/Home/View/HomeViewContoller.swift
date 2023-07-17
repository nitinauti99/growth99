//
//  HomeViewContoller.swift
//  Growth99
//
//  Created by nitin auti on 05/11/22.
//

import Foundation
import UIKit
import LocalAuthentication

protocol HomeViewContollerProtocol {
    func userDataRecived()
    func clinicsRecived()
    func serviceCategoriesRecived()
    func serviceRecived()
    func profileDataUpdated()
    func errorReceived(error: String)
}

class HomeViewContoller: UIViewController {
    
    @IBOutlet weak var firsNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var clincsTextField: CustomTextField!
    @IBOutlet weak var servicesTextField: CustomTextField!
    @IBOutlet weak var serviceCategoriesTextField: CustomTextField!
    @IBOutlet weak var rolesTextField: CustomTextField!
    @IBOutlet weak var degignationTextField: CustomTextField!
    
    @IBOutlet weak var userProvider: UISwitch!
    @IBOutlet weak var userProviderViewHight: NSLayoutConstraint!
    @IBOutlet weak var userProviderView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    private var menuVC = DrawerViewContoller()
    
    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = [Int]()
    
    var allServiceCategories = [Clinics]()
    var selectedServiceCategories = [Clinics]()
    var selectedServiceCategoriesIds = [Int]()
    
    var allService = [Clinics]()
    var selectedService = [Clinics]()
    var selectedServiceIds = [Int]()
    
    var viewModel: HomeViewModelProtocol?
    var roleArray: [String]?
    
    var userId: Int = 0
    var screenTitle: String = Constant.Profile.homeScreen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        self.menuVC = sidemenuVC as! DrawerViewContoller
        self.viewModel = HomeViewModel(delegate: self)
        self.navigationItem.titleView = UIImageView.navigationBarLogo()
        self.navigationItem.leftBarButtonItem =
        UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "sidemenu")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title =  Constant.Profile.homeScreen
        self.userProviderViewHight.constant = 0
        self.userProviderView.isHidden = true
        self.setupTexFieldValidstion()
        self.view.ShowSpinner()
        UserRepository.shared.screenTitle = "Profile"
        self.viewModel?.getUserData(userId: UserRepository.shared.userVariableId ?? 0)
    }
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
    }
    
    func setUpUI() {
        firsNameTextField.text = viewModel?.getUserProfileData.firstName
        lastNameTextField.text = viewModel?.getUserProfileData.lastName
        emailTextField.text = viewModel?.getUserProfileData.email
        phoneNumberTextField.text = viewModel?.getUserProfileData.phone ?? ""
        degignationTextField.text = viewModel?.getUserProfileData.designation
        descriptionTextView.text = viewModel?.getUserProfileData.description
        UserRepository.shared.primaryEmailId = viewModel?.getUserProfileData.email
    }
    
    
    @IBAction func switchIsChanged(sender: UISwitch) {
        if sender.isOn {
            self.userProviderViewHight.constant = 300
            self.userProviderView.isHidden = false
            if self.clincsTextField.text == "" {
                self.serviceCategoriesTextField.text = ""
                self.servicesTextField.text = ""
            }
            self.view.layoutIfNeeded()
        } else {
            self.userProviderViewHight.constant = 0
            self.userProviderView.isHidden = true
            self.view.layoutIfNeeded()
        }
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
    }
    
    @IBAction func cancelUserProfile(){
        self.openUserListView()
    }
    
    func openUserListView(){
        let userListVC = UIStoryboard(name: "UserListViewContoller", bundle: nil).instantiateViewController(withIdentifier: "UserListViewContoller")
        self.navigationController?.pushViewController(userListVC, animated: true)
    }
    
    @IBAction func saveUserProfile() {
        
        if let textField = firsNameTextField,  textField.text == "" {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }
        
        if let isFirstName =  self.viewModel?.isValidFirstName(self.firsNameTextField.text ?? ""), isFirstName == false  {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameInvalidError)
            return
        }
        
        if let textField = lastNameTextField, textField.text == "" {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
            return
        }
        if let isLastName =  self.viewModel?.isValidLastName(self.lastNameTextField.text ?? ""), isLastName == false {
            self.lastNameTextField.showError(message: Constant.ErrorMessage.lastNameInvalidError)
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.showError(message: Constant.ErrorMessage.emailEmptyError)
            return
        }
        
        guard let emailValidate = viewModel?.isValidEmail(email), emailValidate else {
            emailTextField.showError(message: Constant.ErrorMessage.emailInvalidError)
            return
        }
        
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            phoneNumberTextField.showError(message: "Phone Number is required")
            return
        }
        
        let characterCount = phoneNumber.count
        if characterCount < 10 {
            phoneNumberTextField.showError(message: "Phone Number should contain 10 digits")
        }
        
        if let textField = phoneNumberTextField, textField.text == "", let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumberTextField.text ?? String.blank), phoneNumberValidate == false {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
            return
        }
        
        if userProvider.isOn {
            if let textField = clincsTextField,  textField.text == "" {
                clincsTextField.showError(message: "Clinics are required.")
                return
            }
            
            if let textField = serviceCategoriesTextField,  textField.text == "" {
                serviceCategoriesTextField.showError(message: "Service Categories are required.")
                return
            }
            
            if let textField = servicesTextField,  textField.text == "" {
                servicesTextField.showError(message: "Services are required")
                return
            }
        }
        
        self.view.ShowSpinner()
        self.viewModel?.updateProfileInfo(firstName: firsNameTextField.text ?? String.blank, lastName: lastNameTextField.text ?? String.blank, email: emailTextField.text ?? String.blank, phone: phoneNumberTextField.text ?? "", roleId: (viewModel?.getUserProfileData.roles?.id ?? 0), designation: self.degignationTextField.text ?? String.blank, clinicIds: selectedClincIds, serviceCategoryIds: selectedServiceCategoriesIds, serviceIds: selectedServiceIds, isProvider: userProvider.isOn, description: descriptionTextView.text ?? String.blank)
    }
    
}
