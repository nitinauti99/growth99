//
//  WorkingScheduleViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

protocol WorkingScheduleViewControllerCProtocol: AnyObject {
    func apiResponseRecived(apiResponse: ResponseModel)
    func wcListResponseRecived()
    func apiErrorReceived(error: String)
    func errorReceived(error: String)
    func clinicsRecived()
}

class WorkingScheduleViewController: UIViewController, WorkingScheduleViewControllerCProtocol, WorkingCellSubclassDelegate {
    
    @IBOutlet private weak var userNameTextField: CustomTextField!
    @IBOutlet weak var workingDateFromTextField: CustomTextField!
    @IBOutlet weak var workingDateToTextField: CustomTextField!
    @IBOutlet private weak var clinicTextView: UIView!
    @IBOutlet weak var clinicTextLabel: UILabel!
    @IBOutlet weak var clinicSelectonButton: UIButton!
    @IBOutlet weak var listExpandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var workingListTableView: UITableView!
    @IBOutlet var workingScrollViewHight: NSLayoutConstraint!
    @IBOutlet var workingscrollview: UIScrollView!
    
    var workingScheduleViewModel: WorkingScheduleViewModelProtocol?
    var listSelection: Bool = false
    var allClinicsForWorkingSchedule: [Clinics]?
    var workingListModel: [WorkingScheduleListModel]?
    var selectedClinicId: Int = 0
    var selectedSlots = [SelectedSlots]()
    var slots = [Slots]()
    var isEmptyResponse: Bool = false
    var isValidationSucess: Bool = false
    var workingAddNewClicked: Bool = false
    var newDaysButtonClick: String = ""
    
    var isValidateArray = [Bool]()
    var selectedDays = [String]()
    var daysSelectedItems: Bool = false
    var days: [String]?
    var tableViewHeight: CGFloat {
        workingListTableView.layoutIfNeeded()
        return workingListTableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workingscrollview.delegate = self
        workingScheduleViewModel = WorkingScheduleViewModel(delegate: self)
        self.view.ShowSpinner()
        workingScheduleViewModel?.getallClinics()
        setUpNavigationBar()
        setupUI()
        workingscrollview.delegate = self
        workingDateFromTextField.tintColor = .clear
        workingDateToTextField.tintColor = .clear
        workingDateFromTextField.addInputViewDatePicker(target: self, selector: #selector(dateFromButtonPressed), mode: .date)
        workingDateToTextField.addInputViewDatePicker(target: self, selector: #selector(dateToButtonPressed1), mode: .date)
    }
    
    @objc func dateFromButtonPressed() {
        workingDateFromTextField.text = workingScheduleViewModel?.dateFormatterString(textField: workingDateFromTextField)
    }
    
    @objc func dateToButtonPressed1() {
        workingDateToTextField.text = workingScheduleViewModel?.dateFormatterString(textField: workingDateToTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.workingScheduleTitle
    }
    
    func setupUI() {
        userNameTextField?.text = "\(UserRepository.shared.firstName ?? String.blank) \(UserRepository.shared.lastName ?? String.blank)"
        userNameTextField.isUserInteractionEnabled = false
        clinicTextView.layer.cornerRadius = 4.5
        clinicTextView.layer.borderWidth = 1
        clinicTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        workingListTableView.register(UINib(nibName: Constant.ViewIdentifier.workingCustomTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.ViewIdentifier.workingCustomTableViewCell)
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func clinicsRecived() {
        self.clinicTextLabel.text = workingScheduleViewModel?.getAllClinicsData[0].name ?? String.blank
        self.allClinicsForWorkingSchedule = workingScheduleViewModel?.getAllClinicsData ?? []
        
        /// get vacation detail for selected clinics
        workingScheduleViewModel?.getWorkingScheduleDeatils(selectedClinicId: self.allClinicsForWorkingSchedule?[0].id ?? 0)
    }
    
    func wcListResponseRecived() {
        self.view.HideSpinner()
        isValidationSucess = false
        workingListModel = workingScheduleViewModel?.getVacationData ?? []
        
        if workingListModel?.count ?? 0 > 0 {
            isEmptyResponse = false
            workingDateFromTextField.text = workingScheduleViewModel?.serverToLocal(date: workingListModel?[0].fromDate ?? String.blank)
            workingDateToTextField.text = workingScheduleViewModel?.serverToLocal(date: workingListModel?[0].toDate ?? String.blank)
        } else {
            isEmptyResponse = true
        }
        self.workingListTableView.reloadData()
        scrollViewHeight()
    }
    
    // MARK: - Clinic dropdown selection mrthod
    @IBAction func clinicSelectionButton(sender: UIButton) {
        let rolesArray = workingScheduleViewModel?.getAllClinicsData ?? []
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            selectionMenu.dismissAutomatically = true
            self?.clinicTextLabel.text  = text?.name
            self?.view.ShowSpinner()
            self?.workingScheduleViewModel?.getWorkingScheduleDeatils(selectedClinicId: text?.id ?? 0)
        }
        selectionMenu.dismissAutomatically = true
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    func apiResponseRecived(apiResponse: ResponseModel) {
        self.view.HideSpinner()
        if apiResponse.status == 500 {
            self.view.showToast(message: apiResponse.message ?? "", color: .red)
        } else {
            self.view.showToast(message: Constant.Profile.workingScheduleUpdate, color: UIColor().successMessageColor())
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func apiErrorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func wcListResponseRecived(apiResponse: [WorkingScheduleListModel]) {
        self.view.HideSpinner()
        workingListModel = apiResponse
    }
    
    @IBAction func saveWorkingButtonAction(sender: UIButton) {
        isValidateArray = []
        
        guard let dateFrom = workingDateFromTextField.text, !dateFrom.isEmpty else {
            workingDateFromTextField.showError(message: Constant.Profile.chooseFromDate)
            return
        }
        
        guard let dateTo = workingDateToTextField.text, !dateTo.isEmpty else {
            workingDateToTextField.showError(message: Constant.Profile.chooseToDate)
            return
        }
        
        guard validateDates(startDate: dateFrom, endDate: dateTo) else {
            workingDateFromTextField.showError(message: "From date must be less than or equal to To date")
            return
        }
        
        if selectedClinicId == 0 {
            selectedClinicId = allClinicsForWorkingSchedule?[0].id ?? 0
        }
        if workingListModel?.count ?? 0 > 0 {
            for childIndex in 0..<(workingListModel?[0].userScheduleTimings?.count ?? 0) {
                let cellIndexPath = IndexPath(item: childIndex, section: 0)
                guard let workingCell = workingListTableView.cellForRow(at: cellIndexPath) as? WorkingCustomTableViewCell else {
                    continue
                }
                
                guard workingCell.selectDayTextField.text != String.blank else {
                    isValidateArray.insert(false, at: childIndex)
                    workingCell.selectDayTextField.showError(message: "Please select day")
                    return
                }
                
                guard workingCell.timeFromTextField.text != String.blank else {
                    isValidateArray.insert(false, at: childIndex)
                    workingCell.timeFromTextField.showError(message: Constant.Profile.chooseFromTime)
                    return
                }
                
                guard workingCell.timeToTextField.text != String.blank else {
                    isValidateArray.insert(false, at: childIndex)
                    workingCell.timeToTextField.showError(message: Constant.Profile.chooseToTime)
                    return
                }
                
                guard validateTimes(startTime: workingCell.timeFromTextField.text ?? "", endTime: workingCell.timeToTextField.text ?? "") else {
                    workingCell.timeFromTextField.showError(message: "From Time must be smaller than to Time for selected date.")
                    return
                }
                
                isValidateArray.insert(true, at: childIndex)
                if workingAddNewClicked == false {
                    days = workingCell.workingDaysSelected
                } else {
                    days = selectedDays
                }
                let startTime = workingCell.timeFromTextField.text ?? String.blank
                let endTime = workingCell.timeToTextField.text ?? String.blank
                slots.insert(
                    Slots(
                        timeFromDate: workingScheduleViewModel?.serverToLocalInput(date: workingDateFromTextField.text ?? String.blank),
                        timeToDate: workingScheduleViewModel?.serverToLocalInput(date: workingDateFromTextField.text ?? String.blank),
                        days: days, fullTime: true),
                    at: childIndex
                )
                selectedSlots.insert(
                    SelectedSlots(
                        timeFromDate: workingScheduleViewModel?.serverToLocalTimeInput(timeString: startTime),
                        timeToDate: workingScheduleViewModel?.serverToLocalTimeInput(timeString: endTime),
                        days: days
                    ),
                    at: childIndex
                )
            }
            
            if isValidateArray.contains(false) {
                return
            }
            self.view.ShowSpinner()
            let body = WorkingParamModel(userId: UserRepository.shared.userVariableId ?? 0,
                                         clinicId: selectedClinicId,
                                         scheduleType: Constant.Profile.workingSchedule,
                                         dateFromDate: workingScheduleViewModel?.convertDateFromDateTo(dateString: workingDateFromTextField.text ?? String.blank),
                                         dateToDate: workingScheduleViewModel?.convertDateFromDateTo(dateString: workingDateToTextField.text ?? String.blank),
                                         dateFrom: workingScheduleViewModel?.convertDateWorking(dateString: workingDateFromTextField.text ?? String.blank),
                                         dateTo: workingScheduleViewModel?.convertDateWorking(dateString: workingDateToTextField.text ?? String.blank),
                                         providerId: UserRepository.shared.userVariableId ?? 0,
                                         slots: slots,selectedSlots: selectedSlots)
            
            let parameters: [String: Any]  = body.toDict()
            workingScheduleViewModel?.sendRequestforWorkingSchedule(vacationParams: parameters)
        }
    }
    
    func validateDates(startDate: String, endDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let start = dateFormatter.date(from: startDate),
              let end = dateFormatter.date(from: endDate) else {
            // Invalid date format
            return false
        }
        
        if start > end {
            // Start date is after end date
            return false
        }
        
        return true
    }
    
    func validateTimes(startTime: String, endTime: String) -> Bool {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        guard let startDate = timeFormatter.date(from: startTime),
              let endDate = timeFormatter.date(from: endTime) else {
            return false
        }
        
        // Check if start time is before end time
        if startDate >= endDate {
            return false
        }
        
        return true
    }
    
    @IBAction func addWorkingButtonAction(sender: UIButton) {
        if workingListModel?.count ?? 0 == 0 {
            let parm = WorkingScheduleListModel(id: 1, clinicId: 1, providerId: 1, fromDate: String.blank, toDate: String.blank, scheduleType: String.blank, userScheduleTimings: [])
            workingListModel?.append(parm)
            workingListTableView.reloadData()
        }
        let date1 = WorkingUserScheduleTimings(id: 1, timeFromDate: String.blank, timeToDate: String.blank, days: [])
        workingListModel?[0].userScheduleTimings?.append(date1)
        workingListTableView.beginUpdates()
        workingAddNewClicked = true
        isEmptyResponse = true
        let indexPath = IndexPath(row: (workingListModel?[0].userScheduleTimings?.count ?? 0) - 1, section: 0)
        workingListTableView.insertRows(at: [indexPath], with: .fade)
        workingListTableView.endUpdates()
        scrollViewHeight()
    }
    
    func scrollViewHeight() {
        workingScrollViewHight.constant = tableViewHeight + 750
    }
    
}

extension WorkingScheduleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewHeight()
    }
}
