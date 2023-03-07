//
//  MassEmailandSMSDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol MassEmailandSMSPatientCellDelegate: AnyObject {
    func nextButtonPatient(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath)
}

class MassEmailandSMSPatientActionTableViewCell: UITableViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet weak var patientStatusSelectonButton: UIButton!
    @IBOutlet weak var patientTagSelectonButton: UIButton!
    @IBOutlet weak var patientAppointmentButton: UIButton!
    @IBOutlet weak var patientStatusView: UIView!
    @IBOutlet weak var patientTagView: UIView!
    @IBOutlet weak var patientAppointmentView: UIView!
    @IBOutlet weak var patientStatusTextLabel: UILabel!
    @IBOutlet weak var patientTagTextLabel: UILabel!
    @IBOutlet weak var patientAppointmenTextLabel: UILabel!

    weak var delegate: MassEmailandSMSPatientCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        
        patientStatusView.layer.cornerRadius = 4.5
        patientStatusView.layer.borderWidth = 1
        patientStatusView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        patientTagView.layer.cornerRadius = 4.5
        patientTagView.layer.borderWidth = 1
        patientTagView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        patientAppointmentView.layer.cornerRadius = 4.5
        patientAppointmentView.layer.borderWidth = 1
        patientAppointmentView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonPatient(cell: self, index: indexPath)
    }
}
