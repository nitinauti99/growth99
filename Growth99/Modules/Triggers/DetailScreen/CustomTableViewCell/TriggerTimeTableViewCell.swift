//
//  TriggerDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerTimeCellDelegate: AnyObject {
    func addAnotherConditionButton(cell: TriggerTimeTableViewCell, index: IndexPath)
    func nextBtnAction(cell: TriggerTimeTableViewCell, index: IndexPath)
    func buttontimeRangeStartTapped(cell: TriggerTimeTableViewCell)
    func buttontimeRangeEndTapped(cell: TriggerTimeTableViewCell)
    
    func hourlyNetworkButton(cell: TriggerTimeTableViewCell, index: IndexPath)
    func scheduledBasedOnButton(cell: TriggerTimeTableViewCell, index: IndexPath)
    
}

class TriggerTimeTableViewCell: UITableViewCell {
    
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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var orLbl: UILabel!

    @IBOutlet weak var timeHourlyButton: UIButton!
    @IBOutlet weak var scheduledBasedOnButton: UIButton!
    
    weak var delegate: TriggerTimeCellDelegate?
    var indexPath = IndexPath()
    var timerTypeSelected: String = "Frequency"
    var trigerTimeData: [TriggerEditData] = []
    let radioController: RadioButtonController = RadioButtonController()
    
    
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
    
    func configureCell(triggerEditData: [TriggerEditData]?, index: IndexPath, moduleSelectionTypeTrigger: String, selectedNetworkType: String, parentViewModel: TriggerEditDetailViewModelProtocol?){
        self.indexPath = index
        self.trigerTimeData = triggerEditData ?? []
        
        if triggerEditData?[0].triggerTarget == "lead" {
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
        if triggerEditData?[0].timerType == "Frequency" {
            self.timeFrequencyButton.isSelected = true
            self.timeRangeButton.isSelected = false
        } else {
            self.timeFrequencyButton.isSelected = false
            self.timeRangeButton.isSelected = true
        }
        self.timeHourlyButton.tag = indexPath.row
        self.timeHourlyButton.addTarget(self, action: #selector(timeHourlySelectionMethod), for: .touchDown)
        self.scheduledBasedOnButton.tag = indexPath.row
        self.scheduledBasedOnButton.addTarget(self, action: #selector(scheduledBasedOnMethod), for: .touchDown)
        self.timeHourlyTextField.text = triggerEditData?[0].triggerFrequency ?? ""
        let triggerTime = triggerEditData?[0].triggerTime
        self.timeDurationTextField.text = String(triggerTime ?? 0)
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
    
    @IBAction func addAnotherConditionBtnAction(sender: UIButton) {
        self.delegate?.addAnotherConditionButton(cell: self, index: indexPath)
    }
    
    @IBAction func nextBtnAction(sender: UIButton) {
        self.delegate?.nextBtnAction(cell: self, index: indexPath)
    }
}
