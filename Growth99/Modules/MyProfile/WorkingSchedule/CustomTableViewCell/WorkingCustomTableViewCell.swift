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
}

class WorkingCustomTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var selectDayTextField: CustomTextField!
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
        timeFromTextField.tintColor = .clear
        timeToTextField.tintColor = .clear
        timeFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), mode: .time)
        timeToTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed1), mode: .time)
        subView.layer.borderWidth = 1
        subView.layer.cornerRadius = 5
        subView.layer.borderColor = UIColor.init(hexString: "#009EDE").cgColor
    }
    
    func configureCell(index: IndexPath) {
        indexPath = index
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
        workingDaysSelected = content ?? []
    }
    
    @IBAction func deleteWorkingButtonAction(sender: UIButton) {
        buttoneRemoveDaysTapCallback()
    }
    
    @IBAction func selectDayBtnAction(sender: UIButton) {
        self.delegate?.selectDayButtonTapped(cell: self, index: indexPath)
    }
}
