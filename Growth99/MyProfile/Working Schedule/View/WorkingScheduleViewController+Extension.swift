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
                print("Index:::: \(indexPath.section) :::: \(indexPath.row)")
                cell.updateTimeFromTextField(with: workingScheduleViewModel.serverToLocalTime(timeString: workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeFromDate ?? String.blank))
                cell.updateTimeToTextField(with: workingScheduleViewModel.serverToLocalTime(timeString: workingListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeToDate ?? String.blank))
            }
            return cell
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
            hideClinicDropDown()
        }
    }
}

extension WorkingScheduleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        workingScrollViewHight.constant = vacationTableViewHeight + 650
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        workingScrollViewHight.constant = vacationTableViewHeight + 650
    }
}

extension WorkingScheduleViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}

