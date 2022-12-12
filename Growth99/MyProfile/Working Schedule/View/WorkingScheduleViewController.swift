//
//  WorkingScheduleViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

protocol WorkingScheduleViewControllerCProtocol: AnyObject {
    func apiResponseRecived(apiResponse: ResponseModel)
    func wcListResponseRecived(apiResponse: [WorkingScheduleListModel])
    func apiErrorReceived(error: String)
}

class WorkingScheduleViewController: UIViewController, WorkingScheduleViewControllerCProtocol {
    
    @IBOutlet private weak var userNameTextField: CustomTextField!
    @IBOutlet weak var workingDateFromTextField: CustomTextField!
    @IBOutlet weak var workingDateToTextField: CustomTextField!

    @IBOutlet private weak var addWorkingScheduleButton: UIButton!
    @IBOutlet private weak var saveWorkingScheduleTimeButton: UIButton!
    @IBOutlet private weak var clinicTextView: UIView!
    
    @IBOutlet weak var clinicTextLabel: UILabel!
    @IBOutlet weak var clinicSelectonButton: UIButton!
    @IBOutlet weak var listExpandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var clinicSelectionTableView: UITableView!
    @IBOutlet weak var workingListTableView: UITableView!
    @IBOutlet weak var aulaSeparator: UIView!
    
    @IBOutlet var workingScrollViewHight: NSLayoutConstraint!
    @IBOutlet var workingscrollview: UIScrollView!

    var workingScheduleViewModel = WorkingScheduleViewModel()
    var clinicDataArr = [String]()
    var menuSelection: [Int] = []
    var listSelection: Bool = false
    private var menuVC = DrawerViewContoller()
    var viewModel: WorkingScheduleViewControllerCProtocol?
    var allClinicsForWorkingSchedule: [Clinics]?
    var workingListModel =  [WorkingScheduleListModel]?([])
    var selectedClinicId: Int = 0
    
    var arrayOfWorking = [WorkingScheduleListModel]()
    var arrTime = [Time]()

    var isEmptyResponse: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        menuVC = sidemenuVC as! DrawerViewContoller
        
       self.view.ShowSpinner()
        setUpNavigationBar()
        setupUI()
        workingScheduleViewModel = WorkingScheduleViewModel(delegate: self)
        workingscrollview.delegate = self
        workingDateFromTextField.tintColor = .clear
        workingDateToTextField.tintColor = .clear
        workingDateFromTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        workingDateToTextField.addInputViewDatePicker(target: self, selector: #selector(dateToButtonPressed1), mode: .date)
    }
    
    @objc func dateFromButtonPressed() {
        workingDateFromTextField.text = workingScheduleViewModel.dateFormatterString(textField: workingDateFromTextField)

    }
    
    @objc func dateToButtonPressed1() {
        workingDateFromTextField.text = workingScheduleViewModel.dateFormatterString(textField: workingDateToTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listExpandHeightConstraint.constant = 31
        self.aulaSeparator.backgroundColor = .clear
    }

    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.workingScheduleTitle
        navigationItem.leftBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "menu")
    }
    
    func setupUI() {
        userNameTextField?.text = "\(UserRepository.shared.firstName ?? String.blank) \(UserRepository.shared.lastName ?? String.blank)"
        userNameTextField.isUserInteractionEnabled = false
        clinicTextView.layer.cornerRadius = 4.5
        clinicTextView.layer.borderWidth = 1
        clinicTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        clinicSelectionTableView.register(UINib(nibName: "DropDownCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "DropDownCustomTableViewCell")
        workingListTableView.register(UINib(nibName: "WorkingCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkingCustomTableViewCell")
       getDataDropDown()
    }
    
    func getDataDropDown() {
        workingScheduleViewModel.getallClinicsforWorkingSchedule { (response, error) in
            if error == nil && response != nil {
                self.allClinicsForWorkingSchedule = response
                self.clinicTextLabel.text = self.allClinicsForWorkingSchedule?[0].name ?? String.blank
               self.workingScheduleViewModel.getWorkingScheduleDeatils(selectedClinicId: self.allClinicsForWorkingSchedule?[0].id ?? 0)
            } else {
                self.view.HideSpinner()
            }
        }
    }
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
    }
  
    func apiResponseRecived(apiResponse: ResponseModel) {
        self.view.HideSpinner()
        self.view.showToast(message: "Vacation schedule updated sucessfully")
    }
    
    func apiErrorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    func wcListResponseRecived(apiResponse: [WorkingScheduleListModel]) {
        self.view.HideSpinner()
        workingListModel = apiResponse
        workingDateFromTextField.text = workingScheduleViewModel.serverToLocal(date: workingListModel?[0].fromDate ?? String.blank)
        workingDateToTextField.text = workingScheduleViewModel.serverToLocal(date: workingListModel?[0].toDate ?? String.blank)
        if workingListModel?.count == 0 {
            isEmptyResponse = true
        } else {
            isEmptyResponse = false
        }
        self.clinicSelectionTableView.reloadData()
        self.workingListTableView.reloadData()
    }
    
    @IBAction func saveVacationButtonAction(sender: UIButton) {
       
    }
    
    @IBAction func addVacationButtonAction(sender: UIButton) {
      
    }
    
    @IBAction func clinicSelectionButton(sender: UIButton) {
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
    
    var vacationTableViewHeight: CGFloat {
        workingListTableView.layoutIfNeeded()
        return workingListTableView.contentSize.height
    }
}
