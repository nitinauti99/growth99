//
//  VacationScheduleViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

protocol VacationScheduleViewControllerCProtocol: AnyObject {
    func apiResponseRecived(apiResponse: ResponseModel)
    func vacationsListResponseRecived(apiResponse: [VacationsListModel])
    func apiErrorReceived(error: String)
}

class VacationScheduleViewController: UIViewController, VacationScheduleViewControllerCProtocol, CellSubclassDelegate {

    @IBOutlet private weak var userNameTextField: CustomTextField!
    @IBOutlet private weak var addTimeButton: UIButton!
    @IBOutlet private weak var removeTimeButton: UIButton!
    @IBOutlet private weak var addVacationButton: UIButton!
    @IBOutlet private weak var saveVacationTimeButton: UIButton!
    @IBOutlet private weak var clinicTextView: UIView!
    
    @IBOutlet weak var clinicTextLabel: UILabel!
    @IBOutlet weak var clinicSelectonButton: UIButton!
    @IBOutlet weak var listExpandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var clinicSelectionTableView: UITableView!
    @IBOutlet weak var vacationsListTableView: UITableView!
    @IBOutlet weak var aulaSeparator: UIView!
    
    @IBOutlet var vacationScrollViewHight: NSLayoutConstraint!
    @IBOutlet var vacationScrollview: UIScrollView!

    var vacationViewModel = VacationViewModel()
    var clinicDataArr = [String]()
    var menuSelection: [Int] = []
    var listSelection: Bool = false
    var isValidateVacationArray = [Bool]()

    private var menuVC = DrawerViewContoller()
    var viewModel: VacationScheduleViewControllerCProtocol?
    var allClinicsForVacation: [Clinics]?
    var vacationsListModel =  [VacationsListModel]?([])
    var selectedClinicId: Int = 0
    var headerView = VacationsHeadeView()
    
    var arrayOfVacations = [VacationSchedules]()
    var arrTime = [Time]()

    var isEmptyResponse: Bool = false
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        menuVC = sidemenuVC as! DrawerViewContoller
        
       self.view.ShowSpinner()
        setUpNavigationBar()
        setupUI()
        vacationViewModel = VacationViewModel(delegate: self)
        vacationScrollview.delegate = self
//        vacationsListModel = readJSONFromFile(fileName: "MockResponse")
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listExpandHeightConstraint.constant = 31
        self.aulaSeparator.backgroundColor = .clear
    }

    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.vacationTitle
        navigationItem.leftBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "menu")
    }
    
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
    }
    
    // MARK: - setupDefaultUI
    func setupUI() {
        userNameTextField?.text = "\(UserRepository.shared.firstName ?? String.blank) \(UserRepository.shared.lastName ?? String.blank)"
        userNameTextField.isUserInteractionEnabled = false
        clinicTextView.layer.cornerRadius = 4.5
        clinicTextView.layer.borderWidth = 1
        clinicTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        clinicSelectionTableView.register(UINib(nibName: "DropDownCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "DropDownCustomTableViewCell")
        vacationsListTableView.register(UINib(nibName: "VacationsHeadeView", bundle: nil), forHeaderFooterViewReuseIdentifier: "VacationsHeadeView")
        vacationsListTableView.register(UINib(nibName: "VacationsCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "VacationsCustomTableViewCell")
        vacationsListTableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
       getDataDropDown()
    }
    
    // MARK: - Clinic Dropdown API Calling method
    func getDataDropDown() {
        vacationViewModel.getallClinicsforVacation { (response, error) in
            if error == nil && response != nil {
                self.allClinicsForVacation = response
                self.clinicTextLabel.text = self.allClinicsForVacation?[0].name ?? String.blank
                self.vacationViewModel.getVacationDeatils(selectedClinicId: self.allClinicsForVacation?[0].id ?? 0)
            } else {
                self.view.HideSpinner()
            }
        }
    }

    // MARK: - Clinic Dropdown API Response method
    func apiResponseRecived(apiResponse: ResponseModel) {
        self.view.HideSpinner()
        self.view.showToast(message: "Vacation schedule updated sucessfully")
    }
    
    func apiErrorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    // MARK: - Vacations List API Response method
    func vacationsListResponseRecived(apiResponse: [VacationsListModel]) {
        self.view.HideSpinner()
        vacationsListModel = apiResponse
        if vacationsListModel?.count == 0 {
            isEmptyResponse = true
        } else {
            isEmptyResponse = false
        }
        self.clinicSelectionTableView.reloadData()
        self.vacationsListTableView.reloadData()
    }
    
    // MARK: - Clinic dropdown selection mrthod
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
        self.listExpandHeightConstraint.constant = CGFloat(44 * (allClinicsForVacation?.count ?? 0) + 31)
        self.aulaSeparator.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        listSelection = true
    }
    
    var vacationTableViewHeight: CGFloat {
        vacationsListTableView.layoutIfNeeded()
        return vacationsListTableView.contentSize.height
    }
    
    // MARK: - Save Vacations List method
    @IBAction func saveVacationButtonAction(sender: UIButton) {
        isValidateVacationArray = []
        if vacationsListModel?.count ?? 0 > 0 {
            if selectedClinicId == 0 {
                selectedClinicId = allClinicsForVacation?[0].id ?? 0
            }
            
            for indexValue in 0..<(vacationsListModel?.count ?? 0) {
                for childIndex in 0..<(vacationsListModel?[indexValue].userScheduleTimings?.count ?? 0) {
                    let cellIndexPath = IndexPath(item: childIndex, section: indexValue)
                    if let vacationCell = self.vacationsListTableView.cellForRow(at: cellIndexPath) as? VacationsCustomTableViewCell {
                        if vacationCell.timeFromTextField.text == "" {
                            if vacationsListModel?[indexValue].userScheduleTimings?.count ?? 0 > 1 {
                                isValidateVacationArray.insert(false, at: childIndex - 1)
                            } else {
                                isValidateVacationArray.insert(false, at: childIndex)
                            }
                            vacationCell.timeFromTextField.showError(message: "Please choose from time")
                            return
                        }
                        if vacationCell.timeToTextField.text == "" {
                            if vacationsListModel?[indexValue].userScheduleTimings?.count ?? 0 > 1 {
                                isValidateVacationArray.insert(false, at: childIndex - 1)
                            } else {
                                isValidateVacationArray.insert(false, at: childIndex)
                            }
                            vacationCell.timeToTextField.showError(message: "Please choose to time")
                            return
                        } else {
                            isValidateVacationArray.insert(true, at: childIndex)
                            arrTime.insert(Time(startTime: vacationViewModel.serverToLocalTimeInput(timeString: vacationCell.timeFromTextField.text ?? String.blank), endTime: vacationViewModel.serverToLocalTimeInput(timeString: vacationCell.timeToTextField.text ?? String.blank)), at: childIndex)
                        }
                    }
                }
                
                if let headerView = vacationsListTableView.headerView(forSection: indexValue) as? VacationsHeadeView {
                    if headerView.dateFromTextField.text == "" {
                        isValidateVacationArray.insert(false, at: indexValue)
                        headerView.dateFromTextField.showError(message: "Please choose from Date")
                        return
                    }
                    if headerView.dateToTextField.text == "" {
                        isValidateVacationArray.insert(false, at: indexValue)
                        headerView.dateToTextField.showError(message: "Please choose to Date")
                        return
                    } else {
                        isValidateVacationArray.insert(true, at: indexValue)
                        arrayOfVacations.insert(VacationSchedules.init(startDate: vacationViewModel.serverToLocalInput(date: headerView.dateFromTextField.text ?? String.blank), endDate: vacationViewModel.serverToLocalInput(date: headerView.dateToTextField.text ?? String.blank), time: arrTime), at: indexValue)
                        arrTime.removeAll()
                    }
                }
                
            }
            
            if isValidateVacationArray.contains(false) {
                return
            }
            self.view.ShowSpinner()
            let body = VacationParamModel(providerId: UserRepository.shared.userId ?? 0, clinicId: selectedClinicId, vacationSchedules: arrayOfVacations)
            let parameters: [String: Any]  = body.toDict()
            print("Params::: \(parameters)")
            vacationViewModel.sendRequestforVacation(vacationParams: parameters)
        }
    }
    
    // MARK: - Add Vacations method
    @IBAction func addVacationButtonAction(sender: UIButton) {
        
        let vacationCount = vacationsListModel?.count ?? 0
        let date2 = VacationsListModel(id: 1, clinicId: 123, providerId: 1234, fromDate: "2022-12-16T00:00:00.000+0000", toDate: "2022-12-16T00:00:00.000+0000", scheduleType: "vacation", userScheduleTimings: [])
        vacationsListModel?.append(date2)
        vacationsListTableView.beginUpdates()
        isEmptyResponse = true
        let indexSet = IndexSet(integer: (vacationsListModel?.count ?? 0) - 1)
        vacationsListTableView.insertSections(indexSet, with: .fade)
        let date1 = UserScheduleTimings(id: 1, timeFromDate: "", timeToDate: "", days: "")
        vacationsListModel?[vacationCount].userScheduleTimings?.append(date1)
        let indexPath = IndexPath(row: 0, section: vacationCount)
        vacationsListTableView.insertRows(at: [indexPath], with: .fade)
        vacationsListTableView.endUpdates()
        vacationScrollViewHight.constant = vacationTableViewHeight + 450
    }
}
