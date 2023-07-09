//
//  ConsentsListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import UIKit

class ConsentsListTableViewCell: UITableViewCell {
    @IBOutlet private weak var consentName: UILabel!
    @IBOutlet private weak var appointmentID: UILabel!
    @IBOutlet private weak var consentStatus: UILabel!
    @IBOutlet private weak var appointmentDate: UILabel!
    @IBOutlet private weak var signedDate: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var subView: UIView!

    var dateFormater : DateFormaterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }
    
    func configureCellWithSearch(consentsVM: ConsentsListViewModelProtocol?, index: IndexPath) {
        let consentsVM = consentsVM?.consentsFilterListAtIndex(index: index.row)
        self.consentName.text = consentsVM?.name
        let id = consentsVM?.appointmentId ?? 0
        if id == 0 {
            self.appointmentID.text = "-"
        }else{
            self.appointmentID.text = String(id)
        }
        self.consentStatus.text = consentsVM?.appointmentConsentStatus
        self.appointmentDate.text = dateFormater?.serverToLocalPateintsAppointment(date: consentsVM?.appointmentDate ?? String.blank)
        self.createdDate.text = dateFormater?.serverToLocalDateConverter(date: consentsVM?.createdAt ?? String.blank)
        self.signedDate.text = dateFormater?.serverToLocalDateConverter(date: consentsVM?.signedDate ?? String.blank)
    }
    
    func configureCell(consentsVM: ConsentsListViewModelProtocol?, index: IndexPath) {
        let consentsVM = consentsVM?.consentsListAtIndex(index: index.row)
        self.consentName.text = consentsVM?.name
        let id = consentsVM?.appointmentId ?? 0
        if id == 0 {
            self.appointmentID.text = "-"
        }else{
            self.appointmentID.text = String(id)
        }
        self.consentStatus.text = consentsVM?.appointmentConsentStatus
        self.appointmentDate.text = dateFormater?.serverToLocalPateintsAppointment(date: consentsVM?.appointmentDate ?? String.blank)
        self.createdDate.text = dateFormater?.serverToLocalDateConverter(date: consentsVM?.createdAt ?? String.blank)
        self.signedDate.text = dateFormater?.serverToLocalDateConverter(date: consentsVM?.signedDate ?? String.blank)
    }
}
