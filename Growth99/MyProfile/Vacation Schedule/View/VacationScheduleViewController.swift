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

class VacationScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VacationScheduleViewControllerCProtocol {

    @IBOutlet private weak var userNameTextField: CustomTextField!
    @IBOutlet private weak var dateFromTextField: CustomTextField!
    @IBOutlet private weak var dateToTextField: CustomTextField!
    @IBOutlet private weak var timeFromTextField: CustomTextField!
    @IBOutlet private weak var timeToTextField: CustomTextField!
    @IBOutlet private weak var addTimeButton: UIButton!
    @IBOutlet private weak var removeTimeButton: UIButton!
    @IBOutlet private weak var addVacationButton: UIButton!
    @IBOutlet private weak var saveVacationTimeButton: UIButton!
    @IBOutlet private weak var clinicTextView: UIView!

    
    @IBOutlet private weak var clinicTextLabel: UILabel!
    @IBOutlet weak var clinicSelectonButton: UIButton!
    @IBOutlet weak var listExpandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var clinicSelectionTableView: UITableView!
    @IBOutlet weak var aulaSeparator: UIView!
    
    @IBOutlet weak var addDateView: UIView!
    @IBOutlet weak var addTimeView: UIView!
    
    @IBOutlet weak var addDateViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTimeViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dateFromLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateFromHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dateToLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateToHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var timeFromLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeFromHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var timeToLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timeToHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var addTimeBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addVacationBtnTopConstraint: NSLayoutConstraint!

    let timePicker = UIDatePicker()
    var vacationViewModel = VacationViewModel()
    var clinicDataArr = [String]()
    var menuSelection: [Int] = []
    var listSelection: Bool = false
    private var menuVC = DrawerViewContoller()
    var viewModel: VacationScheduleViewControllerCProtocol?
    var allClinicsForVacation: [Clinics]?
    var selectedClinicId: Int = 0
    let group = DispatchGroup()
    var string: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        menuVC = sidemenuVC as! DrawerViewContoller
        
        self.view.ShowSpinner()
        setUpNavigationBar()
        setupUI()
        vacationViewModel = VacationViewModel(delegate: self)

        dateFromTextField.tintColor = .clear
        dateToTextField.tintColor = .clear
        timeFromTextField.tintColor = .clear
        timeToTextField.tintColor = .clear

        dateFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), mode: .date)
        dateToTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed1), mode: .date)
        timeFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed2), mode: .time)
        timeToTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed3), mode: .time)

    }
    
    @objc func doneButtonPressed() {
        dateFromTextField.text = vacationViewModel.dateFormatterString(textField: dateFromTextField)
    }
    
    @objc func doneButtonPressed1() {
        dateToTextField.text = vacationViewModel.dateFormatterString(textField: dateToTextField)
    }
    
    @objc func doneButtonPressed2() {
        timeFromTextField.text = vacationViewModel.timeFormatterString(textField: timeFromTextField)
    }
    
    @objc func doneButtonPressed3() {
        timeToTextField.text = vacationViewModel.timeFormatterString(textField: timeToTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listExpandHeightConstraint.constant = 31
        self.aulaSeparator.backgroundColor = .clear
    }

    func setUpNavigationBar() {
        self.navigationItem.title = Constant.Profile.vacationTitle
        navigationItem.leftBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(sideMenuTapped), imageName: "menu")
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
        vacationViewModel.getallClinicsforVacation { (response, error) in
            if error == nil && response != nil {
                self.allClinicsForVacation = response
                self.clinicTextLabel.text = self.allClinicsForVacation?[0].name ?? String.blank
                self.vacationViewModel.getVacationDeatils(selectedClinicId: self.allClinicsForVacation?[0].id ?? 0)
                self.clinicSelectionTableView.reloadData()
            } else {
                self.view.HideSpinner()
            }
        }
    }
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
    }
    
    @IBAction func saveVacationButtonAction(sender: UIButton) {
        self.view.ShowSpinner()
        
        var arrTime = [Time]()
        arrTime.append(Time(startTime: "09:30", endTime: "08:34"))
        let arrVacation = VacationSchedules.init(startDate: "2022-12-16 00:00:00 +0530", endDate: "2022-12-14 00:00:00 +0530", time: arrTime)
        
        let body = VacationParamModel(providerId: UserRepository.shared.userId ?? 0, clinicId: selectedClinicId, vacationSchedules: [arrVacation])
        let parameters: [String: Any]  = body.toDict()
        vacationViewModel.sendRequestforVacation(vacationParams: parameters)
    }
    
    func apiResponseRecived(apiResponse: ResponseModel) {
        self.view.HideSpinner()
        self.view.showToast(message: "Vacation schedule updated sucessfully")
    }
    
    func apiErrorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
    
    func vacationsListResponseRecived(apiResponse: [VacationsListModel]) {
        self.view.HideSpinner()
        if apiResponse.count == 0 {
            hideVacationView()
        } else {
            print("dfjhg \(serverToLocal(date: apiResponse[0].fromDate ?? String.blank))")
        }
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 00:00:00 XXXXX"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateFromString = dateFormatter.date(from: date.components(separatedBy: " ").first ?? String.blank) ?? Date()
        return dateFormatter.string(from: dateFromString)
        
    }
    
    func hideVacationView() {
        mangeAddDateView(dateViewConstant: AddDateModel.init(dateFromLabelHeight: 0, dateFromHeight: 0, dateToLabelHeight: 0, dateToHeight: 0), addtimeButtonHeight: 0, addDateViewHeight: 0, addVacationBtnTop: 0)
        manageAddTimeView(timeViewConstant: AddTimeModel(timeFromLabelHeight: 0, timeFromHeight: 0, timeToLabelHeight: 0, timeToHeight: 0), addtimeViewHeight: 0, addDateViewHeight: 0)
    }
    
    @IBAction func addTimeButtonAction(sender: UIButton) {
        manageAddTimeView(timeViewConstant: AddTimeModel(timeFromLabelHeight: 21, timeFromHeight: 45, timeToLabelHeight: 21, timeToHeight: 45), addtimeViewHeight: 182, addDateViewHeight: 450)
    }
    
    @IBAction func removeTimeButtonAction(sender: UIButton) {
        manageAddTimeView(timeViewConstant: AddTimeModel(timeFromLabelHeight: 0, timeFromHeight: 0, timeToLabelHeight: 0, timeToHeight: 0), addtimeViewHeight: 0, addDateViewHeight: 270)
    }
    
    @IBAction func addVacationButtonAction(sender: UIButton) {
        mangeAddDateView(dateViewConstant: AddDateModel.init(dateFromLabelHeight: 21, dateFromHeight: 45, dateToLabelHeight: 21, dateToHeight: 45), addtimeButtonHeight: 50, addDateViewHeight: 450, addVacationBtnTop: 30)
        manageAddTimeView(timeViewConstant: AddTimeModel(timeFromLabelHeight: 21, timeFromHeight: 45, timeToLabelHeight: 21, timeToHeight: 45), addtimeViewHeight: 182, addDateViewHeight: 450)
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
        self.listExpandHeightConstraint.constant = CGFloat(44 * (allClinicsForVacation?.count ?? 0) + 31)
        self.aulaSeparator.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        listSelection = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allClinicsForVacation?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCustomTableViewCell", for: indexPath) as? DropDownCustomTableViewCell else { fatalError("Unexpected Error") }
        cell.selectionStyle = .none
        cell.lblDropDownTitle.text = allClinicsForVacation?[indexPath.row].name ?? String.blank
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clinicTextLabel.text = allClinicsForVacation?[indexPath.row].name ?? String.blank
        selectedClinicId = allClinicsForVacation?[indexPath.row].id ?? 0
        hideClinicDropDown()
    }
    
    func mangeAddDateView(dateViewConstant: AddDateModel, addtimeButtonHeight: CGFloat, addDateViewHeight: CGFloat, addVacationBtnTop: CGFloat) {
        dateFromLabelHeightConstraint.constant = dateViewConstant.dateToLabelHeight
        dateFromHeightConstraint.constant = dateViewConstant.dateFromHeight
        dateToLabelHeightConstraint.constant = dateViewConstant.dateToLabelHeight
        dateToHeightConstraint.constant = dateViewConstant.dateToHeight
        addTimeBtnHeightConstraint.constant = addtimeButtonHeight
        addDateViewHeightConstraint.constant = addDateViewHeight
        addVacationBtnTopConstraint.constant = addVacationBtnTop
    }
    
    func manageAddTimeView(timeViewConstant: AddTimeModel, addtimeViewHeight: CGFloat, addDateViewHeight: CGFloat) {
        timeFromLabelHeightConstraint.constant = timeViewConstant.timeFromLabelHeight
        timeFromHeightConstraint.constant = timeViewConstant.timeFromHeight
        timeToLabelHeightConstraint.constant = timeViewConstant.timeToLabelHeight
        timeToHeightConstraint.constant = timeViewConstant.timeToHeight
        addTimeViewHeightConstraint.constant = addtimeViewHeight
        addDateViewHeightConstraint.constant = addDateViewHeight
    }

}

extension VacationScheduleViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}
