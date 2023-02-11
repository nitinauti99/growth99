//
//  AppointmentTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 05/02/23.
//

import UIKit

protocol ProfileAppointmentCellDelegate: AnyObject {
    func removeProfileAppointment(cell: AppointmentTableViewCell, index: IndexPath)
    func editProfileAppointment(cell: AppointmentTableViewCell, index: IndexPath)
    func paymentProfileAppointment(cell: AppointmentTableViewCell, index: IndexPath)
}

class AppointmentTableViewCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var clinicNameLabel: UILabel!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var appointmentDateLabel: UILabel!
    @IBOutlet weak var paymetStatusLabel: UILabel!
    @IBOutlet weak var appointmentStatusLabel: UILabel!

    var dateFormater: DateFormaterProtocol?
    weak var delegate: ProfileAppointmentCellDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color:.gray)
        dateFormater = DateFormater()
    }
    
    func configureCell(profileAppointmentList: AppointmentViewModelProtocol?, index: IndexPath, isSearch: Bool) {
        let profileAppointmentListData = profileAppointmentList?.getProfileFilterDataAtIndex(index: index.row)
        self.id.text = String(profileAppointmentListData?.id ?? 0)
        self.patientNameLabel.text = "\(profileAppointmentListData?.patientFirstname ?? String.blank) \(profileAppointmentListData?.patientLastName ?? String.blank)"
        self.clinicNameLabel.text = profileAppointmentListData?.clinicName
        self.providerNameLabel.text = profileAppointmentListData?.providerName
        self.typeLabel.text = profileAppointmentListData?.appointmentType
        if let data = profileAppointmentListData?.source {
            self.sourceLabel.text = data
        } else {
            self.sourceLabel.text = "-"
        }
        self.appointmentDateLabel.text = "\(dateFormater?.serverToLocalCreatedDate(date: profileAppointmentListData?.appointmentDate ?? String.blank) ?? "") \(dateFormater?.utcToLocal(timeString: profileAppointmentListData?.appointmentDate ?? String.blank) ?? "")"
        self.paymetStatusLabel.text = profileAppointmentListData?.paymentStatus
        self.appointmentStatusLabel.text = profileAppointmentListData?.appointmentConfirmationStatus
        self.createdDate.text = "\(dateFormater?.serverToLocalCreatedDate(date: profileAppointmentListData?.createdAt ?? String.blank) ?? "") \(dateFormater?.utcToLocal(timeString: profileAppointmentListData?.createdAt ?? String.blank) ?? "")"
        indexPath = index
    }
    
    
    func configureCell(profileAppointmentList: AppointmentViewModelProtocol?, index: IndexPath) {
        let profileAppointmentListData = profileAppointmentList?.getProfileDataAtIndex(index: index.row)
        self.id.text = String(profileAppointmentListData?.id ?? 0)
        self.patientNameLabel.text = "\(profileAppointmentListData?.patientFirstname ?? String.blank) \(profileAppointmentListData?.patientLastName ?? String.blank)"
        self.clinicNameLabel.text = profileAppointmentListData?.clinicName
        self.providerNameLabel.text = profileAppointmentListData?.providerName
        self.typeLabel.text = profileAppointmentListData?.appointmentType
        if let data = profileAppointmentListData?.source {
            self.sourceLabel.text = data
        } else {
            self.sourceLabel.text = "-"
        }
        self.appointmentDateLabel.text = "\(dateFormater?.serverToLocalCreatedDate(date: profileAppointmentListData?.appointmentDate ?? String.blank) ?? "") \(dateFormater?.utcToLocal(timeString: profileAppointmentListData?.appointmentDate ?? String.blank) ?? "")"
        self.paymetStatusLabel.text = profileAppointmentListData?.paymentStatus
        self.appointmentStatusLabel.text = profileAppointmentListData?.appointmentConfirmationStatus
        self.createdDate.text = "\(dateFormater?.serverToLocalCreatedDate(date: profileAppointmentListData?.createdAt ?? String.blank) ?? "") \(dateFormater?.utcToLocal(timeString: profileAppointmentListData?.createdAt ?? String.blank) ?? "")"
        indexPath = index
    }
    
    @IBAction func deleteButtonPressed() {
        self.delegate?.removeProfileAppointment(cell: self, index: indexPath)
    }
    
    @IBAction func editButtonPressed() {
        self.delegate?.editProfileAppointment(cell: self, index: indexPath)
    }

    @IBAction func paymentButtonPressed() {
        self.delegate?.paymentProfileAppointment(cell: self, index: indexPath)
    }
}
