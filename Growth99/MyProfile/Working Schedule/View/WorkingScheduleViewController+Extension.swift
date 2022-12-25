//
//  WorkingScheduleViewController+Extension.swift
//  Growth99
//
//  Created by admin on 06/12/22.
//

import Foundation
import UIKit

extension WorkingScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0 {
            return 1
        } else {
            return workingListModel?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return allClinicsForWorkingSchedule?.count ?? 0
        } else {
            return workingListModel?[section].userScheduleTimings?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCustomTableViewCell", for: indexPath) as? DropDownCustomTableViewCell else { fatalError("Unexpected Error") }
            cell.selectionStyle = .none
            cell.lblDropDownTitle.text = allClinicsForWorkingSchedule?[indexPath.row].name ?? String.blank
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkingCustomTableViewCell", for: indexPath) as? WorkingCustomTableViewCell else { fatalError("Unexpected Error") }
            if isEmptyResponse == false {
                cell.updateTextLabel(with: workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].days)
                cell.updateTimeFromTextField(with: workingScheduleViewModel.serverToLocalTime(timeString: workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeFromDate ?? String.blank))
                cell.updateTimeToTextField(with: workingScheduleViewModel.serverToLocalTime(timeString: workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeToDate ?? String.blank))
            }
            cell.buttoneRemoveDaysTapCallback = {
                self.deleteDaysRow(selectedSection: indexPath, selectedIndex: indexPath.row)
            }
            cell.delegate = self
            return cell
        }
    }
    
    @objc func deleteDaysRow(selectedSection: IndexPath, selectedIndex: Int) {
        workingListTableView.beginUpdates()
        workingListModel?[selectedSection.section].userScheduleTimings?.remove(at: selectedIndex)
        workingListTableView.deleteRows(at: [selectedSection], with: .fade)
        workingListTableView.endUpdates()
        if workingListModel?[selectedSection.section].userScheduleTimings?.count ?? 0 == 0 {
            workingListModel?.removeAll()
        }
        workingListTableView.reloadData()
        workingScrollViewHight.constant = tableViewHeight + 650
    }

    func buttonWorkingtimeFromTapped(cell: WorkingCustomTableViewCell) {
        guard let indexPath = workingListTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = workingListTableView.cellForRow(at: cellIndexPath) as? WorkingCustomTableViewCell {
            vacationCell.updateTimeFromTextField(with: workingScheduleViewModel.timeFormatterString(textField: cell.timeFromTextField))
        }
    }
    
    func buttonWorkingtimeToTapped(cell: WorkingCustomTableViewCell) {
        guard let indexPath = workingListTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = workingListTableView.cellForRow(at: cellIndexPath) as? WorkingCustomTableViewCell {
            vacationCell.updateTimeToTextField(with: workingScheduleViewModel.timeFormatterString(textField: cell.timeToTextField))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            self.view.ShowSpinner()
            clinicTextLabel.text = allClinicsForWorkingSchedule?[indexPath.row].name ?? String.blank
            selectedClinicId = allClinicsForWorkingSchedule?[indexPath.row].id ?? 0
            workingScheduleViewModel.getWorkingScheduleDeatils(selectedClinicId: selectedClinicId)
            workingDateFromTextField.text = ""
            workingDateToTextField.text = ""
            hideClinicDropDown()
        }
    }
}

extension WorkingScheduleViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}

