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

class UserCreateViewController: UIViewController {
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
    
    var allClinics = [Clinics]()
    var selectedClincs = [Clinics]()
    var selectedClincIds = [Int]()
    
    var allServiceCategories = [Clinics]()
    var selectedServiceCategories = [Clinics]()
    var selectedServiceCategoriesIds = [Int]()
    
    var allService = [Clinics]()
    var selectedService = [Clinics]()
    var selectedServiceIds = [Int]()
    
    var roleArray: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    fileprivate func setUpUI() {
        self.saveButton.layer.cornerRadius = 12
        self.saveButton.clipsToBounds = true
        self.cancelButton.layer.cornerRadius = 12
        self.cancelButton.clipsToBounds = true
    }
    
}
