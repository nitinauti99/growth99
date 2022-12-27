//
//  WorkingCustomTableViewCell.swift
//  Growth99
//
//  Created by admin on 12/12/22.
//

import UIKit


protocol WorkingCellSubclassDelegate: AnyObject {
    func buttonWorkingtimeFromTapped(cell: WorkingCustomTableViewCell)
    func buttonWorkingtimeToTapped(cell: WorkingCustomTableViewCell)
}

class WorkingCustomTableViewCell: UITableViewCell, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var timeFromTextField: CustomTextField!
    @IBOutlet weak var timeToTextField: CustomTextField!
    @IBOutlet weak var workingClinicTextLabel: UILabel!
    @IBOutlet weak var supportWorkingClinicTextLabel: UILabel!
    @IBOutlet weak var workingClinicErrorTextLabel: UILabel!
    @IBOutlet weak var workingClinicSelectonButton: UIButton!
    @IBOutlet weak var workingListExpandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var workingClinicSelectionTableView: UITableView!
    @IBOutlet weak var workingListTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var workingTextView: UIView!
    @IBOutlet weak var workingCellRowDelete: UIButton!
    @IBOutlet weak var subView: UIView!

    var string = String.blank
    var workingListSelection: Bool = false
    var userScheduleTimings: [UserScheduleTimings]?
    var daysViewModel = WorkingDaysViewModel()
    var daySelectionArray: [String] = []

    var buttoneRemoveDaysTapCallback: () -> ()  = { }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        workingClinicSelectionTableView.allowsMultipleSelection = true
        timeFromTextField.tintColor = .clear
        timeToTextField.tintColor = .clear
        timeFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), mode: .time)
        timeToTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed1), mode: .time)
        workingClinicSelectionTableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        workingTextView.layer.cornerRadius = 4.5
        workingTextView.layer.borderWidth = 1
        workingTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        subView.layer.borderWidth = 1
        subView.layer.borderColor = UIColor.red.cgColor

    }
    
    weak var delegate: WorkingCellSubclassDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    
    @objc func doneButtonPressed() {
        self.delegate?.buttonWorkingtimeFromTapped(cell: self)
    }
    
    @objc func doneButtonPressed1() {
        self.delegate?.buttonWorkingtimeToTapped(cell: self)
    }
    
    func updateTimeFromTextField(with content: String) {
        timeFromTextField.text = content
    }
    
    func updateTimeToTextField(with content: String) {
        timeToTextField.text = content
    }
    
    func updateTextLabel(with content: [String]?) {
        self.supportWorkingClinicTextLabel.text = content?.joined(separator: ",")
        if content?.count ?? 0 > 3 {
            workingClinicTextLabel.text = "\(content?.count ?? 0) days"
        } else {
            let sentence = content?.joined(separator: ", ")
            workingClinicTextLabel.text = sentence
        }
    }
    
    @IBAction func deleteWorkingButtonAction(sender: UIButton) {
        buttoneRemoveDaysTapCallback()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysViewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell {
            cell.item = daysViewModel.items[indexPath.row]
            if daysViewModel.items[indexPath.row].isSelected {
                if !cell.isSelected {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                if cell.isSelected {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        daysViewModel.items[indexPath.row].isSelected = true
        if daysViewModel.selectedItems.count == 0 {
            workingClinicTextLabel.text = "Select day"
        } else if daysViewModel.selectedItems.count > 3 {
            workingClinicTextLabel.text = "\(daysViewModel.selectedItems.count) days"
            workingClinicErrorTextLabel.isHidden = true
        } else {
            workingClinicTextLabel.text = daysViewModel.selectedItems.map({$0.title}).joined(separator: ", ")
            workingClinicErrorTextLabel.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        daysViewModel.items[indexPath.row].isSelected = false
        if daysViewModel.selectedItems.count == 0 {
            workingClinicTextLabel.text = "Select day"
        } else if daysViewModel.selectedItems.count > 3 {
            workingClinicTextLabel.text = "\(daysViewModel.selectedItems.count) days"
            workingClinicErrorTextLabel.isHidden = true
        } else {
            workingClinicTextLabel.text = daysViewModel.selectedItems.map({$0.title}).joined(separator: ", ")
            workingClinicErrorTextLabel.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    @IBAction func workingClinicSelectionButton(sender: UIButton) {
//        if workingListSelection == true {
//            workingHideClinicDropDown()
//        } else {
//            workingShowClinicDropDown()
//        }
        
    }
    
    func workingHideClinicDropDown() {
        workingListSelection = false
        workingListTableViewHeightConstraint.constant = 1
    }
    
    func workingShowClinicDropDown() {
        workingListTableViewHeightConstraint.constant = CGFloat(21 * (daysViewModel.items.count) + 90)
        workingListSelection = true
    }
}
