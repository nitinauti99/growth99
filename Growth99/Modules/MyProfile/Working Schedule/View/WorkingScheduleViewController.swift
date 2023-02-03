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
    var isEmptyResponse: Bool = false
    var isValidationSucess: Bool = false

    var isValidateArray = [Bool]()
    
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
        self.view.showToast(message: error)
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
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
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
        self.view.showToast(message: Constant.Profile.workingScheduleUpdate)
    }
    
    func apiErrorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
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
        
        if selectedClinicId == 0 {
            selectedClinicId = allClinicsForWorkingSchedule?[0].id ?? 0
        }
        if workingListModel?.count ?? 0 > 0 {
            for childIndex in 0..<(workingListModel?[0].userScheduleTimings?.count ?? 0) {
                let cellIndexPath = IndexPath(item: childIndex, section: 0)
                if let workingCell = workingListTableView.cellForRow(at: cellIndexPath) as? WorkingCustomTableViewCell {
                    if workingCell.workingClinicTextLabel.text == Constant.Profile.selectDay {
                        isValidateArray.insert(false, at: childIndex)
                        workingCell.workingClinicErrorTextLabel.isHidden = false
                        return
                    }
                    if workingCell.timeFromTextField.text == String.blank {
                        isValidateArray.insert(false, at: childIndex)
                        workingCell.timeFromTextField.showError(message: Constant.Profile.chooseFromTime)
                        return
                    }
                    if (workingCell.timeToTextField.text == String.blank) {
                        isValidateArray.insert(false, at: childIndex)
                        workingCell.timeToTextField.showError(message: Constant.Profile.chooseToTime)
                        return
                    } else {
                        workingCell.workingClinicErrorTextLabel.isHidden = true
                        isValidateArray.insert(true, at: childIndex)
                        let daysArray =  workingCell.supportWorkingClinicTextLabel.text ?? String.blank
                        let days = daysArray.components(separatedBy: ",")
                        selectedSlots.insert(SelectedSlots(timeFromDate: workingScheduleViewModel?.serverToLocalTimeInput(timeString: workingCell.timeFromTextField.text ?? String.blank), timeToDate: workingScheduleViewModel?.serverToLocalTimeInput(timeString: workingCell.timeToTextField.text ?? String.blank), days: days), at: childIndex)
                    }
                }
            }
            
            if isValidateArray.contains(false) {
                return
            }
            self.view.ShowSpinner()
            let body = WorkingParamModel(userId: UserRepository.shared.userId ?? 0, clinicId: selectedClinicId, scheduleType: Constant.Profile.workingSchedule, dateFromDate: workingScheduleViewModel?.serverToLocalInputWorking(date: workingDateFromTextField.text ?? String.blank), dateToDate: workingScheduleViewModel?.serverToLocalInputWorking(date: workingDateToTextField.text ?? String.blank), dateFrom: workingScheduleViewModel?.serverToLocalInput(date: workingDateFromTextField.text ?? String.blank), dateTo: workingScheduleViewModel?.serverToLocalInput(date: workingDateToTextField.text ?? String.blank), providerId: UserRepository.shared.userId ?? 0, selectedSlots: selectedSlots)
           
            let parameters: [String: Any]  = body.toDict()
            workingScheduleViewModel?.sendRequestforWorkingSchedule(vacationParams: parameters)
        }
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
        isEmptyResponse = true
        let indexPath = IndexPath(row: (workingListModel?[0].userScheduleTimings?.count ?? 0) - 1, section: 0)
        workingListTableView.insertRows(at: [indexPath], with: .fade)
        workingListTableView.endUpdates()
        scrollViewHeight()
    }
    
//    @IBAction func clinicSelectionButton(sender: UIButton) {
//        if listSelection == true {
//            hideClinicDropDown()
//            scrollViewHeight()
//        } else {
//            showClinicDropDown()
//        }
//    }
    
//    func hideClinicDropDown() {
//        listSelection = false
//        self.listExpandHeightConstraint.constant = 31
//        self.aulaSeparator.backgroundColor = .clear
//    }
    
//    func showClinicDropDown() {
//        workingScrollViewHight.constant = tableViewHeight + 650 + CGFloat(44 * (allClinicsForWorkingSchedule?.count ?? 0) + 31)
//        self.listExpandHeightConstraint.constant = CGFloat(44 * (allClinicsForWorkingSchedule?.count ?? 0) + 31)
//        self.aulaSeparator.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
//        listSelection = true
//    }
    
    func scrollViewHeight() {
        workingScrollViewHight.constant = tableViewHeight + 650
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
