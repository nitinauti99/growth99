//
//  VacationScheduleViewController+Extension.swift
//  Growth99
//
//  Created by admin on 06/12/22.
//

import Foundation
import UIKit

extension VacationScheduleViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "VacationsHeadeView") as! VacationsHeadeView
        headerView.delegate = self
        headerView.tag = section
        
        if isEmptyResponse == false {
            headerView.dateFromTextField.text = vacationViewModel?.serverToLocal(date: vacationsList[section].fromDate ?? String.blank)
            headerView.dateToTextField.text = vacationViewModel?.serverToLocal(date: vacationsList[section].toDate ?? String.blank)
        } else {
            headerView.dateFromTextField.text = String.blank
            headerView.dateToTextField.text = String.blank
        }
       
        headerView.buttondateFromTextFieldCallback = { [weak self] (textFiled) in
           
            if let headerView = self?.vacationsListTableView.headerView(forSection: section) as? VacationsHeadeView {
                headerView.updateDateFromTextField(with: self?.vacationViewModel?.dateFormatterString(textField: textFiled) ?? String.blank)
            }
        }
        
        headerView.buttondateToTextFieldCallback = { [weak self] (textFiled) in
            if let headerView = self?.vacationsListTableView.headerView(forSection: section) as? VacationsHeadeView {
                headerView.updateDateToTextField(with: self?.vacationViewModel?.dateFormatterString(textField: textFiled) ?? String.blank)
            }
        }
        return headerView
    }
    
    // MARK: - Tableview delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return vacationsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vacationsList[section].userScheduleTimings?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VacationsCustomTableViewCell", for: indexPath) as? VacationsCustomTableViewCell else { fatalError("Unexpected Error") }
        
        if isEmptyResponse == false {
            cell.updateTimeFromTextField(with: vacationViewModel?.serverToLocalTime(timeString: vacationsList[indexPath.section].userScheduleTimings?[indexPath.row].timeFromDate ?? String.blank) ?? String.blank)
            cell.updateTimeToTextField(with: vacationViewModel?.serverToLocalTime(timeString: vacationsList[indexPath.section].userScheduleTimings?[indexPath.row].timeToDate ?? String.blank) ?? String.blank)
            if vacationsList[indexPath.section].userScheduleTimings?.count ?? 0 > 1 {
                cell.removeTimeButton.isHidden = false
            } else {
                cell.removeTimeButton.isHidden = true
            }
        } else {
            if vacationsList[indexPath.section].userScheduleTimings?.count ?? 0 > 1 {
                cell.removeTimeButton.isHidden = false
            } else {
                cell.removeTimeButton.isHidden = true
            }
            cell.updateTimeFromTextField(with: String.blank)
            cell.updateTimeToTextField(with: String.blank)
        }
        
        let totalcount = (vacationsList[indexPath.section].userScheduleTimings?.count ?? 0) - 1
        cell.borderView.isHidden = true
        cell.removeTimeButton.isHidden = true

        if (totalcount == 0) {
            cell.borderView.isHidden = false
        }else if (totalcount > 0 && indexPath.row == totalcount) {
            print("last Index")
            cell.borderView.isHidden = false
            cell.removeTimeButton.isHidden = false
        }
        
        /// set bottom view only for last object
        cell.buttonRemoveTapCallback = {
            self.deleteRow(selectedSection: indexPath, selectedIndex: indexPath.row)
        }
        cell.buttonAddTimeTapCallback = {
            self.addRow(selectedSection: indexPath, selectedIndex: indexPath.row)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    // MARK: - Delete vacations row method
    @objc func deleteRow(selectedSection: IndexPath, selectedIndex: Int) {
        vacationsListTableView.beginUpdates()
        vacationsList[selectedSection.section].userScheduleTimings?.remove(at: selectedIndex)
        vacationsListTableView.deleteRows(at: [selectedSection], with: .fade)
        vacationsListTableView.endUpdates()
        vacationsListTableView.reloadRows(at: [selectedSection], with: .fade)
        vacationScrollViewHight.constant = vacationTableViewHeight + 450
       
        let indexPath = IndexPath(row: selectedIndex - 1, section: selectedSection.section)

        if let vacationCell = self.vacationsListTableView.cellForRow(at: indexPath) as? VacationsCustomTableViewCell {
            vacationCell.borderView.isHidden = false
            vacationCell.removeTimeButton.isHidden =  false
            if vacationsList[indexPath.section].userScheduleTimings?.count ?? 0  == 1 {
                vacationCell.removeTimeButton.isHidden =  true
            }
        }
    }
    
    // MARK: - Add vacations row method
    @objc func addRow(selectedSection: IndexPath, selectedIndex: Int) {
        let date1 = UserScheduleTimings(id: 1, timeFromDate:  String.blank, timeToDate:  String.blank, days: [])
        vacationsList[selectedSection.section].userScheduleTimings?.append(date1)
        vacationsListTableView.beginUpdates()
        isEmptyResponse = true
        let indexPath = IndexPath(row: selectedIndex + 1, section: selectedSection.section)
        vacationsListTableView.insertRows(at: [indexPath], with: .fade)
        vacationsListTableView.endUpdates()
        vacationScrollViewHight.constant = vacationTableViewHeight + 450
      
        let indexPathRemoveButton = IndexPath(row: selectedIndex, section: selectedSection.section)

        if let vacationCell = self.vacationsListTableView.cellForRow(at: indexPathRemoveButton) as? VacationsCustomTableViewCell {
            vacationCell.removeTimeButton.isHidden =  true
        }
    }
    
    // MARK: - Time from button tapped
    func buttontimeFromTapped(cell: VacationsCustomTableViewCell) {
        guard let indexPath = self.vacationsListTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = self.vacationsListTableView.cellForRow(at: cellIndexPath) as? VacationsCustomTableViewCell {
            vacationCell.updateTimeFromTextField(with: self.vacationViewModel?.timeFormatterString(textField: cell.timeFromTextField) ?? String.blank)
        }
    }
    
    // MARK: - Time to button tapped
    func buttontimeToTapped(cell: VacationsCustomTableViewCell) {
        guard let indexPath = self.vacationsListTableView.indexPath(for: cell) else {
            return
        }
        let cellIndexPath = IndexPath(item: indexPath.row, section: indexPath.section)
        if let vacationCell = self.vacationsListTableView.cellForRow(at: cellIndexPath) as? VacationsCustomTableViewCell {
            vacationCell.updateTimeToTextField(with: self.vacationViewModel?.timeFormatterString(textField: cell.timeToTextField) ?? String.blank)
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
        vacationScrollViewHight.constant = vacationTableViewHeight + 450
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        vacationScrollViewHight.constant = vacationTableViewHeight + 450
    }
}

extension VacationScheduleViewController: VacationsHeadeViewDelegate {
    
    // MARK: - delete section from headerview
    func delateSectionButtonTapped(view: VacationsHeadeView) {
        let section = view.tag
        vacationsListTableView.beginUpdates()
        vacationsList.remove(at: section)
        vacationsListTableView.deleteSections([section], with: .fade)
        vacationsListTableView.endUpdates()
        vacationScrollViewHight.constant = vacationTableViewHeight + 450
    }
}
