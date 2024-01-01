//
//  MessageCell.swift
//  Growth99
//
//  Created by Sravan Goud on 04/12/23.
//

import UIKit

class MessageCellReceiver: UITableViewCell {
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageBubbleLine: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}