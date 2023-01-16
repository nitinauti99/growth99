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
    func errorReceived(error: String)
    func clinicsRecived()
    func serviceCategoriesRecived()
    func serviceRecived()
    func profileDataUpdated()
}

class HomeViewContoller: UIViewController, HomeViewContollerProtocol {
    
    @IBOutlet private weak var firsNameTextField: CustomTextField!
    @IBOutlet private weak var lastNameTextField: CustomTextField!
    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var phoneNumberTextField: CustomTextField!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var clincsTextField: CustomTextField!
    @IBOutlet private weak var servicesTextField: CustomTextField!
    @IBOutlet private weak var serviceCategoriesTextField: CustomTextField!
    @IBOutlet private weak var rolesTextField: CustomTextField!
    @IBOutlet private weak var degignationTextField: CustomTextField!
    
    @IBOutlet private weak var userProvider: UISwitch!
    @IBOutlet private weak var userProviderViewHight: NSLayoutConstraint!
    @IBOutlet private weak var userProviderView: UIView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
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
    
    var screenTitle: String = Constant.Profile.homeScreen
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        menuVC = sidemenuVC as! DrawerViewContoller
        
        viewModel = HomeViewModel(delegate: self)
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor;
        descriptionTextView.layer.borderWidth = 1.0;
        self.userProviderViewHight.constant = 0
        self.userProviderView.isHidden = true
        self.setupTexFieldValidstion()
        self.view.ShowSpinner()
        viewModel?.getUserData(userId: UserRepository.shared.userId ?? 0)
        if screenTitle == Constant.Profile.homeScreen {
            self.navigationItem.titleView = UIImageView.navigationBarLogo()
            self.navigationItem.leftBarButtonItem =
            UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "menu")
        } else {
            self.title = Constant.Profile.createUser
        }
    }
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
    }
    
    fileprivate func setUpUI() {
        if screenTitle == Constant.Profile.homeScreen {
            self.firsNameTextField.text = viewModel?.getUserProfileData.firstName
            self.lastNameTextField.text = viewModel?.getUserProfileData.lastName
            self.emailTextField.text = viewModel?.getUserProfileData.email
            self.phoneNumberTextField.text = viewModel?.getUserProfileData.phone
            self.degignationTextField.text = viewModel?.getUserProfileData.designation
            self.descriptionTextView.text = viewModel?.getUserProfileData.description
        } else {
            self.firsNameTextField.text = String.blank
            self.lastNameTextField.text = String.blank
            self.emailTextField.text = String.blank
            self.phoneNumberTextField.text = String.blank
            self.degignationTextField.text = String.blank
            self.descriptionTextView.text = String.blank
        }
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.clipsToBounds = true
        self.cancelButton.layer.cornerRadius = 12
        self.cancelButton.clipsToBounds = true
    }
    
    func userDataRecived() {
        viewModel?.getallClinics()
        userProvider.setOn(false, animated: false)
        if viewModel?.getUserProfileData.isProvider ?? false {
            userProvider.setOn(true, animated: false)
            self.userProviderViewHight.constant = 300
            self.userProviderView.isHidden = false
        }
        self.rolesTextField.text = viewModel?.getUserProfileData.roles?.name ?? ""
        setUpUI()
    }
    
    func clinicsRecived() {
        // get from user api
        selectedClincs = viewModel?.getUserProfileData.clinics ?? []
        
        /// get From allclinincsapi
        allClinics = viewModel?.getAllClinicsData ?? []
        
        self.clincsTextField.text = selectedClincs.map({$0.name ?? ""}).joined(separator: ", ")
        let selectedClincId = selectedClincs.map({$0.id ?? 0})
        self.selectedClincIds = selectedClincId
        self.viewModel?.getallServiceCategories(SelectedClinics: selectedClincId)
    }
    
    func serviceCategoriesRecived() {
        // get from user api
        selectedServiceCategories = viewModel?.getUserProfileData.userServiceCategories ?? []
        allServiceCategories = viewModel?.getAllServiceCategories ?? []
        
        var itemNotPresent:Bool = false
        for item in selectedServiceCategories {
            if allServiceCategories.contains(item) {
                itemNotPresent =  true
            }
        }
        self.serviceCategoriesTextField.text = selectedServiceCategories.map({$0.name ?? ""}).joined(separator: ", ")
        let selectedList = selectedServiceCategories.map({$0.id ?? 0})
        self.selectedServiceCategoriesIds = selectedList
        
        if selectedServiceCategories.count == 0 || itemNotPresent == false {
            self.serviceCategoriesTextField.text = ""
        }
        self.viewModel?.getallService(SelectedCategories: selectedList)
    }
    
    func serviceRecived() {
        self.view.HideSpinner()
        // get from user api
        self.servicesTextField.text = ""
        selectedService = viewModel?.getAllService ?? []
        allService = viewModel?.getUserProfileData.services ?? []
        
        let selectedList = selectedService.map({$0.id ?? 0})
        self.selectedServiceIds = selectedList
        self.servicesTextField.text = selectedService.map({$0.name ?? ""}).joined(separator: ", ")
    }
    
    func profileDataUpdated(){
        self.view.HideSpinner()
        self.view.showToast(message: "data updated successfully")
        self.openUserListView()
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
            self?.clincsTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
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
            
            self?.serviceCategoriesTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
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
            self?.servicesTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
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
    
    
    
    @IBAction func saveUserProfile(){
        self.view.ShowSpinner()
        viewModel?.updateProfileInfo(firstName: firsNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", email: emailTextField.text ?? "", phone: phoneNumberTextField.text ?? "", roleId: Int(UserRepository.shared.Xtenantid ?? "") ?? 0, designation: self.degignationTextField.text ?? "", clinicIds: selectedClincIds, serviceCategoryIds: selectedServiceCategoriesIds, serviceIds: selectedServiceIds, isProvider: userProvider.isOn, description: descriptionTextView.text ?? "")
    }
    
    @IBAction func cancelUserProfile(){
        self.openUserListView()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
    }
    
    func openUserListView(){
        let userListVC = UIStoryboard(name: "UserListViewContoller", bundle: nil).instantiateViewController(withIdentifier: "UserListViewContoller")
        self.navigationController?.pushViewController(userListVC, animated: true)
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == firsNameTextField,  textField.text == "" {
            firsNameTextField.showError(message: Constant.ErrorMessage.firstNameEmptyError)
        }
        if textField == lastNameTextField, textField.text == "" {
            lastNameTextField.showError(message: Constant.ErrorMessage.lastNameEmptyError)
        }
        if textField == phoneNumberTextField, textField.text == "" {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
        }
        if textField == phoneNumberTextField, let phoneNumberValidate = viewModel?.isValidPhoneNumber(phoneNumberTextField.text ?? ""), phoneNumberValidate == false {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberInvalidError)
        }
    }
}
