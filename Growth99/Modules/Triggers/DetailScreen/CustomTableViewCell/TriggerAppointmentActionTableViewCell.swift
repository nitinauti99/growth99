//
//  TriggerDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerPatientCellDelegate: AnyObject {
    func nextButtonPatient(cell: TriggerAppointmentActionTableViewCell, index: IndexPath)
}

class TriggerAppointmentActionTableViewCell: UITableViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    
    @IBOutlet weak var patientAppointmentButton: UIButton!
    @IBOutlet weak var patientAppointmentView: UIView!
    @IBOutlet weak var patientAppointmenTextLabel: UILabel!
    @IBOutlet weak var patientAppointmentEmptyTextLbl: UILabel!

    weak var delegate: TriggerPatientCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        
        patientAppointmentView.layer.cornerRadius = 4.5
        patientAppointmentView.layer.borderWidth = 1
        patientAppointmentView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonPatient(cell: self, index: indexPath)
    }
}
