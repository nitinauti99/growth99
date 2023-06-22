//
//  MassEmailandSMSEditDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSEditPatientCellDelegate: AnyObject {
    func nextButtonPatient(cell: MassEmailandSMSEditPatientActionTableViewCell, index: IndexPath)
    func patientStausButtonSelection(cell: MassEmailandSMSEditPatientActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func patientTagButtonSelection(cell: MassEmailandSMSEditPatientActionTableViewCell, index: IndexPath, buttonSender: UIButton)
    func patientAppointmentStatusTagBtnSelection(cell: MassEmailandSMSEditPatientActionTableViewCell, index: IndexPath, buttonSender: UIButton)
}

class MassEmailandSMSEditPatientActionTableViewCell: UITableViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet weak var patientNextButton: UIButton!
    
    @IBOutlet weak var patientStatusButton: UIButton!
    @IBOutlet weak var patientStatusTextField: CustomTextField!
    
    @IBOutlet weak var patientTagButton: UIButton!
    @IBOutlet weak var patientTagTextField: CustomTextField!
    @IBOutlet weak var patientTagTextFieldHight: NSLayoutConstraint!
    @IBOutlet weak var showPatientTagButton: UIButton!
    
    
    @IBOutlet weak var patientAppointmentStatusButton: UIButton!
    @IBOutlet weak var patientAppointmentStatusTextField: CustomTextField!
    @IBOutlet weak var patientAppointmentStatusTextFieldHight: NSLayoutConstraint!
    @IBOutlet weak var showPatientAppointmentStatusButton: UIButton!
    
    weak var delegate: MassEmailandSMSEditPatientCellDelegate?
    var indexPath = IndexPath()
    var tableView: UITableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(tableView: UITableView?, index: IndexPath) {
        self.indexPath = index
        self.tableView = tableView
    }
    
    @IBAction func showPatientTagTextField(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            patientTagTextFieldHight.constant = 0
            patientTagTextField.rightImage = nil
            patientTagTextField.text = ""
        } else {
            sender.isSelected = true
            patientTagTextFieldHight.constant = 45
            patientTagTextField.rightImage = UIImage(named: "dropDown")
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    @IBAction func showPatientAppointmentStatusTextField(sender: UIButton){
        if sender.isSelected {
            sender.isSelected = false
            patientAppointmentStatusTextFieldHight.constant = 0
            patientAppointmentStatusTextField.rightImage = nil
            patientAppointmentStatusTextField.text = ""
        } else {
            sender.isSelected = true
            patientAppointmentStatusTextFieldHight.constant = 45
            patientAppointmentStatusTextField.rightImage = UIImage(named: "dropDown")
        }
        self.tableView?.performBatchUpdates(nil, completion: nil)
    }
    
    @IBAction func patientStatusButtonAction(sender: UIButton) {
        self.delegate?.patientStausButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
        
    @IBAction func patientTagButtonAction(sender: UIButton) {
        self.delegate?.patientTagButtonSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func patientAppointmentStatusTagBtnAction(sender: UIButton) {
        self.delegate?.patientAppointmentStatusTagBtnSelection(cell: self, index: indexPath, buttonSender: sender)
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonPatient(cell: self, index: indexPath)
    }
}

