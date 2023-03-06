//
//  DeletedDeletedLeadListTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 06/03/23.
//

import UIKit

class DeletedLeadListTableViewCell: UITableViewCell {
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var deletedDate: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var leadStatusImage: UIImageView!
    @IBOutlet private weak var leandingPage: UILabel!
    @IBOutlet private weak var leadStatusLbi: UILabel!
    @IBOutlet private weak var deletedBy: UILabel!
    @IBOutlet private weak var leadSourceLbi: UILabel!

    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }

    func configureCell(leadVM: DeletedLeadListViewModelProtocol?, index: IndexPath) {
        let leadVM = leadVM?.deletedLeadListDataAtIndex(index: index.row)
        fullName.text = leadVM?.fullName
        email.text = leadVM?.email
        id.text = String(leadVM?.id ?? 0)
        phoneNumber.text = leadVM?.phoneNumber
        deletedDate.text =  self.serverToLocal(date: leadVM?.deletedAt ?? String.blank)
        deletedBy.text = leadVM?.deletedBy
        let movement = leadVM?.leadStatus
        leadStatusLbi.text = leadVM?.leadStatus
        leadStatusImage.image = UIImage(named: movement ?? String.blank)
        leadSourceLbi.text = leadVM?.leadSource
        leandingPage.text = leadVM?.landingPage
        indexPath = index
    }
    
    func configureCellWithSearch(leadVM: DeletedLeadListViewModelProtocol?, index: IndexPath) {
        let leadVM = leadVM?.deletedLeadListDataAtIndex(index: index.row)
        fullName.text = leadVM?.fullName
        email.text = leadVM?.email
        id.text = String(leadVM?.id ?? 0)
        phoneNumber.text = leadVM?.phoneNumber
        deletedDate.text =  self.serverToLocal(date: leadVM?.deletedAt ?? String.blank)
        deletedBy.text = leadVM?.deletedBy
        let movement = leadVM?.leadStatus
        leadStatusLbi.text = leadVM?.leadStatus
        leadStatusImage.image = UIImage(named: movement ?? String.blank)
        leadSourceLbi.text = leadVM?.leadSource
        leandingPage.text = leadVM?.landingPage
        indexPath = index
    }
    
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM dd yyyy h:mm a"
        return dateFormatter.string(from: date as Date)
    }
    
}
