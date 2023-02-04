//
//  BookingHistoryTableViewCell.swift
//  Growth99
//
//  Created by Mahender Reddy on 30/01/23.
//

import UIKit

protocol BookingHistoryListTableViewCellDelegate: AnyObject {
    func removeBookingHistory(cell: BookingHistoryTableViewCell, index: IndexPath)
    func editAppointment(cell: BookingHistoryTableViewCell, index: IndexPath)
    func paymentBookingHistory(cell: BookingHistoryTableViewCell, index: IndexPath)
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

    var dateFormater : DateFormaterProtocol?
    weak var delegate: BookingHistoryListTableViewCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }

    func configureCell(index: IndexPath) {
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeBookingHistory(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editAppointment(cell: self, index: indexPath)
    }

    @IBAction func paymentButtonPressed() {
        self.delegate?.paymentBookingHistory(cell: self, index: indexPath)
    }
}
