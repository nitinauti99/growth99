//
//  TriggerEditAppointmentActionTableViewCell.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import UIKit

protocol TriggerEditPatientCellDelegate: AnyObject {
    func nextButtonPatient(cell: TriggerEditAppointmentActionTableViewCell, index: IndexPath)
}

class TriggerEditAppointmentActionTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var subView: UIView!
    @IBOutlet private weak var subViewInside: UIView!
    
    @IBOutlet weak var patientAppointmentButton: UIButton!
    @IBOutlet weak var patientAppointmentView: UIView!
    @IBOutlet weak var patientAppointmenTextLabel: UILabel!
    @IBOutlet weak var patientAppointmentEmptyTextLbl: UILabel!
    @IBOutlet weak var appointmentNextButton: UIButton!
    @IBOutlet weak var patientNextButton: UIButton!
    
    weak var delegate: TriggerEditPatientCellDelegate?
    var indexPath = IndexPath()
    var appointmentSelectedStatus: String = String.blank
    var selectedAppointmentStatus: [String] = []
    var selectedVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.createBorderForView(redius: 8, width: 1)
        self.subView.addBottomShadow(color: .gray)
        
        patientAppointmentView.layer.cornerRadius = 4.5
        patientAppointmentView.layer.borderWidth = 1
        patientAppointmentView.layer.borderColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor
    }
    
    func configureCell(tableView: UITableView?, index: IndexPath, triggerListEdit: TriggerEditModel?, viewModel: TriggerEditDetailViewModelProtocol?, viewController: UIViewController) {
        indexPath = index
        selectedVC = viewController
        self.patientAppointmentButton.addTarget(self, action: #selector(patientAppointmentMethod), for: .touchDown)
        self.patientAppointmentButton.tag = indexPath.row
        if viewModel?.getTriggerEditListData?.triggerActionName?.count ?? 0 > 0 {
            self.patientAppointmenTextLabel.text = viewModel?.getTriggerEditListData?.triggerActionName
        } else {
            self.patientAppointmenTextLabel.text = "Pending"
        }
        self.appointmentSelectedStatus = self.patientAppointmenTextLabel.text ?? ""
        self.selectedAppointmentStatus = triggerListEdit?.triggerConditions ?? []
    }
    
    @objc func patientAppointmentMethod(sender: UIButton) {
        let appointmentStatusArray = ["Pending", "Confirmed", "Completed", "Canceled", "Updated"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: appointmentStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: selectedAppointmentStatus) { [weak self] (selectedItem, index, selected, selectedList) in
            guard let self = self else { return }
            self.selectedAppointmentStatus = selectedList
            self.patientAppointmenTextLabel.text = selectedItem
            selectionMenu.dismiss()
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(appointmentStatusArray.count * 30))), arrowDirection: .up), from: selectedVC ?? UIViewController())
    }
    
    // MARK: - Add and remove time methods
    @IBAction func nextButtonAction(sender: UIButton) {
        self.delegate?.nextButtonPatient(cell: self, index: indexPath)
    }
}
