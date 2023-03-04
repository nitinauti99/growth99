//
//  leadTimeLineTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 02/01/23.
//

import UIKit

class leadTimeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var createdDateTime: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        type.layer.borderWidth = 1
        type.layer.borderColor = UIColor.init(hexString: "009EDE").cgColor
        type.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
