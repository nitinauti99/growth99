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
            cell.leadStatusSelectonButton.addTarget(self, action: #selector(leadStatusMethod), for: .touchDown)
            cell.leadStatusSelectonButton.tag = indexPath.row
            cell.leadSourceSelectonButton.addTarget(self, action: #selector(leadSourceMethod), for: .touchDown)
            cell.leadSourceSelectonButton.tag = indexPath.row
            cell.leadTagSelectonButton.addTarget(self, action: #selector(leadTagMethod), for: .touchDown)
            cell.leadTagSelectonButton.tag = indexPath.row
            return cell
        } else if emailAndSMSDetailList[indexPath.row].cellType == "Patient" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSPatientActionTableViewCell", for: indexPath) as? MassEmailandSMSPatientActionTableViewCell else { return UITableViewCell()}
            cell.delegate = self
            cell.patientStatusSelectonButton.addTarget(self, action: #selector(patientStatusMethod), for: .touchDown)
            cell.patientStatusSelectonButton.tag = indexPath.row
            cell.patientTagSelectonButton.addTarget(self, action: #selector(patientTagMethod), for: .touchDown)
            cell.patientTagSelectonButton.tag = indexPath.row
            cell.patientAppointmentButton.addTarget(self, action: #selector(patientAppointmentMethod), for: .touchDown)
            cell.patientAppointmentButton.tag = indexPath.row
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
    
    @objc func leadStatusMethod(sender: UIButton) {
        let leadStatusArray = ["NEW", "COLD", "WARM", "HOT", "WON","DEAD"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadStatusTextLabel.text = "Select lead status"
                } else {
                    leadCell.leadStatusTextLabel.text = selectedList.joined(separator: ",")
                }
            }
        }
        
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadSourceMethod(sender: UIButton) {
        let leadSourceArray = ["ChatBot", "Landing Page", "Virtual-Consultation", "Form", "Manual","Facebook"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadSourceArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadSourceTextLabel.text = "Select lead source"
                } else {
                    leadCell.leadSourceTextLabel.text = selectedList.joined(separator: ",")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadSourceArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func leadTagMethod(sender: UIButton) {
        leadTagsArray = viewModel?.getMassEmailLeadTagsData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadTagsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let leadCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSLeadActionTableViewCell {
                if selectedList.count == 0 {
                    leadCell.leadTagTextLabel.text = "Select lead tag"
                } else {
                    leadCell.leadTagTextLabel.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
                    let selectedId = selectedList.map({$0.id ?? 0})
                    self?.selectedLeadTags  = selectedList
                    let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
                    self?.selectedLeadTagIds = formattedArray
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadTagsArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func patientStatusMethod(sender: UIButton) {
        let leadStatusArray = ["NEW", "EXISTING"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: leadStatusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSPatientActionTableViewCell {
                if selectedList.count == 0 {
                    patientCell.patientStatusTextLabel.text = "Select patient status"
                } else {
                    patientCell.patientStatusTextLabel.text = selectedList.joined(separator: ",")
                }
            }
        }
        
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(leadStatusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func patientAppointmentMethod(sender: UIButton) {
        let statusArray = ["Pending", "Confirmed", "Completed", "Cancelled", "Updated"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: statusArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSPatientActionTableViewCell {
                if selectedList.count == 0 {
                    patientCell.patientAppointmenTextLabel.text = "Select patient appointment"
                } else {
                    patientCell.patientAppointmenTextLabel.text = selectedList.joined(separator: ",")
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(statusArray.count * 30))), arrowDirection: .up), from: self)
    }
    
    @objc func patientTagMethod(sender: UIButton) {
        patientTagsArray = viewModel?.getMassEmailPateintsTagsData ?? []
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: patientTagsArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name?.components(separatedBy: " ").first
        }
        let row = sender.tag % 1000
        selectionMenu.setSelectedItems(items: []) { [weak self] (selectedItem, index, selected, selectedList) in
            let cellIndexPath = IndexPath(item: row, section: 0)
            if let patientCell = self?.emailAndSMSTableView.cellForRow(at: cellIndexPath) as? MassEmailandSMSPatientActionTableViewCell {
                if selectedList.count == 0 {
                    patientCell.patientTagTextLabel.text = "Select patient tag"
                } else {
                    patientCell.patientTagTextLabel.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
                    let selectedId = selectedList.map({$0.id ?? 0})
                    self?.selectedPatientTags = selectedList
                    let formattedArray = selectedList.map{String($0.id ?? 0)}.joined(separator: ",")
                    self?.selectedPatientTagIds = formattedArray
                }
            }
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(patientTagsArray.count * 30))), arrowDirection: .up), from: self)
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
    func nextButtonLead(cell: MassEmailandSMSLeadActionTableViewCell, index: IndexPath) {
        self.view.ShowSpinner()
        viewModel?.getMassEmailLeadStatusMethod(leadStatus: cell.leadStatusTextLabel.text ?? String.blank, moduleName: "MassLead", leadTagIds: selectedLeadTagIds, source: cell.leadSourceTextLabel.text ?? String.blank)
    }
}

extension MassEmailandSMSDetailViewController: MassEmailandSMSPatientCellDelegate {
    func nextButtonPatient(cell: MassEmailandSMSPatientActionTableViewCell, index: IndexPath) {
        self.view.ShowSpinner()
        viewModel?.getMassEmailPatientStatusMethod(appointmentStatus: cell.patientAppointmenTextLabel.text ?? String.blank, moduleName: "MassPatient", patientTagIds: selectedPatientTagIds, patientStatus: cell.patientStatusTextLabel.text ?? String.blank)
    }
}
