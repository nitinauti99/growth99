//
//  MassEmailandSMSTableViewCell.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol AuditListTableViewCellDelegate: AnyObject {
    func auditBodyButtonPressed(cell: AuditListTableViewCell, index: IndexPath)
}

class AuditListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var appointmentLabel: UILabel!
    @IBOutlet private weak var appointmentId: UILabel!
    @IBOutlet private weak var patientLabel: UILabel!
    @IBOutlet private weak var patientLabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var patientId: UILabel!
    @IBOutlet private weak var patientIdHeight: NSLayoutConstraint!
    @IBOutlet private weak var patientIdBottom: NSLayoutConstraint!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var templateName: UILabel!
    @IBOutlet private weak var bodyButton: UIButton!
    @IBOutlet private weak var dateAuditLabel: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    weak var delegate: AuditListTableViewCellDelegate?
    var indexPath = IndexPath()
    var dateFormater : DateFormaterProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }
    
    func configureCell(triggerModuleType: String, auditFilterList: AuditListModel?, index: IndexPath, isSearch: Bool) {
        
        if triggerModuleType == "MassPatient" {
            appointmentLabel.text = "Appointment ID"
            patientIdHeight.constant = 15
            patientLabelHeight.constant = 20
            patientIdBottom.constant = 15
        } else if triggerModuleType == "MassLead"{
            appointmentLabel.text = "Lead ID"
            patientIdHeight.constant = 0
            patientLabelHeight.constant = 0
            patientIdBottom.constant = 0
        } else {
            appointmentLabel.text = "Lead/Patient ID"
            patientIdHeight.constant = 0
            patientLabelHeight.constant = 0
            patientIdBottom.constant = 0
        }
        
        if let leadId = auditFilterList?.leadId {
            if leadId != 0 {
                self.appointmentId.text = String(leadId)
            } else {
                self.appointmentId.text = "-"
            }
        } else {
            self.appointmentId.text = "-"
        }
        
        if let patientId = auditFilterList?.patientId {
            if patientId != 0 {
                self.patientId.text = String(patientId)
            } else {
                self.patientId.text = "-"
            }
        } else {
            self.patientId.text = "-"
        }
        
        self.emailLabel.text = auditFilterList?.email ?? "-"
        self.templateName.text = auditFilterList?.templateName ?? "-"
        self.dateAuditLabel.text = dateFormater?.serverToLocalPateintTimeLineDate(date: auditFilterList?.date ?? "-")
        indexPath = index
    }
    
    func configureCell(triggerModuleType: String, auditList: AuditListModel?, index: IndexPath, isSearch: Bool) {
        
        if triggerModuleType == "MassPatient" {
            appointmentLabel.text = "Appointment ID"
            patientIdHeight.constant = 15
            patientLabelHeight.constant = 20
            patientIdBottom.constant = 15
        } else if triggerModuleType == "MassLead"{
            appointmentLabel.text = "Lead ID"
            patientIdHeight.constant = 0
            patientLabelHeight.constant = 0
            patientIdBottom.constant = 0
        } else {
            appointmentLabel.text = "Lead/Patient ID"
            patientIdHeight.constant = 0
            patientLabelHeight.constant = 0
            patientIdBottom.constant = 0
        }
        
        if let leadId = auditList?.leadId {
            if leadId != 0 {
                self.appointmentId.text = String(leadId)
            } else {
                self.appointmentId.text = "-"
            }
        } else {
            self.appointmentId.text = "-"
        }
        
        if let patientId = auditList?.patientId {
            if patientId != 0 {
                self.patientId.text = String(patientId)
            } else {
                self.patientId.text = "-"
            }
        } else {
            self.patientId.text = "-"
        }
        
        self.emailLabel.text = auditList?.email ?? "-"
        self.templateName.text = auditList?.templateName ?? "-"
        self.dateAuditLabel.text = dateFormater?.serverToLocalPateintTimeLineDate(date: auditList?.date ?? "-")
        indexPath = index
    }
    
    @IBAction func auditBodyButtonPressed() {
        self.delegate?.auditBodyButtonPressed(cell: self, index: indexPath)
    }
}
