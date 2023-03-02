//
//  MassSMSTableViewCell.swift
//  Growth99
//
//  Created by Mahender Reddy on 30/01/23.
//

import UIKit

protocol MassSMSListTableViewCellDelegate: AnyObject {
    func removeAppointment(cell: MassSMSTableViewCell, index: IndexPath)
    func editAppointment(cell: MassSMSTableViewCell, index: IndexPath)
    func paymentMassSMS(cell: MassSMSTableViewCell, index: IndexPath)
}

class MassSMSTableViewCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var clinicNameLabel: UILabel!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var appointmentDateLabel: UILabel!
    @IBOutlet weak var paymetStatusLabel: UILabel!
    @IBOutlet weak var appointmentStatusLabel: UILabel!

    var dateFormater: DateFormaterProtocol?
    weak var delegate: MassSMSListTableViewCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }

    func configureCell(massSMSFilterList: MassSMSViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let massSMSFilterList = massSMSFilterList?.getMassSMSFilterDataAtIndex(index: index.row)
        self.id.text = String(massSMSFilterList?.id ?? 0)
        self.patientNameLabel.text = "\(massSMSFilterList?.patientFirstName ?? String.blank) \(massSMSFilterList?.patientLastName ?? String.blank)"
        self.clinicNameLabel.text = massSMSFilterList?.clinicName
        self.providerNameLabel.text = massSMSFilterList?.providerName
        self.typeLabel.text = massSMSFilterList?.appointmentType
        if let data = massSMSFilterList?.source {
            self.sourceLabel.text = data
        } else {
            self.sourceLabel.text = "-"
        }
        let serviceSelectedArray = massSMSFilterList?.serviceList ?? []
        self.servicesLabel.text = serviceSelectedArray.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        self.appointmentDateLabel.text = "\(self.serverToLocal(date: massSMSFilterList?.appointmentStartDate ?? String.blank)) \(self.utcToLocal(timeString: massSMSFilterList?.appointmentStartDate ?? String.blank) ?? String.blank)"
        self.paymetStatusLabel.text = massSMSFilterList?.paymentStatus
        self.appointmentStatusLabel.text = massSMSFilterList?.appointmentStatus
        self.createdDate.text = "\(self.serverToLocalCreatedDate(date: massSMSFilterList?.appointmentCreatedDate ?? String.blank)) \(self.utcToLocal(timeString: massSMSFilterList?.appointmentCreatedDate ?? String.blank) ?? String.blank)"
        indexPath = index
    }
    
    func configureCell(massSMSList: MassSMSViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let massSMSList = massSMSList?.getMassSMSDataAtIndex(index: index.row)
        self.id.text = String(massSMSList?.id ?? 0)
        self.patientNameLabel.text = "\(massSMSList?.patientFirstName ?? String.blank) \(massSMSList?.patientLastName ?? String.blank)"
        self.clinicNameLabel.text = massSMSList?.clinicName
        self.providerNameLabel.text = massSMSList?.providerName
        self.typeLabel.text = massSMSList?.appointmentType
        if let data = massSMSList?.source {
            self.sourceLabel.text = data
        } else {
            self.sourceLabel.text = "-"
        }
        let serviceSelectedArray = massSMSList?.serviceList ?? []
        self.servicesLabel.text = serviceSelectedArray.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        self.appointmentDateLabel.text = "\(self.serverToLocal(date: massSMSList?.appointmentStartDate ?? String.blank)) \(self.utcToLocal(timeString: massSMSList?.appointmentStartDate ?? String.blank) ?? String.blank)"
        self.paymetStatusLabel.text = massSMSList?.paymentStatus
        self.appointmentStatusLabel.text = massSMSList?.appointmentStatus
        self.createdDate.text = "\(self.serverToLocalCreatedDate(date: massSMSList?.appointmentCreatedDate ?? String.blank)) \(self.utcToLocal(timeString: massSMSList?.appointmentCreatedDate ?? String.blank) ?? String.blank)"
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

    @IBAction func deleteButtonPressed() {
        self.delegate?.removeAppointment(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editAppointment(cell: self, index: indexPath)
    }

    @IBAction func paymentButtonPressed() {
        self.delegate?.paymentMassSMS(cell: self, index: indexPath)
    }
}
