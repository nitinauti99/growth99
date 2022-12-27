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

class WorkingCustomTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var timeFromTextField: CustomTextField!
    @IBOutlet weak var timeToTextField: CustomTextField!
    @IBOutlet weak var workingClinicTextLabel: UILabel!
    @IBOutlet weak var supportWorkingClinicTextLabel: UILabel!
    @IBOutlet weak var workingClinicErrorTextLabel: UILabel!
    @IBOutlet weak var workingClinicSelectonButton: UIButton!
    @IBOutlet weak var workingListExpandHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var workingTextView: UIView!
    @IBOutlet weak var workingCellRowDelete: UIButton!
    @IBOutlet weak var subView: UIView!

    var userScheduleTimings: [UserScheduleTimings]?
    var buttoneRemoveDaysTapCallback: () -> ()  = { }
    weak var delegate: WorkingCellSubclassDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeFromTextField.tintColor = .clear
        timeToTextField.tintColor = .clear
        timeFromTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed), mode: .time)
        timeToTextField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed1), mode: .time)
        workingTextView.layer.cornerRadius = 4.5
        workingTextView.layer.borderWidth = 1
        workingTextView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        subView.layer.borderWidth = 1
        subView.layer.cornerRadius = 5
        subView.layer.borderColor = UIColor.init(hexString: "#009EDE").cgColor
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
        self.supportWorkingClinicTextLabel.text = content?.joined(separator: ",")
        if content?.count ?? 0 > 3 {
            workingClinicTextLabel.text = "\(content?.count ?? 0) \(Constant.Profile.days)"
        } else {
            let sentence = content?.joined(separator: ", ")
            workingClinicTextLabel.text = sentence
        }
    }
    
    @IBAction func deleteWorkingButtonAction(sender: UIButton) {
        buttoneRemoveDaysTapCallback()
    }
}
