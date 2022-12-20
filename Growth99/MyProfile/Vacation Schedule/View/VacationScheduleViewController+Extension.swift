//
//  VacationScheduleViewController+Extension.swift
//  Growth99
//
//  Created by admin on 06/12/22.
//

import Foundation
import UIKit

extension VacationScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0 {
            return 1
        } else {
            return vacationsListModel?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return allClinicsForVacation?.count ?? 0
        } else {
            return vacationsListModel?[section].userScheduleTimings?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCustomTableViewCell", for: indexPath) as? DropDownCustomTableViewCell else { fatalError("Unexpected Error") }
            cell.selectionStyle = .none
            cell.lblDropDownTitle.text = allClinicsForVacation?[indexPath.row].name ?? String.blank
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "VacationsCustomTableViewCell", for: indexPath) as? VacationsCustomTableViewCell else { fatalError("Unexpected Error") }
            if isEmptyResponse == false {
                print("Index:::: \(indexPath.section) :::: \(indexPath.row)")
                cell.updateTimeFromTextField(with: vacationViewModel.serverToLocalTime(timeString: vacationsListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeFromDate ?? String.blank))
                cell.updateTimeToTextField(with: vacationViewModel.serverToLocalTime(timeString: vacationsListModel?[indexPath.section].userScheduleTimings?[indexPath.row].timeToDate ?? String.blank))
            }
           
            cell.buttonRemoveTapCallback = {
                self.deleteRow(selectedSection: indexPath, selectedIndex: indexPath.row)
            }
            cell.buttonAddTimeTapCallback = {
                self.addRow(selectedSection: indexPath, selectedIndex: indexPath.row)
            }
            cell.delegate = self
            return cell
        }
    }
    
    @objc func deleteRow(selectedSection: IndexPath, selectedIndex: Int) {
        vacationsListTableView.beginUpdates()
        vacationsListModel?[selectedSection.section].userScheduleTimings?.remove(at: selectedIndex)
        vacationsListTableView.deleteRows(at: [selectedSection], with: .fade)
        vacationsListTableView.endUpdates()
    }
    
    @objc func addRow(selectedSection: IndexPath, selectedIndex: Int) {
        let date1 = UserScheduleTimings(id: 1, timeFromDate: "", timeToDate: "", days: "")
        vacationsListModel?[selectedSection.section].userScheduleTimings?.append(date1)
        vacationsListTableView.beginUpdates()
        isEmptyResponse = true
        let indexPath = IndexPath(row: selectedIndex + 1, section: selectedSection.section)
        vacationsListTableView.insertRows(at: [indexPath], with: .fade)
        vacationsListTableView.endUpdates()
    }
    
    func buttontimeFromTapped(cell: VacationsCustomTableViewCell) {
        guard let indexPath = self.vacationsListTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = self.vacationsListTableView.cellForRow(at: cellIndexPath) as? VacationsCustomTableViewCell {
            vacationCell.updateTimeFromTextField(with: self.vacationViewModel.timeFormatterString(textField: cell.timeFromTextField))
        }
    }
    
    func buttontimeToTapped(cell: VacationsCustomTableViewCell) {
        guard let indexPath = self.vacationsListTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = self.vacationsListTableView.cellForRow(at: cellIndexPath) as? VacationsCustomTableViewCell {
            vacationCell.updateTimeToTextField(with: self.vacationViewModel.timeFormatterString(textField: cell.timeToTextField))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 0 {
            return UIView()
        } else {
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "VacationsHeadeView") as! VacationsHeadeView
            headerView.delegate = self
            headerView.tag = section
            
            if isEmptyResponse == false {
                if vacationsListModel?.count ?? 0 > 0 {
                    manageAddTimeButton(section: section)
                    headerView.dateFromTextField.text = vacationViewModel.serverToLocal(date: vacationsListModel?[section].fromDate ?? String.blank)
                    headerView.dateToTextField.text = vacationViewModel.serverToLocal(date: vacationsListModel?[section].toDate ?? String.blank)
                }
            }
            
            headerView.buttondateFromTextFieldCallback = { [weak self] (textFiled) in
                if let headerView = self?.vacationsListTableView.headerView(forSection: section) as? VacationsHeadeView {
                    headerView.updateDateFromTextField(with: self?.vacationViewModel.dateFormatterString(textField: textFiled) ?? String.blank)
                }
            }
            
            headerView.buttondateToTextFieldCallback = { [weak self] (textFiled) in
                if let headerView = self?.vacationsListTableView.headerView(forSection: section) as? VacationsHeadeView {
                    headerView.updateDateToTextField(with: self?.vacationViewModel.dateFormatterString(textField: textFiled) ?? String.blank)
                }
            }
            return headerView
        }
    }
    
    func manageAddTimeButton(section: Int) {
        if vacationsListModel?[section].userScheduleTimings?.count == 0 {
            headerView.addTimeButtonHeightConstraint.constant = 50
            headerView.addTimeButtonTopHeightConstraint.constant = 16
            headerView.addTimeButton.isHidden = false
        } else {
            headerView.addTimeButtonHeightConstraint.constant = 0
            headerView.addTimeButtonTopHeightConstraint.constant = 0
            headerView.addTimeButton.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 0 {
            return 0
        } else {
            if vacationsListModel?[section].userScheduleTimings?.count == 0 {
                return 260
            } else {
                return 200
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            self.view.ShowSpinner()
            clinicTextLabel.text = allClinicsForVacation?[indexPath.row].name ?? String.blank
            selectedClinicId = allClinicsForVacation?[indexPath.row].id ?? 0
            vacationViewModel.getVacationDeatils(selectedClinicId: selectedClinicId)
            hideClinicDropDown()
        }
     }
}

extension VacationScheduleViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}

extension VacationScheduleViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        vacationScrollViewHight.constant = vacationTableViewHeight + 500
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        vacationScrollViewHight.constant = vacationTableViewHeight + 500
    }
}

extension VacationScheduleViewController: VacationsHeadeViewDelegate {
    
    func addTimeButton(view: VacationsHeadeView) {
        let section = view.tag
        let date1 = UserScheduleTimings(id: 1, timeFromDate: "", timeToDate: "", days: "")
        vacationsListModel?[section].userScheduleTimings?.append(date1)
        vacationsListTableView.beginUpdates()
        isEmptyResponse = true
        let indexPath = IndexPath(row: 0, section: section)
        vacationsListTableView.insertRows(at: [indexPath], with: .fade)
        manageAddTimeButton(section: section)
        vacationsListTableView.endUpdates()
    }
    
    func delateSectionButtonTapped(view: VacationsHeadeView) {
        let section = view.tag
        vacationsListTableView.beginUpdates()
        vacationsListModel?.remove(at: section)
        vacationsListTableView.deleteSections([section], with: .fade)
        vacationsListTableView.reloadData()
        vacationsListTableView.endUpdates()
    }
}
