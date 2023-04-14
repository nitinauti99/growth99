//
//  BookingHistoryTableViewself.swift
//  Growth99
//
//  Created by Mahender Reddy on 30/01/23.
//

import UIKit

protocol BookingHistoryListTableViewCellDelegate: AnyObject {
    func removeAppointment(cell: BookingHistoryTableViewCell, index: IndexPath)
    func editAppointment(cell: BookingHistoryTableViewCell, index: IndexPath)
}

class BookingHistoryTableViewCell: UITableViewCell {
    
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
    weak var delegate: BookingHistoryListTableViewCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }
    
    func configureCell(bookingHistoryFilterList: BookingHistoryViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let bookingHistoryFilterList = bookingHistoryFilterList?.getBookingHistoryFilterDataAtIndex(index: index.row)
        self.id.text = String(bookingHistoryFilterList?.id ?? 0)
        self.patientNameLabel.text = "\(bookingHistoryFilterList?.patientFirstName ?? String.blank) \(bookingHistoryFilterList?.patientLastName ?? String.blank)"
        self.clinicNameLabel.text = bookingHistoryFilterList?.clinicName
        self.providerNameLabel.text = bookingHistoryFilterList?.providerName
        self.typeLabel.text = bookingHistoryFilterList?.appointmentType
        if let data = bookingHistoryFilterList?.source {
            self.sourceLabel.text = data
        } else {
            self.sourceLabel.text = "-"
        }
        let serviceSelectedArray = bookingHistoryFilterList?.serviceList ?? []
        self.servicesLabel.text = serviceSelectedArray.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        self.appointmentDateLabel.text = "\(self.serverToLocal(date: bookingHistoryFilterList?.appointmentStartDate ?? String.blank)) \(self.utcToLocal(timeString: bookingHistoryFilterList?.appointmentStartDate ?? String.blank) ?? String.blank)"
        self.paymetStatusLabel.text = bookingHistoryFilterList?.paymentStatus
        self.appointmentStatusLabel.text = bookingHistoryFilterList?.appointmentStatus
        self.createdDate.text = "\(self.serverToLocalCreatedDate(date: bookingHistoryFilterList?.appointmentCreatedDate ?? String.blank)) \(self.utcToLocal(timeString: bookingHistoryFilterList?.appointmentCreatedDate ?? String.blank) ?? String.blank)"
        indexPath = index
    }
    
    func configureCell(bookingHistoryList: BookingHistoryViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let bookingHistoryList = bookingHistoryList?.getBookingHistoryDataAtIndex(index: index.row)
        self.id.text = String(bookingHistoryList?.id ?? 0)
        self.patientNameLabel.text = "\(bookingHistoryList?.patientFirstName ?? String.blank) \(bookingHistoryList?.patientLastName ?? String.blank)"
        self.clinicNameLabel.text = bookingHistoryList?.clinicName
        self.providerNameLabel.text = bookingHistoryList?.providerName
        self.typeLabel.text = bookingHistoryList?.appointmentType
        if let data = bookingHistoryList?.source {
            self.sourceLabel.text = data
        } else {
            self.sourceLabel.text = "-"
        }
        let serviceSelectedArray = bookingHistoryList?.serviceList ?? []
        self.servicesLabel.text = serviceSelectedArray.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        self.appointmentDateLabel.text = "\(self.serverToLocal(date: bookingHistoryList?.appointmentStartDate ?? String.blank)) \(self.utcToLocal(timeString: bookingHistoryList?.appointmentStartDate ?? String.blank) ?? String.blank)"
        self.paymetStatusLabel.text = bookingHistoryList?.paymentStatus
        self.appointmentStatusLabel.text = bookingHistoryList?.appointmentStatus
        self.createdDate.text = "\(self.serverToLocalCreatedDate(date: bookingHistoryList?.appointmentCreatedDate ?? String.blank)) \(self.utcToLocal(timeString: bookingHistoryList?.appointmentCreatedDate ?? String.blank) ?? String.blank)"
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
}
