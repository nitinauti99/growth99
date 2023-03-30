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
        UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "menu")
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
    
    fileprivate func setUpUI() {
        firsNameTextField.text = viewModel?.getUserProfileData.firstName
        lastNameTextField.text = viewModel?.getUserProfileData.lastName
        emailTextField.text = viewModel?.getUserProfileData.email
        phoneNumberTextField.text = viewModel?.getUserProfileData.phone?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        degignationTextField.text = viewModel?.getUserProfileData.designation
        descriptionTextView.text = viewModel?.getUserProfileData.description
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
        guard let contactNumber = phoneNumberTextField.text, !contactNumber.isEmpty else {
            phoneNumberTextField.showError(message: Constant.ErrorMessage.phoneNumberEmptyError)
            return
        }
        
        self.view.ShowSpinner()
        viewModel?.updateProfileInfo(firstName: firsNameTextField.text ?? String.blank, lastName: lastNameTextField.text ?? String.blank, email: emailTextField.text ?? String.blank, phone: contactNumber, roleId: (viewModel?.getUserProfileData.roles?.id ?? 0), designation: self.degignationTextField.text ?? String.blank, clinicIds: selectedClincIds, serviceCategoryIds: selectedServiceCategoriesIds, serviceIds: selectedServiceIds, isProvider: userProvider.isOn, description: descriptionTextView.text ?? String.blank)
    }
    
    @IBAction func cancelUserProfile(){
        self.openUserListView()
    }
    
    func openUserListView(){
       
        let userListVC = UIStoryboard(name: "UserListViewContoller", bundle: nil).instantiateViewController(withIdentifier: "UserListViewContoller")
        self.navigationController?.pushViewController(userListVC, animated: true)
    }
    
}

extension HomeViewContoller: HomeViewContollerProtocol{
 
    func userDataRecived() {
        self.viewModel?.getallClinics()
        userProvider.setOn(false, animated: false)
        if viewModel?.getUserProfileData.isProvider ?? false {
            userProvider.setOn(true, animated: false)
            self.userProviderViewHight.constant = 300
            self.userProviderView.isHidden = false
        }
        self.rolesTextField.text = viewModel?.getUserProfileData.roles?.name ?? String.blank
        self.setUpUI()
    }
    
    func clinicsRecived() {
        self.view.HideSpinner()
        // get from user api
        selectedClincs = viewModel?.getUserProfileData.clinics ?? []
        
        /// get From allclinincsapi
        self.allClinics = viewModel?.getAllClinicsData ?? []
        
        self.clincsTextField.text = selectedClincs.map({$0.name ?? String.blank}).joined(separator: ", ")
        let selectedClincId = selectedClincs.map({$0.id ?? 0})
        self.selectedClincIds = selectedClincId
        if self.selectedClincIds.count > 0 {
            self.view.ShowSpinner()
            self.viewModel?.getallServiceCategories(SelectedClinics: selectedClincId)
        }
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
        self.serviceCategoriesTextField.text = selectedServiceCategories.map({$0.name ?? String.blank}).joined(separator: ", ")
        let selectedList = selectedServiceCategories.map({$0.id ?? 0})
        self.selectedServiceCategoriesIds = selectedList
        
        if selectedServiceCategories.count == 0 || itemNotPresent == false {
            self.serviceCategoriesTextField.text = ""
        }
        self.view.HideSpinner()

        if self.selectedServiceCategories.count > 0 {
            self.view.ShowSpinner()
            self.viewModel?.getallService(SelectedCategories: selectedList)
        }
    }
    
    func serviceRecived() {
        self.view.HideSpinner()
        // get from user api
        self.servicesTextField.text = ""
        selectedService =  viewModel?.getUserProfileData.services ?? []
        allService = viewModel?.getAllService ?? []
        
        let selectedList = selectedService.map({$0.id ?? 0})
        self.selectedServiceIds = selectedList
        self.servicesTextField.text = selectedService.map({$0.name ?? String.blank}).joined(separator: ", ")
    }
    
    func profileDataUpdated(){
        self.view.HideSpinner()
        self.view.showToast(message: "user updated successfully", color: .systemGreen)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.openUserListView()
        })
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
    
}
