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
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }
    
    func configureCell(consentsVM: ConsentsListViewModelProtocol?, index: IndexPath) {
        let consentsVM = consentsVM?.consentsListAtIndex(index: index.row)
        self.consentName.text = consentsVM?.name
        self.appointmentID.text = String(consentsVM?.appointmentId ?? 0)
        self.consentStatus.text = consentsVM?.appointmentConsentStatus
        self.appointmentDate.text = consentsVM?.appointmentDate
        self.createdDate.text = dateFormater?.serverToLocal(date: consentsVM?.createdAt ?? "")
        self.signedDate.text = dateFormater?.serverToLocal(date: consentsVM?.signedDate ?? "")
    }
    
}
