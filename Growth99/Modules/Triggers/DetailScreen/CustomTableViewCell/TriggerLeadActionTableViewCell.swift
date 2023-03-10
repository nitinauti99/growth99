//
//  TriggerDefaultTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerLeadCellDelegate: AnyObject {
    func nextButtonLead(cell: TriggerLeadActionTableViewCell, index: IndexPath)
}

class TriggerLeadActionTableViewCell: UITableViewCell {

    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    @IBOutlet weak var leadStatusSelectonButton: UIButton!
    @IBOutlet weak var leadSourceTriggerSelectonButton: UIButton!
    @IBOutlet weak var leadTagSelectonButton: UIButton!
    @IBOutlet weak var leadStatusView: UIView!
    @IBOutlet weak var leadSourceView: UIView!
    @IBOutlet weak var leadTagView: UIView!
    @IBOutlet weak var leadStatusTextLabel: UILabel!
    @IBOutlet weak var leadSourceTextLabel: UILabel!
    @IBOutlet weak var leadTagTextLabel: UILabel!

    @IBOutlet weak var leadStatusEmptyTextLabel: UILabel!

    weak var delegate: TriggerLeadCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        
        leadStatusView.layer.cornerRadius = 4.5
        leadStatusView.layer.borderWidth = 1
        leadStatusView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        leadSourceView.layer.cornerRadius = 4.5
        leadSourceView.layer.borderWidth = 1
        leadSourceView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        leadTagView.layer.cornerRadius = 4.5
        leadTagView.layer.borderWidth = 1
        leadTagView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonLead(cell: self, index: indexPath)
    }
}
