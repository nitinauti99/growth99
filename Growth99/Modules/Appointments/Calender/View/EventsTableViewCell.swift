//
//  EventsTableViewCell.swift
//  Growth99
//
//  Created by admin on 25/12/22.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var eventsLineView: UIView!
    @IBOutlet weak var eventsTitle: UILabel!
    @IBOutlet weak var eventsDuration: UILabel!
    @IBOutlet weak var eventsDate: UIButton!

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
