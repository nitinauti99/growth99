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
        setUpUI()
        viewModel = HomeViewModel(delegate: self)
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
    
    func setUpUI() {
        navigationItem.leftBarButtonItems = UIBarButtonItem.createApplicationLogo(target: self)
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
    
    func userDataRecived() {
        viewModel?.getallClinics()

        //self.view.HideSpinner()
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
        self.selectedDataArray = ["Medical"]
        self.clincsTextField.text = viewModel?.getUserProfileData.clinics?[0].name
        let serviceCategoriesArray = viewModel?.getUserProfileData.userServiceCategories
       
        for serviceCategories in serviceCategoriesArray ?? [] {
            selectedServiceCategoriesName.append(serviceCategories.name ?? "")
        }
        self.serviceCategoriesTextField.text = selectedServiceCategoriesName.joined(separator: ", ")
       
        let servicesArray = viewModel?.getUserProfileData.services
       
        for serviceCategories in servicesArray ?? [] {
            selectedServiceName.append(serviceCategories.name ?? "")
        }
        self.servicesTextField.text = selectedServiceName.joined(separator: ", ")
    }
    
    func clinicsRecived() {
        self.view.HideSpinner()
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
        let dataArray = viewModel?.getUserProfileData.clinics ?? []
        let dataList =  dataArray.map({$0.name ?? ""})
        self.selectedDataArray = dataList
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: dataList, cellType: .subTitle) { (cell, name, indexPath) in
            cell.textLabel?.text = name.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: self.selectedDataArray) { [weak self] (text, index, selected, selectedList) in
            self?.selectedDataArray = selectedList
            self?.clincsTextField.text = selectedList.joined(separator: ", ")
          //  self?.addId()
         //   self?.removeId()
           // self?.tableView.reloadData()
          
        }
        // search bar
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([String]) in
            return dataList.filter({ $0.lowercased().starts(with: searchText.lowercased()) })
        }
        selectionMenu.showEmptyDataLabel(text: "No Player Found")
        selectionMenu.cellSelectionStyle = .checkbox
        // size = nil (auto adjust size)
        let count : Double = Double(dataArray.count)
        selectionMenu.preferredContentSize = CGSize(width: textField.frame.width, height: (count * 50 + 50))
        selectionMenu.show(style: .popover(sourceView: textField, size: nil), from: self)
    }
    
//    func addId() {
//        for clinics in self.dataArray {
//            if self.selectedDataArray.contains(clinics.name ?? "") {
//                selectedId.append(clinics.id ?? 0)
//            }
//        }
//    }
//    func removeId(){
//        for name in self.dataArray {
//            if self.selectedDataArray.contains(name.name ?? "") {
//                selectedId.append(name.id ?? 0)
//            }
//        }
//    }

    
    @objc func textFieldOpenDropDownServiceCategories(_ textField: UITextField) {
        let dataArray = viewModel?.getUserProfileData.userServiceCategories ?? []
        self.selectedDataArray = self.selectedServiceCategoriesName
        let dataList = dataArray.map({$0.name ?? ""})
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: dataList, cellType: .subTitle) { (cell, name, indexPath) in
            cell.textLabel?.text = name.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: self.selectedDataArray) { [weak self] (text, index, selected, selectedList) in
            self?.selectedDataArray = selectedList
            self?.serviceCategoriesTextField.text = selectedList.joined(separator: ", ")
            //self?.addId()
           // self?.removeId()
           // self?.tableView.reloadData()
          
        }
        // search bar
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([String]) in
            return dataList.filter({ $0.lowercased().starts(with: searchText.lowercased()) })
        }
        selectionMenu.showEmptyDataLabel(text: "No Player Found")
        selectionMenu.cellSelectionStyle = .checkbox
        // size = nil (auto adjust size)
        let count : Double = Double(dataArray.count)
        selectionMenu.preferredContentSize = CGSize(width: textField.frame.width, height: (count * 50 + 50))
        selectionMenu.show(style: .popover(sourceView: textField, size: nil), from: self)
    }
    
    @objc func textFieldOpenDropDownServices(_ textField: UITextField) {
        let dataArray = viewModel?.getUserProfileData.services ?? []
        self.selectedDataArray = self.selectedServiceName

        let dataList =  dataArray.map({$0.name ?? ""})
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: dataList, cellType: .subTitle) { (cell, name, indexPath) in
            cell.textLabel?.text = name.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: self.selectedDataArray) { [weak self] (text, index, selected, selectedList) in
            self?.selectedDataArray = selectedList
            self?.servicesTextField.text = selectedList.joined(separator: ", ")
           // self?.addId()
           // self?.removeId()
           // self?.tableView.reloadData()
          
        }
        // search bar
        selectionMenu.showSearchBar { [weak self] (searchText) -> ([String]) in
            return dataList.filter({ $0.lowercased().starts(with: searchText.lowercased()) })
        }
        selectionMenu.showEmptyDataLabel(text: "No Player Found")
        selectionMenu.cellSelectionStyle = .checkbox
        // size = nil (auto adjust size)
        let count : Double = Double(dataArray.count)
        selectionMenu.preferredContentSize = CGSize(width: textField.frame.width, height: (count * 50 + 50))
        selectionMenu.show(style: .popover(sourceView: textField, size: nil), from: self)
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
        
        self.serviceCategoriesTextField.addTarget(self, action: #selector(HomeViewContoller.textFieldOpenDropDownServiceCategories(_:)), for: .touchDown)
      
        self.servicesTextField.addTarget(self, action: #selector(HomeViewContoller.textFieldOpenDropDownServices(_:)), for: .touchDown)
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
