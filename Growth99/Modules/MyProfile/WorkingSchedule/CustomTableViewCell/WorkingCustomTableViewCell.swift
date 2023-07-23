//
//  WorkingCustomTableViewCell.swift
//  Growth99
//
//  Created by admin on 12/12/22.
//

import UIKit


protocol WorkingCellSubclassDelegate: AnyObject {
    func selectDayButtonTapped(cell: WorkingCustomTableViewCell, index: IndexPath)
    func buttonWorkingtimeFromTapped(cell: WorkingCustomTableViewCell)
    func buttonWorkingtimeToTapped(cell: WorkingCustomTableViewCell)
    func deleteSelectedWorkingShedule(cell: WorkingCustomTableViewCell, indexPath: IndexPath)
}

class WorkingCustomTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var selectDayTextField: CustomTextField!
    @IBOutlet weak var selectDayTempTextField: CustomTextField!

    @IBOutlet weak var selectDayButton: UIButton!
    @IBOutlet weak var timeFromTextField: CustomTextField!
    @IBOutlet weak var timeToTextField: CustomTextField!
    @IBOutlet weak var workingClinicTextLabel: UILabel!
    @IBOutlet weak var workingClinicErrorTextLabel: UILabel!
    @IBOutlet weak var workingClinicSelectonButton: UIButton!
    @IBOutlet weak var workingListExpandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var workingTextView: UIView!
    @IBOutlet weak var workingCellRowDelete: UIButton!
    @IBOutlet weak var subView: UIView!

    var userScheduleTimings: [UserScheduleTimings]?
    var buttoneRemoveDaysTapCallback: () -> ()  = { }
    weak var delegate: WorkingCellSubclassDelegate?
    var indexPath = IndexPath()
    var workingDaysSelected = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.timeFromTextField.tintColor = .clear
        self.timeToTextField.tintColor = .clear
        self.subView.layer.borderWidth = 1
        self.subView.layer.cornerRadius = 5
        self.subView.layer.borderColor = UIColor.init(hexString: "#009EDE").cgColor
        self.timeFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), mode: .time)
        self.timeToTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed1), mode: .time)
    }
    
    func configureCell(index: IndexPath, viewModel: WorkingScheduleViewModelProtocol?) {
        self.indexPath = index
        let item =  viewModel?.getWorkingSheduleData
        let workingScheduleDays = item?[indexPath.section].userScheduleTimings?[indexPath.row].days
        self.updateTextLabel(with: workingScheduleDays)
        
        if item?[indexPath.section].userScheduleTimings?[indexPath.row].timeFromDate == "" {
            self.timeFromTextField.text = String.blank
        }else{
            self.timeFromTextField.text = viewModel?.serverToLocalTime(timeString: item?[indexPath.section].userScheduleTimings?[indexPath.row].timeFromDate ?? String.blank)
        }
        
        if item?[indexPath.section].userScheduleTimings?[indexPath.row].timeToDate == "" {
            self.timeFromTextField.text = String.blank
        }else{
            self.timeToTextField.text = viewModel?.serverToLocalTime(timeString: item?[indexPath.section].userScheduleTimings?[indexPath.row].timeToDate ?? String.blank)
        }
        
    }
    
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
        if content?.count ?? 0 > 3 {
            selectDayTextField.text = "\(content?.count ?? 0) \(Constant.Profile.days)"
        } else {
            let sentence = content?.joined(separator: ",")
            selectDayTextField.text = sentence
        }
        let sentence = content?.joined(separator: ", ")
        selectDayTempTextField.text = sentence
    }
    
    @IBAction func deleteWorkingButtonAction(sender: UIButton) {
        self.delegate?.deleteSelectedWorkingShedule(cell: self, indexPath: indexPath)
    }
    
    @IBAction func selectDayBtnAction(sender: UIButton) {
        self.delegate?.selectDayButtonTapped(cell: self, index: indexPath)
    }
}
