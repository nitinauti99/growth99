//
//  VacationScheduleViewController.swift
//  Growth99
//
//  Created by admin on 13/11/22.
//

import UIKit

class VacationScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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


    var clinicDataArr = [String]()
    var menuSelection: [Int] = []
    var listSelection: Bool = false
    private var menuVC = DrawerViewContoller()
    override func viewDidLoad() {
        super.viewDidLoad()
        let sidemenuVC = UIStoryboard(name: "DrawerViewContoller", bundle: Bundle.main).instantiateViewController(withIdentifier: "DrawerViewContoller")
        menuVC = sidemenuVC as! DrawerViewContoller
        setUpNavigationBar()
        setupUI()
        dateFromTextField.tintColor = .clear
        dateFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = dateFromTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let todaysDate = Date()
            datePicker.minimumDate = todaysDate
            dateFromTextField.text = dateFormatter.string(from: datePicker.date)
            dateFromTextField.resignFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clinicDataArr = ["Home", "Orders", "Favorite Products"]
        clinicTextLabel.text = clinicDataArr[0]
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
        mangeAddDateView(dateViewConstant: AddDateModel.init(dateFromLabelHeight: 0, dateFromHeight: 0, dateToLabelHeight: 0, dateToHeight: 0), addtimeButtonHeight: 0, addDateViewHeight: 0, addVacationBtnTop: 0)
        manageAddTimeView(timeViewConstant: AddTimeModel(timeFromLabelHeight: 0, timeFromHeight: 0, timeToLabelHeight: 0, timeToHeight: 0), addtimeViewHeight: 0, addDateViewHeight: 0)
    }
    
    func getDataDropDown() {
//        viewModel.getuserRolesPractices { (response, error, _) in
//            if error == nil && response != nil {
//                self.removeSpinner()
//                self.dashboardTableView.reloadData()
//            }
//        }
    }
    
    @objc func sideMenuTapped(_ sender: UIButton) {
        menuVC.revealSideMenu()
    }
    
    @IBAction func saveVacationButtonAction(sender: UIButton) {
        
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
        self.listExpandHeightConstraint.constant = CGFloat(44 * clinicDataArr.count + 31)
        self.aulaSeparator.backgroundColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        listSelection = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clinicDataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCustomTableViewCell", for: indexPath) as? DropDownCustomTableViewCell else { fatalError("Unexpected Error") }
        cell.selectionStyle = .none
        cell.lblDropDownTitle.text = clinicDataArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clinicTextLabel.text = clinicDataArr[indexPath.row]
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
