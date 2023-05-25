//
//  PostCalendarTableViewCell.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit

class PostCalendarTableViewCell: UITableViewCell {

    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shortDateBtn: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var postLineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postLineView.roundCornersView(corners: [.topLeft, .bottomLeft], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
