//
//  EmptyEventsTableViewCell.swift
//  Growth99
//
//  Created by Exaze Technologies on 16/01/23.
//

import UIKit

class EmptyEventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventsLineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eventsLineView.roundCornersView(corners: [.topLeft, .bottomLeft], radius: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
