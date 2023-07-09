//
//  PatientAppointmentListTableViewCell.swift
//  Growth99
//
//  Created by nitin auti on 03/02/23.
//

import UIKit

protocol PatientAppointmentListTableViewCellDelegate: AnyObject {
//    func removeBookingHistory(cell: PatientAppointmentListTableViewCell, index: IndexPath)
      func editPatientAppointment(cell: PatientAppointmentListTableViewCell, index: IndexPath)
//    func videoBookingHistory(cell: PatientAppointmentListTableViewCell, index: IndexPath)
//    func paymentBookingHistory(cell: PatientAppointmentListTableViewCell, index: IndexPath)
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
    var delegate: PatientAppointmentListTableViewCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        dateFormater = DateFormater()
    }
    
    func configureCellWithSearch(patientAppointmentVM: PatientAppointmentViewModelProtocol?, index: IndexPath) {
        let patientAppointmentListVM = patientAppointmentVM?.patientListFilterListAtIndex(index: index.row)
        self.id.text = String(patientAppointmentListVM?.id ?? 0)
        self.patientNameLabel.text = patientAppointmentListVM?.patientName ?? String.blank
        self.clinicNameLabel.text = patientAppointmentListVM?.ClinicName
        self.providerNameLabel.text = patientAppointmentListVM?.providerName
        self.typeLabel.text = patientAppointmentListVM?.appointmentType
        let serviceSelectedArray = patientAppointmentListVM?.service ?? []
        
        if patientAppointmentListVM?.service?.count ?? 0 > 0 {
            self.servicesLabel.text = patientAppointmentListVM?.service?.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        } else {
            self.servicesLabel.text = ""
        }
        self.appointmentDateLabel.text = dateFormater?.serverToLocalPateintsAppointment(date: patientAppointmentListVM?.appointmentDate ?? String.blank)
        self.paymetStatusLabel.text = patientAppointmentListVM?.paymentStatus
        self.createdDate.text = dateFormater?.serverToLocalforPateints(date: patientAppointmentListVM?.createdAt ?? String.blank)
        indexPath = index
    }
    
    func configureCell(patientAppointmentVM: PatientAppointmentViewModelProtocol?, index: IndexPath) {
        let patientAppointmentListVM = patientAppointmentVM?.patientListAtIndex(index: index.row)
        self.id.text = String(patientAppointmentListVM?.id ?? 0)
        self.patientNameLabel.text = patientAppointmentListVM?.patientName ?? String.blank
        self.clinicNameLabel.text = patientAppointmentListVM?.ClinicName
        self.providerNameLabel.text = patientAppointmentListVM?.providerName
        self.typeLabel.text = patientAppointmentListVM?.appointmentType
        let serviceSelectedArray = patientAppointmentListVM?.service ?? []
        
        if patientAppointmentListVM?.service?.count ?? 0 > 0 {
            self.servicesLabel.text = patientAppointmentListVM?.service?.map({$0.serviceName ?? String.blank}).joined(separator: ", ")
        } else {
            self.servicesLabel.text = ""
        }
        self.appointmentDateLabel.text = dateFormater?.serverToLocalPateintsAppointment(date: patientAppointmentListVM?.appointmentDate ?? String.blank)
        self.paymetStatusLabel.text = patientAppointmentListVM?.paymentStatus
        self.createdDate.text = dateFormater?.serverToLocalforPateints(date: patientAppointmentListVM?.createdAt ?? String.blank)
        indexPath = index
    }
    
    
//    @IBAction func deleteButtonPressed() {
//        self.delegate?.removeBookingHistory(cell: self, index: indexPath)
//    }
//
    @IBAction func editButtonPressed() {
        self.delegate?.editPatientAppointment(cell: self, index: indexPath)
    }
//
//    @IBAction func videoButtonPressed() {
//        self.delegate?.videoBookingHistory(cell: self, index: indexPath)
//    }
//
//    @IBAction func paymentButtonPressed() {
//        self.delegate?.paymentBookingHistory(cell: self, index: indexPath)
//    }
    
}
