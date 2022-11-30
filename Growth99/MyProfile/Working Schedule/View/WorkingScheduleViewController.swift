//
//  WorkingScheduleViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

protocol WorkingScheduleViewControllerCProtocol: AnyObject {
    func apiResponseRecived(apiResponse: ResponseModel)
    func wcListResponseRecived(apiResponse: [VacationsListModel])
    func apiErrorReceived(error: String)
}

class WorkingScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorkingScheduleViewControllerCProtocol {

    @IBOutlet private weak var userNameTextField: CustomTextField!
    @IBOutlet private weak var clinicTextView: UIView!
    @IBOutlet private weak var clinicTextLabel: UILabel!
    @IBOutlet weak var clinicSelectonButton: UIButton!
    @IBOutlet weak var listExpandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var clinicSelectionTableView: UITableView!
    @IBOutlet weak var aulaSeparator: UIView!

    private var menuVC = DrawerViewContoller()
    var listSelection: Bool = false
    var allClinicsForWorkingSchedule: [Clinics]?
    var selectedClinicId: Int = 0
    var workingScheduleViewModel = WorkingScheduleViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listExpandHeightConstraint.constant = 31
        self.aulaSeparator.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        menuVC = sidemenuVC as! DrawerViewContoller
        setUpNavigationBar()
        setupUI()
    }
    
    func setupUI() {
        
        userNameTextField?.text = "\(UserRepository.shared.firstName ?? String.blank) \(UserRepository.shared.lastName ?? String.blank)"
        userNameTextField.isUserInteractionEnabled = false
        clinicTextView.layer.cornerRadius = 4.5
        clinicTextView.layer.borderWidth = 1
        clinicTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        clinicSelectionTableView.register(UINib(nibName: "DropDownCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "DropDownCustomTableViewCell")
        getDataDropDown()
    }
    
    func getDataDropDown() {
        self.view.ShowSpinner()
        workingScheduleViewModel.getallClinicsforWorkingSchedule { (response, error) in
            if error == nil && response != nil {
                self.view.HideSpinner()
                self.allClinicsForWorkingSchedule = response
                self.clinicTextLabel.text = self.allClinicsForWorkingSchedule?[0].name ?? String.blank
                self.clinicSelectionTableView.reloadData()
            } else {
                self.view.HideSpinner()
            }
        }
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.workingScheduleTitle
        navigationItem.leftBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "menu")
    }
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
    }
    
    @IBAction func clinicSelectionButton(sender: UIButton) {
        // need to work this logic
        if listSelection == true {
            hideClinicDropDown()
        } else {
            showClinicDropDown()
        }
    }
    
    func hideClinicDropDown() {
        listSelection = false
        self.listExpandHeightConstraint.constant = 31
        self.aulaSeparator.backgroundColor = .clear
    }
    
    func showClinicDropDown() {
        self.listExpandHeightConstraint.constant = CGFloat(44 * (allClinicsForWorkingSchedule?.count ?? 0) + 31)
        self.aulaSeparator.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        listSelection = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allClinicsForWorkingSchedule?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCustomTableViewCell", for: indexPath) as? DropDownCustomTableViewCell else { fatalError("Unexpected Error") }
        cell.selectionStyle = .none
        cell.lblDropDownTitle.text = allClinicsForWorkingSchedule?[indexPath.row].name ?? String.blank
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clinicTextLabel.text = allClinicsForWorkingSchedule?[indexPath.row].name ?? String.blank
        selectedClinicId = allClinicsForWorkingSchedule?[indexPath.row].id ?? 0
        hideClinicDropDown()
    }
    
    func apiResponseRecived(apiResponse: ResponseModel) {
        
    }
    
    func wcListResponseRecived(apiResponse: [VacationsListModel]) {
        
    }
    
    func apiErrorReceived(error: String) {
        
    }
    
}
