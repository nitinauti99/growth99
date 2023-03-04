//
//  MassEmailandSMSTableViewCell.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol MassEmailandSMSDelegate: AnyObject {
    func didTapSwitchButton(massEmailandSMSId: String, massEmailandSMSStatus: String)
    func removeEmailandSMS(cell: MassEmailandSMSTableViewCell, index: IndexPath)
    func editEmailandSMS(cell: MassEmailandSMSTableViewCell, index: IndexPath)
}

class MassEmailandSMSTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var id: UILabel!
    @IBOutlet private weak var triggerNameLabel: UILabel!
    @IBOutlet private weak var moduleLabel: UILabel!
    @IBOutlet private weak var executionStatusLabel: UILabel!
    @IBOutlet private weak var statusLabelSwitch: UISwitch!
    @IBOutlet private weak var scheduledDateLabel: UILabel!
    @IBOutlet private weak var createdDate: UILabel!
    @IBOutlet private weak var createdBy: UILabel!
    @IBOutlet private weak var updatedDate: UILabel!
    @IBOutlet private weak var updatedBy: UILabel!
    @IBOutlet private weak var subView: UIView!
    
    weak var delegate: MassEmailandSMSDelegate?
    var indexPath = IndexPath()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        
    }
    func configureCell(massEmailFilterList: MassEmailandSMSViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let massEmailFilterList = massEmailFilterList?.getMassEmailandSMSFilterDataAtIndex(index: index.row)
        self.id.text = String(massEmailFilterList?.id ?? 0)
        self.triggerNameLabel.text = massEmailFilterList?.name
        /*if massEmailFilterList?.triggerActionName == String.blank {
            let sourceFrom = massEmailFilterList?.triggerConditions?.joined(separator: ", ")
            self.sourceLabel.text = sourceFrom
        } else {
            self.sourceLabel.text = massEmailFilterList?.triggerActionName
        }*/
        self.moduleLabel.text = massEmailFilterList?.moduleName
        self.createdDate.text =  self.serverToLocal(date: massEmailFilterList?.createdAt ?? String.blank)
        self.createdBy.text = massEmailFilterList?.createdBy
        self.updatedDate.text =  self.serverToLocal(date: massEmailFilterList?.updatedAt ?? String.blank)
        self.updatedBy.text = massEmailFilterList?.updatedBy
        if massEmailFilterList?.status == Constant.Profile.triggerActive {
            self.statusLabelSwitch.setOn(true, animated: true)
        } else {
            self.statusLabelSwitch.setOn(false, animated: true)
        }
        indexPath = index
    }
    
    func configureCell(massEmailList: MassEmailandSMSViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let massEmailList = massEmailList?.getMassEmailandSMSDataAtIndex(index: index.row)
        self.id.text = String(massEmailList?.id ?? 0)
        self.triggerNameLabel.text = massEmailList?.name
        /*if massEmailList?.triggerActionName == String.blank {
            let sourceFrom = massEmailList?.triggerConditions?.joined(separator: ", ")
            self.sourceLabel.text = sourceFrom
        } else {
            self.sourceLabel.text = massEmailList?.triggerActionName
        }*/
        self.moduleLabel.text = massEmailList?.moduleName
        self.createdDate.text =  self.serverToLocal(date: massEmailList?.createdAt ?? String.blank)
        self.createdBy.text = massEmailList?.createdBy
        self.updatedDate.text =  self.serverToLocal(date: massEmailList?.updatedAt ?? String.blank)
        self.updatedBy.text = massEmailList?.updatedBy
        if massEmailList?.status == Constant.Profile.triggerActive {
            self.statusLabelSwitch.setOn(true, animated: true)
        } else {
            self.statusLabelSwitch.setOn(false, animated: true)
        }
        indexPath = index
    }
    
    func serverToLocal(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM d yyyy"
        return dateFormatter.string(from: date)
    }

    func serverToLocalCreatedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM d yyyy"
        return dateFormatter.string(from: date)
    }
    
    func utcToLocal(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func statusSwitchChanges(_ sender: UIButton) {
        if statusLabelSwitch.isOn {
            delegate?.didTapSwitchButton(massEmailandSMSId: self.id.text ?? String.blank, massEmailandSMSStatus: "ACTIVE")
        } else {
            delegate?.didTapSwitchButton(massEmailandSMSId: self.id.text ?? String.blank, massEmailandSMSStatus: "INACTIVE")
        }
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeEmailandSMS(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editEmailandSMS(cell: self, index: indexPath)
    }
}
