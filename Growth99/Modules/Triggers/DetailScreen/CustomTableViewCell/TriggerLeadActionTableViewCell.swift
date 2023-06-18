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
    @IBOutlet weak var leadLandingSelectonButton: UIButton!
    @IBOutlet weak var leadFormSelectonButton: UIButton!
    @IBOutlet weak var leadSourceUrlSelectonButton: UIButton!

    @IBOutlet weak var leadStatusView: UIView!
    @IBOutlet weak var leadLandingView: UIView!
    @IBOutlet weak var leadFormView: UIView!
    @IBOutlet weak var leadSourceURLView: UIView!

    @IBOutlet weak var leadSourceTextLabel: UILabel!
    @IBOutlet weak var leadLandingTextLabel: UILabel!
    @IBOutlet weak var leadFormTextLabel: UILabel!
    @IBOutlet weak var leadSourceUrlTextLabel: UILabel!

    @IBOutlet weak var leadSourceEmptyTextLabel: UILabel!
    @IBOutlet weak var leadLandingEmptyTextLabel: UILabel!
    @IBOutlet weak var leadFormEmptyTextLabel: UILabel!
    @IBOutlet weak var leadSourceUrlEmptyTextLabel: UILabel!

    @IBOutlet weak var leadNextButton: UIButton!

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
        
        leadLandingView.layer.cornerRadius = 4.5
        leadLandingView.layer.borderWidth = 1
        leadLandingView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        leadFormView.layer.cornerRadius = 4.5
        leadFormView.layer.borderWidth = 1
        leadFormView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
        
        leadSourceURLView.layer.cornerRadius = 4.5
        leadSourceURLView.layer.borderWidth = 1
        leadSourceURLView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
    }
    
    func configureCell(index: IndexPath) {
        indexPath = index
    }
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonLead(cell: self, index: indexPath)
    }
}
