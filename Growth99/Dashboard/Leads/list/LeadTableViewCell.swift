//
//  LeadTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 29/11/22.
//

import UIKit

class LeadTableViewCell: UITableViewCell {
   
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var email: UILabel!
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var phoneNumber: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var subView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)

    }

    func configureCell(leadVM: leadViewModelProtocol?, index: IndexPath) {
        let leadVM = leadVM?.leadDataAtIndex(index: index.row)
        fullName.text = leadVM?.fullName
        email.text = leadVM?.Email
        id.text = String(leadVM?.id ?? 0)
        phoneNumber.text = leadVM?.PhoneNumber
        createdAt.text = leadVM?.createdAt
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
