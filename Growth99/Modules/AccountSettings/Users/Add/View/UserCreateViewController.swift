//
//  UserCreateViewController.swift
//  Growth99
//
//  Created by nitin auti on 24/12/22.
//

import UIKit

protocol UserCreateViewControllerProtocool {
    func userDataRecived()
    func errorReceived(error: String)
    func clinicsRecived()
    func serviceCategoriesRecived()
    func serviceRecived()
    func profileDataUpdated()
}

class UserCreateViewController: UIViewController,UserCreateViewControllerProtocool {
    @IBOutlet weak var firsNameTextField: CustomTextField!
    @IBOutlet weak var lastNameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var clincsTextField: CustomTextField!
    @IBOutlet private weak var servicesTextField: CustomTextField!
    @IBOutlet private weak var serviceCategoriesTextField: CustomTextField!
    @IBOutlet private weak var rolesTextField: CustomTextField!
    @IBOutlet private weak var degignationTextField: CustomTextField!
    
    @IBOutlet private weak var userProvider: UISwitch!
    @IBOutlet private weak var userProviderViewHight: NSLayoutConstraint!
    @IBOutlet private weak var userProviderView: UIView!
    @IBOutlet private weak var descriptionTextView: CustomTextView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = [Int]()
    
    var allServiceCategories = [Clinics]()
    var selectedServiceCategories = [Clinics]()
    var selectedServiceCategoriesIds = [Int]()
    
    var allService = [Clinics]()
    var selectedService = [Clinics]()
    var selectedServiceIds = [Int]()
    
    var viewModel: UserCreateViewModelProtocol?
    var roleArray: [String]?
    
    var screenTitle: String = Constant.Profile.homeScreen
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = UserCreateViewModel(delegate: self)
        self.userProviderViewHight.constant = 0
        self.userProviderView.isHidden = true
        self.setupTexFieldValidstion()
        self.title = Constant.Profile.createUser
        self.userProvider.setOn(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// get all user role
        self.view.ShowSpinner()
        self.viewModel?.getUserData(userId: UserRepository.shared.userId ?? 0)
    }
    
    fileprivate func setUpUI() {
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.clipsToBounds = true
        self.cancelButton.layer.cornerRadius = 12
        self.cancelButton.clipsToBounds = true
    }
    
    /// user Role recived
    func userDataRecived() {
        self.view.HideSpinner()
        self.rolesTextField.text = self.viewModel?.getUserProfileData.roles?.name ?? String.blank
        self.setUpUI()
    }
    
    func profileDataUpdated(){
        self.view.HideSpinner()
        self.view.showToast(message: "user created successfully", color: UIColor().successMessageColor())
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.openUserListView()
        })
    }
    
    @IBAction func switchIsChanged(sender: UISwitch) {
        if sender.isOn {
            self.userProviderViewHight.constant = 300
            self.userProviderView.isHidden = false
            self.view.layoutIfNeeded()
            self.clincsTextField.text = ""
            self.servicesTextField.text = ""
            self.serviceCategoriesTextField.text = ""
            /// only if user is provided then only calling api for clinics
            self.view.ShowSpinner()
            self.viewModel?.getallClinics()
        } else {
            self.userProviderViewHight.constant = 0
            self.userProviderView.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    /// recived all clincs
    func clinicsRecived() {
        self.allClinics = viewModel?.getAllClinicsData ?? []
        let selectedClincId = selectedClincs.map({$0.id ?? 0})
        self.selectedClincIds = selectedClincId
        self.view.HideSpinner()
        /// if only ServiceCategories is get called we have selcted clincs
        if self.selectedClincIds.count > 0 {
            self.view.ShowSpinner()
            self.viewModel?.getallServiceCategories(SelectedClinics: selectedClincId)
        }
    }
  
    /// recived ServiceCategories list for selected clinincs
    func serviceCategoriesRecived() {
        // get from user api
        self.allServiceCategories = viewModel?.getAllServiceCategories ?? []
        var itemNotPresent:Bool = false
        for item in selectedServiceCategories {
            if allServiceCategories.contains(item) {
                itemNotPresent =  true
            }
        }
        let selectedList = selectedServiceCategories.map({$0.id ?? 0})
        self.selectedServiceCategoriesIds = selectedList

        if selectedServiceCategories.count == 0 || itemNotPresent == false {
            self.serviceCategoriesTextField.text = ""
        }
        self.view.HideSpinner()
        
        /// call Service only if we have selected ServiceCategories
        if self.selectedServiceCategories.count > 0 {
            self.view.ShowSpinner()
            self.viewModel?.getallService(SelectedCategories: selectedList)

        }
    }
    
    func serviceRecived() {
        self.view.HideSpinner()
        // get from user api
        self.servicesTextField.text = ""
        self.allService = viewModel?.getAllService ?? []
        let selectedList = selectedService.map({$0.id ?? 0})
        self.selectedServiceIds = selectedList
    }
    
    @IBAction func openAdminMenuDropDwon(sender: UIButton) {
        self.rolesTextField.text = ""
        let rolesArray = [viewModel?.getUserProfileData.roles?.name]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics?.components(separatedBy: " ").first
            self.rolesTextField.text  = allClinics?.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            selectionMenu.dismissAutomatically = true
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func textFieldOpenDropDownClinincs(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = ""
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.clincsTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedClincIds = selectedId
            self?.selectedClincs  = selectedList
            self?.view.ShowSpinner()
            self?.viewModel?.getallServiceCategories(SelectedClinics: selectedId)
        }
        selectionMenu.reloadInputViews()
        
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allClinics.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func textFieldOpenDropDownServiceCategories(sender: UIButton) {
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allServiceCategories, cellType: .subTitle) { (cell, serviceCategories, indexPath) in
            cell.textLabel?.text = serviceCategories.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedServiceCategories) { [weak self] (selectedItem, index, selected, selectedList) in
            
            self?.serviceCategoriesTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedServiceCategoriesIds = selectedId
            self?.selectedServiceCategories = selectedList
            
            self?.view.ShowSpinner()
            self?.viewModel?.getallService(SelectedCategories: selectedId)
        }
        
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        if self.allServiceCategories.count >= 6 {
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allServiceCategories.count) * 44)), arrowDirection: .down), from: self)
        } else {
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allServiceCategories.count) * 44)), arrowDirection: .up), from: self)
        }
    }
    
    @IBAction func textFieldOpenDropDownServices(sender: UIButton) {
        if allService.count == 0 {
            self.servicesTextField.text = ""
        }
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allService, cellType: .subTitle) { (cell, allServices, indexPath) in
            cell.textLabel?.text = allServices.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: selectedService) { [weak self] (text, index, selected, selectedList) in
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedServiceIds = selectedId
            self?.selectedService = selectedList
            self?.servicesTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
        }
        selectionMenu.showEmptyDataLabel(text: "No Services Found")
        selectionMenu.cellSelectionStyle = .checkbox
        
        if self.allService.count >= 2 {
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allService.count) * 44)), arrowDirection: .down), from: self)
        }else{
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allService.count) * 44)), arrowDirection: .up), from: self)
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
    
    @IBAction func saveUserProfile() {
        if let textField = firsNameTextField,  textField.text == "" {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
            return
        }
        if let textField = lastNameTextField, textField.text == "" {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
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

        if let textField = phoneNumberTextField, textField.text == "" {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            return
        }
        if let textField = phoneNumberTextField, textField.text == "", let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumberTextField.text ?? String.blank), phoneNumberValidate == false {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
            return
        }
        
        self.view.ShowSpinner()
        viewModel?.updateProfileInfo(firstName: firsNameTextField.text ?? String.blank, lastName: lastNameTextField.text ?? String.blank, email: emailTextField.text ?? String.blank, phone: phoneNumberTextField.text ?? String.blank, roleId: Int(UserRepository.shared.Xtenantid ?? String.blank) ?? 0, designation: self.degignationTextField.text ?? String.blank, clinicIds: selectedClincIds, serviceCategoryIds: selectedServiceCategoriesIds, serviceIds: selectedServiceIds, isProvider: userProvider.isOn, description: descriptionTextView.text ?? String.blank)
    }
    
    @IBAction func cancelUserProfile(){
        self.openUserListView()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func openUserListView(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension UserCreateViewController: UITextFieldDelegate {
    
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if let textField = firsNameTextField, textField.text == "" {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
        }
        
        if let isFirstName =  self.viewModel?.isValidFirstName(self.firsNameTextField.text ?? ""), isFirstName == false  {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameInvalidError)
        }
        
        if textField == lastNameTextField, textField.text == "" {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
        }
        
        if let isLastName =  self.viewModel?.isValidLastName(self.lastNameTextField.text ?? ""), isLastName == false {
            self.lastNameTextField.showError(message: Constant.ErrorMessage.lastNameInvalidError)
        }
        
        if textField == phoneNumberTextField, textField.text == "" {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
        }
        if textField == phoneNumberTextField, let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumberTextField.text ?? String.blank), phoneNumberValidate == false {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
        }
    }
}
