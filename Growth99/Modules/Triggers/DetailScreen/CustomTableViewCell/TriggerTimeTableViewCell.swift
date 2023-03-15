//
//  TriggerDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerTimeCellDelegate: AnyObject {
    func addAnotherConditionButton(cell: TriggerTimeTableViewCell, index: IndexPath)
    func buttontimeRangeStartTapped(cell: TriggerTimeTableViewCell)
    func buttontimeRangeEndTapped(cell: TriggerTimeTableViewCell)
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
    @IBOutlet weak var timeHourlyButton: UIButton!
    @IBOutlet weak var scheduledBasedOnButton: UIButton!

    weak var delegate: TriggerTimeCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        
        timeRangeStartTimeTF.tintColor = .clear
        timeRangeEndTimeTF.tintColor = .clear
        timeRangeStartTimeTF.addInputViewDatePicker(target: self, selector: #selector(timeRangeStartBtnPressed), mode: .time)
        timeRangeEndTimeTF.addInputViewDatePicker(target: self, selector: #selector(timeRangeEndBtnPressed), mode: .time)
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
        timeFrequencyButton.isSelected = !timeFrequencyButton.isSelected
        timeFrequencyView.isHidden = false
        timeRangeView.isHidden = true
        timeRangeButton.isSelected = false
    }
    
    @IBAction func timeRangeBtnAction(sender: UIButton) {
        timeRangeButton.isSelected = !timeRangeButton.isSelected
        timeFrequencyView.isHidden = true
        timeRangeView.isHidden = false
        timeFrequencyButton.isSelected = false
    }
    
    @IBAction func addAnotherConditionBtnAction(sender: UIButton) {
        self.delegate?.addAnotherConditionButton(cell: self, index: indexPath)
    }
}
