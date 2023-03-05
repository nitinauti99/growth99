//
//  leadListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 29/11/22.
//

import UIKit

protocol leadListTableViewCellDelegate: AnyObject {
    func removeLead(cell: leadListTableViewCell, index: IndexPath)
    func editLead(cell: leadListTableViewCell, index: IndexPath)
    func detailLead(cell: leadListTableViewCell, index: IndexPath)
}

class leadListTableViewCell: UITableViewCell {
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var leadStatusImage: UIImageView!
    @IBOutlet private weak var amount: UILabel!
    @IBOutlet private weak var leadStatusLbi: UILabel!
    @IBOutlet private weak var leadFormNameLbi: UILabel!
    @IBOutlet private weak var leadSourceLbi: UILabel!

    var indexPath = IndexPath()
    weak var delegate: leadListTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
    }

    func configureCell(leadVM: leadListViewModelProtocol?, index: IndexPath) {
        let leadVM = leadVM?.leadPeginationListDataAtIndex(index: index.row)
        fullName.text = leadVM?.fullName
        email.text = leadVM?.Email
        id.text = String(leadVM?.id ?? 0)
        phoneNumber.text = leadVM?.PhoneNumber
        createdAt.text =  self.serverToLocal(date: leadVM?.createdAt ?? String.blank)
        amount.text = String(leadVM?.amount ?? 0)
        let movement = leadVM?.leadStatus
        leadStatusLbi.text = leadVM?.leadStatus
        leadStatusImage.image = UIImage(named: movement ?? String.blank)
        leadFormNameLbi.text = leadVM?.questionnaireName
        leadSourceLbi.text = leadVM?.leadSource
        indexPath = index
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
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM dd yyyy h:mm a"
        return dateFormatter.string(from: date as Date)
    }
    
}

enum LeaadStatus: String{
    case HOT = "hot"
    case NEW = "new"
    case COLD = "cold"
    case WON = "won"
    case WARM = "warm"
    case DEAD = "dead"

    var leadSatus: String {
        switch self {
        case .HOT:
            return "HOT"
        case .COLD:
            return "COLD"
        case .NEW:
            return "NEW"
        case .DEAD:
            return "COLD"
        case .WON:
            return "WON"
        case .WARM:
            return "WARM"
        }
    }
}

