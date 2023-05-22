//
//  LeadHistoryListTableViewCell.swift
//  Growth99
//
//  Created by Nitin Auti on 05/03/23.
//

import UIKit

protocol LeadHistoryListTableViewCellDelegate: AnyObject {
    func removeLead(cell: LeadHistoryListTableViewCell, index: IndexPath)
    func editLead(cell: LeadHistoryListTableViewCell, index: IndexPath)
    func detailLead(cell: LeadHistoryListTableViewCell, index: IndexPath)
}

class LeadHistoryListTableViewCell: UITableViewCell {
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var source: UILabel!
    @IBOutlet private weak var leadStatus: UILabel!
    @IBOutlet private weak var landingPages: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    var indexPath = IndexPath()
    weak var delegate: LeadHistoryListTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }
    
    func configureCellWithSearch(userVM: LeadHistoryViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.leadHistoryFilterDataAtIndex(index: index.row)
        self.name.text = (userVM?.firstName ?? "") + " " +  (userVM?.lastName ?? "")
        self.id.text = String(userVM?.id ?? 0)
        self.email.text = userVM?.email
        self.phoneNumber.text = userVM?.phoneNumber
        self.source.text = userVM?.leadSource
        self.leadStatus.text = userVM?.leadStatus
        self.landingPages.text = userVM?.landingPage
        self.createdDate.text =  self.serverToLocal(date: userVM?.createdAt ?? String.blank)
        indexPath = index
    }
    
    func configureCell(userVM: LeadHistoryViewModelProtocol?, index: IndexPath) {
        let userVM = userVM?.leadHistoryDataAtIndex(index: index.row)
        self.name.text = (userVM?.firstName ?? "") + " " +  (userVM?.lastName ?? "")
        self.id.text = String(userVM?.id ?? 0)
        self.email.text = userVM?.email
        self.phoneNumber.text = userVM?.phoneNumber
        self.source.text = userVM?.leadSource
        self.leadStatus.text = userVM?.leadStatus
        self.landingPages.text = userVM?.landingPage
        self.createdDate.text =  self.serverToLocal(date: userVM?.createdAt ?? String.blank)
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
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeLead(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editLead(cell: self, index: indexPath)
    }
    
    @IBAction func detailButtonPressed() {
        self.delegate?.detailLead(cell: self, index: indexPath)
    }
}
