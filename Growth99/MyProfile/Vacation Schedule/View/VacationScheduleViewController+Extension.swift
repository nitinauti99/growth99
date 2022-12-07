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
        return vacationsListModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacationsListModel?[section].userScheduleTimings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VacationsCustomTableViewCell", for: indexPath) as? VacationsCustomTableViewCell else { fatalError("Unexpected Error") }
        cell.buttonRemoveTapCallback = {
            self.deleteRow(selectedSection: indexPath, selectedIndex: indexPath.row)
        }
        cell.buttonAddTimeTapCallback = {
            self.addRow(selectedSection: indexPath.section, selectedIndexPath: indexPath)
        }
        cell.delegate = self
        return cell
    }
    
    @objc func deleteRow(selectedSection: IndexPath, selectedIndex: Int) {
        vacationsListTableView.beginUpdates()
        vacationsListModel?[selectedSection.section].userScheduleTimings?.remove(at: selectedIndex)
        vacationsListTableView.deleteRows(at: [selectedSection], with: .fade)
        vacationsListTableView.reloadData()
        vacationsListTableView.endUpdates()
    }
    
    @objc func addRow(selectedSection: Int, selectedIndexPath: IndexPath) {
        let date1 = UserScheduleTimings(id: 1, timeFromDate: "2022-12-16T00:00:00.000+0000", timeToDate: "2022-12-21T00:00:00.000+0000", days: "")
        vacationsListModel?[selectedSection].userScheduleTimings?.append(date1)
        vacationsListTableView.beginUpdates()
        vacationsListTableView.insertRows(at: [selectedIndexPath], with: .fade)
        vacationsListTableView.reloadData()
        vacationsListTableView.endUpdates()
    }
    
    func buttontimeFromTapped(cell: VacationsCustomTableViewCell) {
        guard let indexPath = self.vacationsListTableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = self.vacationsListTableView.cellForRow(at: cellIndexPath) as? VacationsCustomTableViewCell {
            vacationCell.updateTimeFromTextField(with: self.vacationViewModel.timeFormatterString(textField: cell.timeFromTextField))
        }
    }
    
    func buttontimeToTapped(cell: VacationsCustomTableViewCell) {
        guard let indexPath = self.vacationsListTableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
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
        headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "VacationsHeadeView") as! VacationsHeadeView
        headerView.delegate = self
        headerView.tag = section
        
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
        manageAddTimeButton(section: section)
        return headerView
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
        if vacationsListModel?[section].userScheduleTimings?.count == 0 {
            return 260
        } else {
            return 200
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
        let date1 = UserScheduleTimings(id: 1, timeFromDate: "2022-12-16T00:00:00.000+0000", timeToDate: "2022-12-21T00:00:00.000+0000", days: "")
        vacationsListModel?[section].userScheduleTimings?.append(date1)
        vacationsListTableView.beginUpdates()
        let indexPath = IndexPath(row: 0, section: section)
        vacationsListTableView.insertRows(at: [indexPath], with: .fade)
        vacationsListTableView.reloadData()
        vacationsListTableView.endUpdates()
    }
}
