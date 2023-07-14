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
    
    @IBOutlet private weak var appointmentId: UILabel!
    @IBOutlet private weak var patientId: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var templateName: UILabel!
    @IBOutlet private weak var bodyButton: UIButton!
    @IBOutlet private weak var dateAuditLabel: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    weak var delegate: AuditListTableViewCellDelegate?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCell(auditFilterList: AuditListModel?, index: IndexPath, isSearch: Bool) {
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
        self.dateAuditLabel.text = convertTimestamp(timestamp: auditFilterList?.date ?? "-")
        indexPath = index
    }
    
    func configureCell(auditList: AuditListModel?, index: IndexPath, isSearch: Bool) {
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
        self.dateAuditLabel.text = convertTimestamp(timestamp: auditList?.date ?? "-")
        indexPath = index
    }
    
   /* func convertTimestamp(timestamp: String) -> String {
        let timeZone =  UserRepository.shared.timeZone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
        if let date = dateFormatter.date(from: timestamp) {
            let usDateFormatter = DateFormatter()
            usDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
            usDateFormatter.timeZone = TimeZone(identifier: timeZone ?? "")
            let usDateString = usDateFormatter.string(from: date)
            return usDateString
        }
        
        return ""
    }*/
    
    func convertTimestamp(timestamp: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(identifier: "US/Alaska")

        if let date = dateFormatter.date(from: timestamp) {
            dateFormatter.dateFormat = "MMM d yyyy h:mm a"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Set the locale explicitly
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        } else {
            return "Invalid date format"
        }
    }


    
    @IBAction func auditBodyButtonPressed() {
        self.delegate?.auditBodyButtonPressed(cell: self, index: indexPath)
    }
}
