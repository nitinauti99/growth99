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
    func clinicsRecived()
    func serviceCategoriesRecived()
    func serviceRecived()
}

class HomeViewContoller: UIViewController, HomeViewContollerProtocool {
    
    @IBOutlet private weak var firsNameTextField: CustomTextField!
    @IBOutlet private weak var lastNameTextField: CustomTextField!
    @IBOutlet private weak var emailTextField: CustomTextField!
    @IBOutlet private weak var phoneNumberTextField: CustomTextField!
    @IBOutlet private weak var passwordTextField: CustomTextField!
    @IBOutlet private weak var clincsTextField: CustomTextField!
    @IBOutlet private weak var servicesTextField: CustomTextField!
    @IBOutlet private weak var serviceCategoriesTextField: CustomTextField!

    @IBOutlet private weak var userProvider: UISwitch!
    @IBOutlet private weak var userProviderViewHight: NSLayoutConstraint!
    @IBOutlet private weak var userProviderView: UIView!
    @IBOutlet private weak var descriptionTextView: UITextView!

    let appDel = UIApplication.shared.delegate as! AppDelegate
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)

    @IBOutlet weak var dropDown: DropDown!
    var selectedDataArray = [String]()
    var selectedId = [Any]()
    
    var selectedServiceCategoriesId = [Any]()
    var selectedServiceCategoriesName = [String]()

    var selectedServiceId = [Any]()
    var selectedServiceName = [String]()
    
    var viewModel: HomeViewModelProtocol?
    var roleArray: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItems = UIBarButtonItem.createApplicationLogo(target: self)
        viewModel = HomeViewModel(delegate: self)
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor;
        descriptionTextView.layer.borderWidth = 1.0;
        self.userProviderViewHight.constant = 0
        self.userProviderView.isHidden = true
        self.view.ShowSpinner()
        self.setupTexFieldValidstion()
        viewModel?.getUserData(userId: UserRepository.shared.userId ?? 0)
        self.setUpMenuButton()
        dropDown.isSearchEnable = true
        dropDown.didSelect{ (selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
        }
        
    }

    fileprivate func setUpUI() {
        self.firsNameTextField.text = viewModel?.getUserProfileData.firstName
        self.lastNameTextField.text = viewModel?.getUserProfileData.lastName
        self.emailTextField.text = viewModel?.getUserProfileData.email
        self.phoneNumberTextField.text = viewModel?.getUserProfileData.phone
    }
    
    func userDataRecived() {
        viewModel?.getallClinics()
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
        setUpUI()
    }
    
    func clinicsRecived() {
        let selectedClincs = viewModel?.getUserProfileData.clinics ?? []
        self.clincsTextField.text = selectedClincs.map({$0.name ?? ""}).joined(separator: ", ")
        let selectedList = selectedClincs.map({$0.id ?? 0})
        self.viewModel?.getallServiceCategories(SelectedClinics: selectedList)
    }
    
    func serviceCategoriesRecived() {
        let selectedCategories = viewModel?.getUserProfileData.userServiceCategories ?? []
        self.serviceCategoriesTextField.text = selectedCategories.map({$0.name ?? ""}).joined(separator: ", ")
        let selectedList = selectedCategories.map({$0.id ?? 0})
        self.viewModel?.getallService(SelectedCategories: selectedList)
    }
    
    func serviceRecived() {
        self.view.HideSpinner()
        let selectedCategories = viewModel?.getUserProfileData.services ?? []
        self.servicesTextField.text = selectedCategories.map({$0.name ?? ""}).joined(separator: ", ")
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
    
    func setUpMenuButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.createMenu(target: self, action: #selector(logoutUser))
    }
    
    @objc func logoutUser(){
        appDel.drawerController.setDrawerState(.opened, animated: true)
    }
    
    @IBAction func textFieldOpenDropDownClinincs(sender: UIButton) {
        
        let dataArray = viewModel?.getUserProfileData.clinics ?? []
        let allClinics = viewModel?.getAllClinicsData ?? []
  
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        
        selectionMenu.setSelectedItems(items: dataArray) { [weak self] (text, index, selected, selectedList) in
              self?.selectedDataArray = selectedList.map({$0.name ?? ""})
              self?.clincsTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
              let selectedIdArray = selectedList.map({$0.id ?? 0})
              self?.view.ShowSpinner()
              self?.viewModel?.getallServiceCategories(SelectedClinics: selectedIdArray)
         }
        
        selectionMenu.reloadInputViews()

        // search bar
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([Clinics]) in
            return allClinics.filter({ ($0.name)!.lowercased().starts(with: searchText.lowercased())})
        }
        selectionMenu.showEmptyDataLabel(text: "No Clinincs Found")
        selectionMenu.cellSelectionStyle = .checkbox
        // size = nil (auto adjust size)
        let count : Double = Double(allClinics.count)
        selectionMenu.preferredContentSize = CGSize(width: sender.frame.width, height: (count * 50 + 50))
        selectionMenu.show(style: .popover(sourceView: sender, size: nil), from: self)
    }

    
    @IBAction func textFieldOpenDropDownServiceCategories(sender: UIButton) {
       
        let serviceCategoriesSelected = viewModel?.getUserProfileData.userServiceCategories ?? []
        let serviceCategories = viewModel?.getAllServiceCategories ?? []
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: serviceCategories, cellType: .subTitle) { (cell, serviceCategories, indexPath) in
            cell.textLabel?.text = serviceCategories.name?.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: serviceCategoriesSelected) { [weak self] (text, index, selected, selectedList) in
            
          self?.selectedDataArray = selectedList.map({$0.name ?? ""})
          self?.serviceCategoriesTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
          let selectedIdArray = selectedList.map({$0.id ?? 0})
          self?.view.ShowSpinner()
            self?.viewModel?.getallService(SelectedCategories: selectedIdArray)
        }
        // search bar
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([Clinics]) in
            return serviceCategories.filter({ ($0.name)!.lowercased().starts(with: searchText.lowercased())})
        }
        selectionMenu.showEmptyDataLabel(text: "No ServiceCategories Found")
        selectionMenu.cellSelectionStyle = .checkbox
        // size = nil (auto adjust size)
        let count : Double = Double(serviceCategories.count)
        selectionMenu.preferredContentSize = CGSize(width: sender.frame.width, height: (count * 50 + 50))
        selectionMenu.show(style: .popover(sourceView: sender, size: nil), from: self)
    }
    
    @IBAction func textFieldOpenDropDownServices(sender: UIButton) {
        
        let servicesSelected = viewModel?.getUserProfileData.services ?? []
      
        let allServices = viewModel?.getAllService ?? []

        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allServices, cellType: .subTitle) { (cell, allServices, indexPath) in
            cell.textLabel?.text = allServices.name?.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: servicesSelected) { [weak self] (text, index, selected, selectedList) in
            self?.selectedDataArray =  selectedList.map({$0.name ?? ""})
            self?.servicesTextField.text = selectedList.map({$0.name ?? ""}).joined(separator: ", ")
        }
        // search bar
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([Clinics]) in
            return allServices.filter({ ($0.name)!.lowercased().starts(with: searchText.lowercased())})
        }
        selectionMenu.showEmptyDataLabel(text: "No Services Found")
        selectionMenu.cellSelectionStyle = .checkbox
        // size = nil (auto adjust size)
        let count : Double = Double(allServices.count)
        selectionMenu.preferredContentSize = CGSize(width: sender.frame.width, height: (count * 50 + 50))
        selectionMenu.show(style: .popover(sourceView: sender, size: nil), from: self)
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
//        self.clincsTextField.addTarget(self, action: #selector(HomeViewContoller.textFieldOpenDropDownClinincs(_:)), for: .touchDown)
        
//        self.serviceCategoriesTextField.addTarget(self, action: #selector(HomeViewContoller.textFieldOpenDropDownServiceCategories(_:)), for: .touchDown)
      
//        self.servicesTextField.addTarget(self, action: #selector(HomeViewContoller.textFieldOpenDropDownServices(_:)), for: .touchDown)
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
