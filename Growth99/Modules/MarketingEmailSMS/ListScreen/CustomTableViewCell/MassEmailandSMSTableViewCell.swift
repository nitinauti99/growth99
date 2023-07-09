//
//  MassEmailandSMSTableViewCell.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol MassEmailandSMSDelegate: AnyObject {
    func didTapSwitchButton(massEmailandSMSId: String, massEmailandSMSStatus: String)
    func editEmailandSMS(cell: MassEmailandSMSTableViewCell, index: IndexPath)
    func auditButtonClicked(cell: MassEmailandSMSTableViewCell, index: IndexPath)
    func deleteButtonClicked(cell: MassEmailandSMSTableViewCell, index: IndexPath)
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
    @IBOutlet weak var editOrShowButton: UIButton!
    @IBOutlet weak var auditButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: MassEmailandSMSDelegate?
    var indexPath = IndexPath()
    var dateFormater : DateFormaterProtocol?
    var triggerStatusClick: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }
    
    func configureCell(massEmailFilterList: MassEmailandSMSModel?, index: IndexPath, isSearch: Bool) {
        if massEmailFilterList?.executionStatus == "COMPLETED" {
            auditButton.isHidden = false
            deleteButton.isHidden = true
        } else if massEmailFilterList?.executionStatus == "FAILED" || massEmailFilterList?.executionStatus == "INPROGRESS" {
            auditButton.isHidden = true
            deleteButton.isHidden = true
        } else {
            auditButton.isHidden = true
            deleteButton.isHidden = false
        }
        self.id.text = String(massEmailFilterList?.id ?? 0)
        self.triggerNameLabel.text = massEmailFilterList?.name
        self.executionStatusLabel.text = massEmailFilterList?.executionStatus
        self.moduleLabel.text = massEmailFilterList?.moduleName?.replacingOccurrences(of: "Mass", with: "")
        self.scheduledDateLabel.text =  self.serverToLocal(date: massEmailFilterList?.createdAt ?? String.blank)
        self.createdDate.text =  dateFormater?.serverToLocalDateConverter(date: massEmailFilterList?.createdAt ?? String.blank)
        self.createdBy.text = massEmailFilterList?.createdBy
        self.updatedDate.text =  dateFormater?.serverToLocalDateConverter(date: massEmailFilterList?.updatedAt ?? String.blank)
        self.updatedBy.text = massEmailFilterList?.updatedBy
        if massEmailFilterList?.executionStatus == "SCHEDULED" && massEmailFilterList?.status == "ACTIVE" {
            deleteButton.isHidden = false
            triggerStatusClick = true
            self.statusLabelSwitch.isEnabled = true
            self.statusLabelSwitch.setOn(true, animated: true)
            self.editOrShowButton.setImage(UIImage(named: "pending"), for: .normal)
        } else if massEmailFilterList?.executionStatus == "SCHEDULED" && massEmailFilterList?.status == "INACTIVE" {
            deleteButton.isHidden = false
            triggerStatusClick = true
            self.statusLabelSwitch.isEnabled = true
            self.statusLabelSwitch.setOn(true, animated: true)
            self.editOrShowButton.setImage(UIImage(named: "pending"), for: .normal)
        } else {
            deleteButton.isHidden = true
            triggerStatusClick = false
            self.statusLabelSwitch.isEnabled = false
            self.statusLabelSwitch.setOn(false, animated: true)
            self.editOrShowButton.setImage(UIImage(named: "submited"), for: .normal)
        }
        indexPath = index
    }
    
    func configureCell(massEmailList: MassEmailandSMSModel?, index: IndexPath, isSearch: Bool) {
        if massEmailList?.executionStatus == "COMPLETED" {
            auditButton.isHidden = false
            deleteButton.isHidden = true
        } else if massEmailList?.executionStatus == "FAILED" || massEmailList?.executionStatus == "INPROGRESS" {
            auditButton.isHidden = true
            deleteButton.isHidden = true
        } else {
            auditButton.isHidden = true
            deleteButton.isHidden = false
        }
        self.id.text = String(massEmailList?.id ?? 0)
        self.triggerNameLabel.text = massEmailList?.name
        self.executionStatusLabel.text = massEmailList?.executionStatus
        self.moduleLabel.text = massEmailList?.moduleName?.replacingOccurrences(of: "Mass", with: "")
        self.scheduledDateLabel.text =  dateFormater?.serverToLocalDateConverter(date: massEmailList?.createdAt ?? String.blank)
        self.createdDate.text =  dateFormater?.serverToLocalDateConverter(date: massEmailList?.createdAt ?? String.blank)
        self.createdBy.text = massEmailList?.createdBy
        self.updatedDate.text =  dateFormater?.serverToLocalDateConverter(date: massEmailList?.updatedAt ?? String.blank)
        self.updatedBy.text = massEmailList?.updatedBy
        if massEmailList?.executionStatus == "SCHEDULED" && massEmailList?.status == "ACTIVE" {
            deleteButton.isHidden = false
            triggerStatusClick = true
            self.statusLabelSwitch.isEnabled = true
            self.statusLabelSwitch.setOn(true, animated: true)
            self.editOrShowButton.setImage(UIImage(named: "pending"), for: .normal)
        } else if massEmailList?.executionStatus == "SCHEDULED" && massEmailList?.status == "INACTIVE" {
            deleteButton.isHidden = false
            triggerStatusClick = true
            self.statusLabelSwitch.isEnabled = true
            self.statusLabelSwitch.setOn(true, animated: true)
            self.editOrShowButton.setImage(UIImage(named: "pending"), for: .normal)
        } else {
            deleteButton.isHidden = true
            triggerStatusClick = false
            self.statusLabelSwitch.isEnabled = false
            self.statusLabelSwitch.setOn(false, animated: true)
            self.editOrShowButton.setImage(UIImage(named: "submited"), for: .normal)
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
        if triggerStatusClick == true {
            if statusLabelSwitch.isOn {
                delegate?.didTapSwitchButton(massEmailandSMSId: self.id.text ?? String.blank, massEmailandSMSStatus: "ACTIVE")
            } else {
                delegate?.didTapSwitchButton(massEmailandSMSId: self.id.text ?? String.blank, massEmailandSMSStatus: "INACTIVE")
            }
        }
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editEmailandSMS(cell: self, index: indexPath)
    }
    
    @IBAction func auditButtonPressed() {
        self.delegate?.auditButtonClicked(cell: self, index: indexPath)
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.deleteButtonClicked(cell: self, index: indexPath)
    }
}
