//
//  VacationScheduleViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

protocol VacationScheduleViewControllerCProtocol: AnyObject {
    func apiResponseRecived(apiResponse: ResponseModel)
    func vacationsListResponseRecived()
    func apiErrorReceived(error: String)
    func errorReceived(error: String)
    func clinicsRecived()
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
    @IBOutlet weak var vacationsListTableView: UITableView!
    @IBOutlet var vacationScrollViewHight: NSLayoutConstraint!
    @IBOutlet var vacationScrollview: UIScrollView!

    var clinicDataArr = [String]()
    var menuSelection: [Int] = []
    var listSelection: Bool = false
    var isValidateVacationArray = [Bool]()

    var vacationViewModel: VacationViewModelProtocol?
    var allClinicsForVacation: [Clinics]?
    var vacationsList:  [VacationsListModel]?
    var selectedClinicId: Int = 0
    var headerView = VacationsHeadeView()
    
    var arrayOfVacations = [VacationSchedules]()
    var arrTime = [Time]()

    var isEmptyResponse: Bool = false
    
    var vacationTableViewHeight: CGFloat {
        vacationsListTableView.layoutIfNeeded()
        return vacationsListTableView.contentSize.height
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.ShowSpinner()
        setUpNavigationBar()
        setupUI()
        vacationViewModel = VacationViewModel(delegate: self)
        vacationScrollview.delegate = self
        vacationViewModel?.getallClinics()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listExpandHeightConstraint.constant = 31
    }

    // MARK: - setUpNavigationBar
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.vacationTitle
    }

    // MARK: - setupDefaultUI
    func setupUI() {
        userNameTextField?.text = "\(UserRepository.shared.firstName ?? String.blank) \(UserRepository.shared.lastName ?? String.blank)"
       
        clinicTextView.layer.cornerRadius = 4.5
        clinicTextView.layer.borderWidth = 1
        clinicTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        vacationsListTableView.register(UINib(nibName:  Constant.ViewIdentifier.vacationsHeadeView, bundle: nil), forHeaderFooterViewReuseIdentifier: Constant.ViewIdentifier.vacationsHeadeView)
        
        vacationsListTableView.register(UINib(nibName: Constant.ViewIdentifier.vacationsCustomTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.vacationsCustomTableViewCell)
        
        vacationsListTableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: .leastNormalMagnitude))
        
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    func clinicsRecived() {
        self.clinicTextLabel.text = vacationViewModel?.getAllClinicsData[0].name ?? String.blank
        self.allClinicsForVacation = vacationViewModel?.getAllClinicsData ?? []
        
        /// get vacation detail for selected clinics
        vacationViewModel?.getVacationDeatils(selectedClinicId: self.allClinicsForVacation?[0].id ?? 0)
    }

    // MARK: - Clinic Dropdown API Response method
    func apiResponseRecived(apiResponse: ResponseModel) {
        self.view.HideSpinner()
        self.view.showToast(message: Constant.Profile.vacationScheduleUpdate)
    }
    
    func apiErrorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    // MARK: - Vacations List API Response method
    func vacationsListResponseRecived() {
        self.view.HideSpinner()
        vacationsList = vacationViewModel?.getVacationData
        if vacationsList?.count == 0 {
            isEmptyResponse = true
        } else {
            isEmptyResponse = false
        }
        self.vacationsListTableView.reloadData()
        vacationScrollViewHight.constant = vacationTableViewHeight + 600
    }
    
    // MARK: - Clinic dropdown selection mrthod
    @IBAction func clinicSelectionButton(sender: UIButton) {
        let rolesArray = vacationViewModel?.getAllClinicsData ?? []
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
            //self.clinicTextLabel.text  = allClinics.name?.components(separatedBy: " ").first
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            selectionMenu.dismissAutomatically = true
            self?.clinicTextLabel.text  = text?.name
            self?.view.ShowSpinner()
            self?.vacationViewModel?.getVacationDeatils(selectedClinicId: text?.id ?? 0)
        }
        selectionMenu.dismissAutomatically = true
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
     }
   
   
    // MARK: - Save Vacations List method
    @IBAction func saveVacationButtonAction(sender: UIButton) {
        isValidateVacationArray = []
        if vacationsList?.count ?? 0 > 0 {
            if selectedClinicId == 0 {
                selectedClinicId = allClinicsForVacation?[0].id ?? 0
            }
            
            for indexValue in 0..<(vacationsList?.count ?? 0) {
                
                for childIndex in 0..<(vacationsList?[indexValue].userScheduleTimings?.count ?? 0) {
                    let cellIndexPath = IndexPath(item: childIndex, section: indexValue)
                   
                  if let vacationCell = self.vacationsListTableView.cellForRow(at: cellIndexPath) as? VacationsCustomTableViewCell {
                        
                      if vacationCell.timeFromTextField.text == String.blank {
                            if vacationsList?[indexValue].userScheduleTimings?.count ?? 0 > 1 {
                                isValidateVacationArray.insert(false, at: childIndex - 1)
                            } else {
                                isValidateVacationArray.insert(false, at: childIndex)
                            }
                          vacationCell.timeFromTextField.showError(message: Constant.Profile.chooseFromTime)
                            return
                        }
                        
                      if vacationCell.timeToTextField.text == String.blank {
                            if vacationsList?[indexValue].userScheduleTimings?.count ?? 0 > 1 {
                                isValidateVacationArray.insert(false, at: childIndex - 1)
                            } else {
                                isValidateVacationArray.insert(false, at: childIndex)
                            }
                            vacationCell.timeToTextField.showError(message: Constant.Profile.chooseToTime)
                            return
                        } else {
                            isValidateVacationArray.insert(true, at: childIndex)
                            arrTime.insert(Time(startTime: vacationViewModel?.serverToLocalTimeInput(timeString: vacationCell.timeFromTextField.text ?? String.blank), endTime: vacationViewModel?.serverToLocalTimeInput(timeString: vacationCell.timeToTextField.text ?? String.blank)), at: childIndex)
                        }
                    }
                }
                
                if let headerView = vacationsListTableView.headerView(forSection: indexValue) as? VacationsHeadeView {
                    if headerView.dateFromTextField.text == String.blank {
                        isValidateVacationArray.insert(false, at: indexValue)
                        headerView.dateFromTextField.showError(message: Constant.Profile.chooseFromDate)
                        return
                    }
                    if headerView.dateToTextField.text == String.blank {
                        isValidateVacationArray.insert(false, at: indexValue)
                        headerView.dateToTextField.showError(message: Constant.Profile.chooseToTime)
                        return
                    } else {
                        isValidateVacationArray.insert(true, at: indexValue)
                        arrayOfVacations.insert(VacationSchedules.init(startDate: vacationViewModel?.serverToLocalInput(date: headerView.dateFromTextField.text ?? String.blank), endDate: vacationViewModel?.serverToLocalInput(date: headerView.dateToTextField.text ?? String.blank), time: arrTime), at: indexValue)
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
            vacationViewModel?.sendRequestforVacation(vacationParams: parameters)
        }
    }
    
    // MARK: - Add Vacations method
    @IBAction func addVacationButtonAction(sender: UIButton) {

        let vacationCount = vacationsList?.count ?? 0
        let date2 = VacationsListModel(id: 1, clinicId: 123, providerId: 1234, fromDate: "2022-12-16T00:00:00.000+0000", toDate: "2022-12-16T00:00:00.000+0000", scheduleType: "vacation", userScheduleTimings: [])
        vacationsList?.append(date2)
        
        vacationsListTableView.beginUpdates()
        isEmptyResponse = true
        let indexSet = IndexSet(integer: (vacationsList?.count ?? 0) - 1)
       
        vacationsListTableView.insertSections(indexSet, with: .fade)
      
        let date1 = UserScheduleTimings(id: 1, timeFromDate: String.blank, timeToDate:  String.blank, days:  String.blank)
        
        vacationsList?[vacationCount].userScheduleTimings?.append(date1)
       
        let indexPath = IndexPath(row: 0, section: vacationCount)
        
        vacationsListTableView.insertRows(at: [indexPath], with: .fade)
        vacationsListTableView.endUpdates()
        vacationScrollViewHight.constant = vacationTableViewHeight + 450
    }
}
