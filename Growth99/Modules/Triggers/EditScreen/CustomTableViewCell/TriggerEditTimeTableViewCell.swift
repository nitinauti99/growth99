//
//  TriggerEditTimeTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerEditTimeCellDelegate: AnyObject {
    func addAnotherConditionButton(cell: TriggerEditTimeTableViewCell, index: IndexPath)
    func buttontimeRangeStartTapped(cell: TriggerEditTimeTableViewCell)
    func buttontimeRangeEndTapped(cell: TriggerEditTimeTableViewCell)
    func hourlyNetworkButton(cell: TriggerEditTimeTableViewCell, index: IndexPath)
    func scheduledBasedOnButton(cell: TriggerEditTimeTableViewCell, index: IndexPath)
    func nextSubmitButton(cell: TriggerEditTimeTableViewCell, index: IndexPath)
}

class TriggerEditTimeTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet weak var triggerTimeFromTextField: CustomTextField!
    @IBOutlet weak var timeFrequencyView: UIView!
    @IBOutlet weak var timeFrequencyButton: UIButton!
    @IBOutlet weak var timeDurationTextField: CustomTextField!
    @IBOutlet weak var timeHourlyTextField: CustomTextField!
    @IBOutlet weak var scheduledBasedOnTextField: CustomTextField!
    @IBOutlet weak var scheduleBasedonLbl: UILabel!
    @IBOutlet weak var timeRangeView: UIView!
    @IBOutlet weak var timeRangeButton: UIButton!
    @IBOutlet weak var timeRangeStartTimeTF: CustomTextField!
    @IBOutlet weak var timeRangeEndTimeTF: CustomTextField!
    @IBOutlet weak var timeFrequencyLbl: UILabel!
    @IBOutlet weak var timeRangeLbl: UILabel!
    @IBOutlet weak var addAnotherConditionButton: UIButton!
    @IBOutlet weak var timeHourlyButton: UIButton!
    @IBOutlet weak var scheduledBasedOnButton: UIButton!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    var indexPath = IndexPath()
    var timerTypeSelected: String = "Frequency"
    var trigerTimeData: [TriggerEditData] = []
    weak var delegate: TriggerEditTimeCellDelegate?
    let radioController: RadioButtonController = RadioButtonController()
    
    var triggerStartTime: String = ""
    var triggerEndTime: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        
        timeRangeStartTimeTF.tintColor = .clear
        timeRangeEndTimeTF.tintColor = .clear
        timeRangeStartTimeTF.addInputViewDatePicker(target: self, selector: #selector(timeRangeStartBtnPressed), mode: .time)
        timeRangeEndTimeTF.addInputViewDatePicker(target: self, selector: #selector(timeRangeEndBtnPressed), mode: .time)
        radioController.buttonsArray = [timeFrequencyButton, timeRangeButton]
        radioController.defaultButton = timeFrequencyButton
    }
    
    func configureCellTime(index: IndexPath, moduleSelectionTypeTrigger: String, arrayCount: Int) {
        self.indexPath = index
        let yourLastRowIndex = arrayCount - 1
        if index.row == yourLastRowIndex {
            // If it's the last row, show the 'addAnotherConditionButton'
            addAnotherConditionButton.isHidden = false
            orLbl.isHidden = false
            nextButton.isHidden = false
        } else {
            // If it's not the last row, hide the 'addAnotherConditionButton'
            addAnotherConditionButton.isHidden = true
            orLbl.isHidden = true
            nextButton.isHidden = true
        }
        self.timeHourlyButton.tag = indexPath.row
        self.timeHourlyButton.addTarget(self, action: #selector(timeHourlySelectionMethod), for: .touchDown)
        self.scheduledBasedOnButton.tag = indexPath.row
        self.scheduledBasedOnButton.addTarget(self, action: #selector(scheduledBasedOnMethod), for: .touchDown)
        
        if moduleSelectionTypeTrigger == "leads" {
            self.timeRangeView.isHidden = false
            self.timeFrequencyLbl.isHidden = false
            self.timeRangeLbl.isHidden = false
            self.scheduledBasedOnTextField.isHidden = true
            self.scheduleBasedonLbl.isHidden = true
            self.timeFrequencyButton.isHidden = false
            self.timeRangeButton.isHidden = false
            self.scheduledBasedOnButton.isEnabled = false
        } else {
            self.timeRangeView.isHidden = true
            self.timeFrequencyLbl.isHidden = true
            self.timeRangeLbl.isHidden = true
            self.scheduledBasedOnTextField.isHidden = false
            self.scheduleBasedonLbl.isHidden = false
            self.timeFrequencyButton.isHidden = true
            self.timeRangeButton.isHidden = true
            self.scheduledBasedOnButton.isEnabled = true
        }
        self.timeDurationTextField.text = "0"
        self.timeHourlyTextField.text = "Min"
        self.scheduledBasedOnTextField.text = "Appointment Created Date"
    }
    
    func configureCell(tableView: UITableView?, index: IndexPath, triggerEditData: TriggerEditData?, parentViewModel: TriggerEditDetailViewModelProtocol?, viewController: UIViewController, moduleSelectionTypeTrigger: String, arrayCount: Int) {
        
        self.indexPath = index
        let yourLastRowIndex = arrayCount - 1
        if index.row == yourLastRowIndex {
            // If it's the last row, show the 'addAnotherConditionButton'
            addAnotherConditionButton.isHidden = false
            orLbl.isHidden = false
            nextButton.isHidden = false
        } else {
            // If it's not the last row, hide the 'addAnotherConditionButton'
            addAnotherConditionButton.isHidden = true
            orLbl.isHidden = true
            nextButton.isHidden = true
        }
        
        if triggerEditData?.triggerTarget == "lead"  {
            self.timeRangeView.isHidden = false
            self.timeFrequencyLbl.isHidden = false
            self.timeRangeLbl.isHidden = false
            self.scheduledBasedOnTextField.isHidden = true
            self.scheduleBasedonLbl.isHidden = true
            self.timeFrequencyButton.isHidden = false
            self.timeRangeButton.isHidden = false
            self.scheduledBasedOnButton.isEnabled = false
        } else if triggerEditData?.triggerTarget == "Clinic" {
            self.scheduledBasedOnTextField.isHidden = true
            self.scheduleBasedonLbl.isHidden = true
        } else {
            self.timeRangeView.isHidden = true
            self.timeFrequencyLbl.isHidden = true
            self.timeRangeLbl.isHidden = true
            self.scheduledBasedOnTextField.isHidden = false
            self.scheduleBasedonLbl.isHidden = false
            self.timeFrequencyButton.isHidden = true
            self.timeRangeButton.isHidden = true
            self.scheduledBasedOnButton.isEnabled = true
        }
        
        if triggerEditData?.timerType == "Frequency" {
            self.timeFrequencyButton.isSelected = true
            self.timeRangeButton.isSelected = false
            timeFrequencyView.isHidden = false
            timeRangeView.isHidden = true
        } else {
            self.timeFrequencyButton.isSelected = false
            self.timeRangeButton.isSelected = true
            timeFrequencyView.isHidden = true
            timeRangeView.isHidden = false
        }
        
        self.timeHourlyButton.tag = indexPath.row
        self.timeHourlyButton.addTarget(self, action: #selector(timeHourlySelectionMethod), for: .touchDown)
        self.scheduledBasedOnButton.tag = indexPath.row
        self.scheduledBasedOnButton.addTarget(self, action: #selector(scheduledBasedOnMethod), for: .touchDown)
        self.timerTypeSelected = triggerEditData?.timerType ?? ""
        self.timeHourlyTextField.text = triggerEditData?.triggerFrequency ?? ""
        let triggerTime = triggerEditData?.triggerTime
        self.timeDurationTextField.text = String(triggerTime ?? 0).replacingOccurrences(of: "-", with: "")
        if triggerEditData?.dateType == "APPOINTMENT_CREATED" {
            self.scheduledBasedOnTextField.text = "Appointment Created Date"
        } else if triggerEditData?.dateType == "APPOINTMENT_BEFORE" {
            self.scheduledBasedOnTextField.text = "Before Appointment Date"
        } else {
            self.scheduledBasedOnTextField.text = "After Appointment Date"
        }
        timeRangeStartTimeTF.text = extractTime(from: triggerEditData?.startTime ?? "")
        timeRangeEndTimeTF.text = extractTime(from: triggerEditData?.endTime ?? "")
    }
    
    func extractTime(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
                if let date = dateFormatter.date(from: dateString) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            return timeFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    @IBAction func timeFrequencyBtnAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        timeFrequencyView.isHidden = false
        timeRangeView.isHidden = true
        timerTypeSelected = "Frequency"
    }
    
    @IBAction func timeRangeBtnAction(sender: UIButton) {
        radioController.buttonArrayUpdated(buttonSelected: sender)
        timeFrequencyView.isHidden = true
        timeRangeView.isHidden = false
        timerTypeSelected = "Range"
    }
    
    @objc func timeHourlySelectionMethod(sender: UIButton) {
        self.delegate?.hourlyNetworkButton(cell: self, index: indexPath)
    }
    
    @objc func scheduledBasedOnMethod(sender: UIButton) {
        self.delegate?.scheduledBasedOnButton(cell: self, index: indexPath)
    }
    
    // MARK: - Time from picker done method
    @objc func timeRangeStartBtnPressed() {
        self.delegate?.buttontimeRangeStartTapped(cell: self)
    }
    
    // MARK: - Time to picker done method
    @objc func timeRangeEndBtnPressed() {
        self.delegate?.buttontimeRangeEndTapped(cell: self)
    }
    
    // MARK: - Update textfield methos
    func updateTimeRangeStartTextField(with content: String) {
        timeRangeStartTimeTF.text = content
    }
    
    func updateTimeRangeEndTextField(with content: String) {
        timeRangeEndTimeTF.text = content
    }
    
    @IBAction func addAnotherConditionBtnAction(sender: UIButton) {
        self.delegate?.addAnotherConditionButton(cell: self, index: indexPath)
    }
    
    @IBAction func nextSubmitBtnAction(sender: UIButton) {
        self.delegate?.nextSubmitButton(cell: self, index: indexPath)
    }
}
