//
//  LeadTriggersTableViewCell.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol TriggerSourceDelegate: AnyObject {
    func selectedSubItemsFSP()
}

class LeadTriggersTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var moduleLabel: UILabel!
    @IBOutlet private weak var statusLabelSwitch: UISwitch!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        
    }
    
    func configureCell(triggerVM: TriggersListModel?) {
        self.id.text = String(triggerVM?.id ?? 0)
        self.nameLabel.text = triggerVM?.name
        if triggerVM?.triggerActionName == String.blank {
            let sourceFrom = triggerVM?.triggerConditions?.joined(separator: ", ")
            self.sourceLabel.text = sourceFrom
        } else {
            self.sourceLabel.text = triggerVM?.triggerActionName
        }
        self.moduleLabel.text = triggerVM?.moduleName
        self.createdDate.text =  self.serverToLocal(date: triggerVM?.createdAt ?? String.blank)
        self.createdBy.text = triggerVM?.createdBy
        self.updatedDate.text =  self.serverToLocal(date: triggerVM?.updatedAt ?? String.blank)
        self.updatedBy.text = triggerVM?.updatedBy
        if triggerVM?.status == Constant.Profile.triggerActive {
            self.statusLabelSwitch.setOn(true, animated: true)
        } else {
            self.statusLabelSwitch.setOn(false, animated: true)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func statusSwitchChanges(_ sender: Any) {
        
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date! as Date)
    }
}
