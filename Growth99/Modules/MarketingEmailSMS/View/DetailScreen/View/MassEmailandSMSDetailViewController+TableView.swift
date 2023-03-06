//
//  MassEmailandSMSDetailViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 06/03/23.
//

import Foundation
import UIKit

extension MassEmailandSMSDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailAndSMSDetailList.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if emailAndSMSDetailList[indexPath.row].cellType == "Default" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSDefaultTableViewCell", for: indexPath) as? MassEmailandSMSDefaultTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Module" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSModuleTableViewCell", for: indexPath) as? MassEmailandSMSModuleTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Lead" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSLeadActionTableViewCell", for: indexPath) as? MassEmailandSMSLeadActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Patient" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSPatientActionTableViewCell", for: indexPath) as? MassEmailandSMSPatientActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Both" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSCreateTableViewCell", for: indexPath) as? MassEmailandSMSCreateTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Time" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSTimeTableViewCell", for: indexPath) as? MassEmailandSMSTimeTableViewCell else { return UITableViewCell()}
//            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension MassEmailandSMSDetailViewController: MassEmailandSMSDefaultCellDelegate {
    func nextButtonDefault(cell: MassEmailandSMSDefaultTableViewCell, index: IndexPath) {
        let emailSMS = MassEmailandSMSDetailModel(cellType: "Module", LastName: "")
        emailAndSMSDetailList.append(emailSMS)
        emailAndSMSTableView.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
        emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableView.endUpdates()
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSModuleCellDelegate {
    func nextButtonModule(cell: MassEmailandSMSModuleTableViewCell, index: IndexPath, moduleType: String) {
        if moduleType == "patient" {
            let emailSMS = MassEmailandSMSDetailModel(cellType: "Patient", LastName: "")
            emailAndSMSDetailList.append(emailSMS)
        } else if moduleType == "lead" {
            let emailSMS = MassEmailandSMSDetailModel(cellType: "Lead", LastName: "")
            emailAndSMSDetailList.append(emailSMS)
        } else {
            let emailSMS = MassEmailandSMSDetailModel(cellType: "Both", LastName: "")
            emailAndSMSDetailList.append(emailSMS)
        }
        emailAndSMSTableView.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
        emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableView.endUpdates()
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSCreateCellDelegate {
    func networkSelectonBtn(cell: MassEmailandSMSCreateTableViewCell, index: IndexPath) {
        
    }
    
    func nextButtonCreate(cell: MassEmailandSMSCreateTableViewCell, index: IndexPath) {
        let emailSMS = MassEmailandSMSDetailModel(cellType: "Time", LastName: "")
        emailAndSMSDetailList.append(emailSMS)
        emailAndSMSTableView.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
        emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableView.endUpdates()
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSLeadCellDelegate {
    func leadStatusSelectonBtn(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath) {
        let leadStatusArray = ["NEW", "COLD", "WARM", "HOT", "WON","DEAD"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            cell.leadStatusTextField.text = selectedItem
        }
        selectionMenu.reloadInputViews()
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadStatusArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    func leadSourceSelectonBtn(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath) {
        
    }
    
    func leadTagSelectonBtn(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath) {
        
    }
    
    func nextButtonLead(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath) {
        let emailSMS = MassEmailandSMSDetailModel(cellType: "Both", LastName: "")
        emailAndSMSDetailList.append(emailSMS)
        emailAndSMSTableView.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
        emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableView.endUpdates()
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSPatientCellDelegate {
    func patientStatusSelectonBtn(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath) {
        
    }
    
    func patientAppointmentSelectonBtn(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath) {
        
    }
    
    func patientTagSelectonBtn(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath) {
        
    }
    
    func nextButtonPatient(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath) {
        let emailSMS = MassEmailandSMSDetailModel(cellType: "Both", LastName: "")
        emailAndSMSDetailList.append(emailSMS)
        emailAndSMSTableView.beginUpdates()
        let indexPath = IndexPath(row: (emailAndSMSDetailList.count) - 1, section: 0)
        emailAndSMSTableView.insertRows(at: [indexPath], with: .fade)
        emailAndSMSTableView.endUpdates()
    }
}
