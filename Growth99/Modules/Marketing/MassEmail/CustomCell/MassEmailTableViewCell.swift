//
//  MassEmailTableViewself.swift
//  Growth99
//
//  Created by Mahender Reddy on 30/01/23.
//

import UIKit

protocol MassEmailListTableViewCellDelegate: AnyObject {
    func removeAppointment(cell: MassEmailTableViewCell, index: IndexPath)
    func editAppointment(cell: MassEmailTableViewCell, index: IndexPath)
    func paymentMassEmail(cell: MassEmailTableViewCell, index: IndexPath)
}

class MassEmailTableViewCell: UITableViewCell {

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
    weak var delegate: MassEmailListTableViewCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }

    func configureCell(massEmailFilterList: MassEmailViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let massEmailFilterList = massEmailFilterList?.getMassEmailFilterDataAtIndex(index: index.row)
        self.id.text = String(massEmailFilterList?.id ?? 0)
        self.patientNameLabel.text = "\(massEmailFilterList?.patientFirstName ?? String.blank) \(massEmailFilterList?.patientLastName ?? String.blank)"
        self.clinicNameLabel.text = massEmailFilterList?.clinicName
        self.providerNameLabel.text = massEmailFilterList?.providerName
        self.typeLabel.text = massEmailFilterList?.appointmentType
        if let data = massEmailFilterList?.source {
            self.sourceLabel.text = data
        } else {
            self.sourceLabel.text = "-"
        }
        let serviceSelectedArray = massEmailFilterList?.serviceList ?? []
        self.servicesLabel.text = serviceSelectedArray.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        self.appointmentDateLabel.text = "\(self.serverToLocal(date: massEmailFilterList?.appointmentStartDate ?? String.blank)) \(self.utcToLocal(timeString: massEmailFilterList?.appointmentStartDate ?? String.blank) ?? String.blank)"
        self.paymetStatusLabel.text = massEmailFilterList?.paymentStatus
        self.appointmentStatusLabel.text = massEmailFilterList?.appointmentStatus
        self.createdDate.text = "\(self.serverToLocalCreatedDate(date: massEmailFilterList?.appointmentCreatedDate ?? String.blank)) \(self.utcToLocal(timeString: massEmailFilterList?.appointmentCreatedDate ?? String.blank) ?? String.blank)"
        indexPath = index
    }
    
    func configureCell(massEmailList: MassEmailViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let massEmailList = massEmailList?.getMassEmailDataAtIndex(index: index.row)
        self.id.text = String(massEmailList?.id ?? 0)
        self.patientNameLabel.text = "\(massEmailList?.patientFirstName ?? String.blank) \(massEmailList?.patientLastName ?? String.blank)"
        self.clinicNameLabel.text = massEmailList?.clinicName
        self.providerNameLabel.text = massEmailList?.providerName
        self.typeLabel.text = massEmailList?.appointmentType
        if let data = massEmailList?.source {
            self.sourceLabel.text = data
        } else {
            self.sourceLabel.text = "-"
        }
        let serviceSelectedArray = massEmailList?.serviceList ?? []
        self.servicesLabel.text = serviceSelectedArray.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        self.appointmentDateLabel.text = "\(self.serverToLocal(date: massEmailList?.appointmentStartDate ?? String.blank)) \(self.utcToLocal(timeString: massEmailList?.appointmentStartDate ?? String.blank) ?? String.blank)"
        self.paymetStatusLabel.text = massEmailList?.paymentStatus
        self.appointmentStatusLabel.text = massEmailList?.appointmentStatus
        self.createdDate.text = "\(self.serverToLocalCreatedDate(date: massEmailList?.appointmentCreatedDate ?? String.blank)) \(self.utcToLocal(timeString: massEmailList?.appointmentCreatedDate ?? String.blank) ?? String.blank)"
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
        self.delegate?.paymentMassEmail(cell: self, index: indexPath)
    }
}
