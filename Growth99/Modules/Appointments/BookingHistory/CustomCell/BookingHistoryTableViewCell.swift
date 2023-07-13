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
        self.appointmentDateLabel.text = dateFormater?.serverToLocalPateintsAppointment(date: bookingHistoryFilterList?.appointmentStartDate ?? "")
        self.paymetStatusLabel.text = bookingHistoryFilterList?.paymentStatus
        self.appointmentStatusLabel.text = bookingHistoryFilterList?.appointmentStatus
        self.createdDate.text = dateFormater?.serverToLocalDateConverter(date: bookingHistoryFilterList?.appointmentCreatedDate ?? String.blank)
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
        self.appointmentDateLabel.text = dateFormater?.serverToLocalPateintsAppointment(date: bookingHistoryList?.appointmentStartDate ?? "")
        self.paymetStatusLabel.text = bookingHistoryList?.paymentStatus
        self.appointmentStatusLabel.text = bookingHistoryList?.appointmentStatus
        self.createdDate.text = dateFormater?.serverToLocalDateConverter(date: bookingHistoryList?.appointmentCreatedDate ?? String.blank)
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeAppointment(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editAppointment(cell: self, index: indexPath)
    }
}
