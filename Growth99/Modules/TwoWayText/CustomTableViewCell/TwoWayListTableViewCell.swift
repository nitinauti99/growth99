//
//  TwoWayListTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 04/12/23.
//

import UIKit

class TwoWayListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet private weak var subView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
//        self.subView.addBottomShadow(color: .gray)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
