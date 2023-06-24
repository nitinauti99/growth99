//
//  LeadTriggersTableViewCell.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol TriggerSourceDelegate: AnyObject {
    func didTapSwitchButton(triggerId: String, triggerStatus: String)
    func removeSelectedTrigger(cell: LeadTriggersTableViewCell, index: IndexPath)
    func editSelectedTrigger(cell: LeadTriggersTableViewCell, index: IndexPath)
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
    
    weak var delegate: TriggerSourceDelegate?
    var indexPath = IndexPath()
    var dateFormater : DateFormaterProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
        
    }
    
    
    func configureCell(triggerFilterList: TriggersListModel?, index: IndexPath, isSearch: Bool) {
        self.id.text = String(triggerFilterList?.id ?? 0)
        self.nameLabel.text = triggerFilterList?.name
        if triggerFilterList?.triggerActionName == String.blank {
            let sourceFrom = triggerFilterList?.triggerConditions?.joined(separator: ", ")
            self.sourceLabel.text = sourceFrom
        } else {
            self.sourceLabel.text = triggerFilterList?.triggerActionName
        }
        self.moduleLabel.text = triggerFilterList?.moduleName
        self.createdDate.text =  dateFormater?.serverToLocal(date: triggerFilterList?.createdAt ?? String.blank)
        self.createdBy.text = triggerFilterList?.createdBy
        self.updatedDate.text =  dateFormater?.serverToLocal(date: triggerFilterList?.updatedAt ?? String.blank)
        self.updatedBy.text = triggerFilterList?.updatedBy
        if triggerFilterList?.status == Constant.Profile.triggerActive {
            self.statusLabelSwitch.setOn(false, animated: true)
            self.statusLabelSwitch.isEnabled = false
        } else {
            self.statusLabelSwitch.setOn(true, animated: true)
            self.statusLabelSwitch.isEnabled = true
        }
        indexPath = index
    }
    
    func configureCell(triggerList: TriggersListModel?, index: IndexPath, isSearch: Bool) {
        self.id.text = String(triggerList?.id ?? 0)
        self.nameLabel.text = triggerList?.name
        if triggerList?.triggerActionName == String.blank {
            let sourceFrom = triggerList?.triggerConditions?.joined(separator: ", ")
            self.sourceLabel.text = sourceFrom
        } else {
            self.sourceLabel.text = triggerList?.triggerActionName
        }
        self.moduleLabel.text = triggerList?.moduleName
        self.createdDate.text =  dateFormater?.serverToLocal(date: triggerList?.createdAt ?? String.blank)
        self.createdBy.text = triggerList?.createdBy
        self.updatedDate.text =  dateFormater?.serverToLocal(date: triggerList?.updatedAt ?? String.blank)
        self.updatedBy.text = triggerList?.updatedBy
        if triggerList?.status == Constant.Profile.triggerActive {
            self.statusLabelSwitch.setOn(false, animated: true)
            self.statusLabelSwitch.isEnabled = false
        } else {
            self.statusLabelSwitch.setOn(true, animated: true)
            self.statusLabelSwitch.isEnabled = true
        }
        indexPath = index
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func statusSwitchChanges(_ sender: UIButton) {
        if statusLabelSwitch.isOn {
            delegate?.didTapSwitchButton(triggerId: self.id.text ?? String.blank, triggerStatus: "ACTIVE")
        } else {
            delegate?.didTapSwitchButton(triggerId: self.id.text ?? String.blank, triggerStatus: "INACTIVE")
        }
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date! as Date)
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeSelectedTrigger(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editSelectedTrigger(cell: self, index: indexPath)
    }
}
