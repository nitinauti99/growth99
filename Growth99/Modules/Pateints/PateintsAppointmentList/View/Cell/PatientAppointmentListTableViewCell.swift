//
//  PatientAppointmentListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import UIKit

protocol PatientAppointmentListTableViewCellDelegate: AnyObject {
    func removeBookingHistory(cell: PatientAppointmentListTableViewCell, index: IndexPath)
    func editBookingHistory(cell: PatientAppointmentListTableViewCell, index: IndexPath)
    func videoBookingHistory(cell: PatientAppointmentListTableViewCell, index: IndexPath)
    func paymentBookingHistory(cell: PatientAppointmentListTableViewCell, index: IndexPath)
}

class PatientAppointmentListTableViewCell: UITableViewCell {
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
    weak var delegate: PatientAppointmentListTableViewCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }

    @IBAction func deleteButtonPressed() {
        self.delegate?.removeBookingHistory(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editBookingHistory(cell: self, index: indexPath)
    }
    
    @IBAction func videoButtonPressed() {
        self.delegate?.videoBookingHistory(cell: self, index: indexPath)
    }
    
    @IBAction func paymentButtonPressed() {
        self.delegate?.paymentBookingHistory(cell: self, index: indexPath)
    }
    
}
