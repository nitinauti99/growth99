//
//  MassEmailandSMSViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 04/03/23.
//


import Foundation
import UIKit

extension MassEmailandSMSViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = self.massEmailSMSSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                if viewModel?.getMassEmailandSMSFilterData.count ?? 0 == 0 {
                    self.massEmailandSMSTableView.setEmptyMessage()
                } else {
                    self.massEmailandSMSTableView.restore()
                }
                return viewModel?.getMassEmailandSMSFilterData.filter({ $0.emailFlag == true
                }).count ?? 0
            } else {
                if viewModel?.getMassEmailandSMSData.count ?? 0 == 0 {
                    self.massEmailandSMSTableView.setEmptyMessage()
                } else {
                    self.massEmailandSMSTableView.restore()
                }
                return viewModel?.getMassEmailandSMSData.filter({ $0.emailFlag == true
                }).count ?? 0
            }
        case 1:
            if isSearch {
                if viewModel?.getMassEmailandSMSFilterData.count ?? 0 == 0 {
                    self.massEmailandSMSTableView.setEmptyMessage()
                } else {
                    self.massEmailandSMSTableView.restore()
                }
                return viewModel?.getMassEmailandSMSFilterData.filter({ $0.smsFlag == true
                }).count ?? 0
            } else {
                if viewModel?.getMassEmailandSMSData.count ?? 0 == 0 {
                    self.massEmailandSMSTableView.setEmptyMessage()
                } else {
                    self.massEmailandSMSTableView.restore()
                }
                return viewModel?.getMassEmailandSMSData.filter({ $0.smsFlag == true
                }).count ?? 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MassEmailandSMSTableViewCell", for: indexPath) as? MassEmailandSMSTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        let selectedIndex = self.massEmailSMSSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                let filteredArray = viewModel?.getMassEmailandSMSFilterData.filter({$0.emailFlag == true})
                cell.configureCell(massEmailFilterList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            } else {
                let filteredArray = viewModel?.getMassEmailandSMSData.filter({$0.emailFlag == true})
                cell.configureCell(massEmailList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            }
        case 1:
            if isSearch {
                let filteredArray = viewModel?.getMassEmailandSMSFilterData.filter({$0.smsFlag == true})
                cell.configureCell(massEmailFilterList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            } else {
                let filteredArray = viewModel?.getMassEmailandSMSData.filter({$0.smsFlag == true})
                cell.configureCell(massEmailList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = UIStoryboard(name: "EventEditViewController", bundle: nil).instantiateViewController(withIdentifier: "EventEditViewController") as! EventEditViewController
        if isSearch {
            editVC.appointmentId = viewModel?.getMassEmailandSMSFilterData[indexPath.row].id
            // editVC.editMassEmailData = viewModel?.getMassEmailFilterListData[indexPath.row]
        } else {
            editVC.appointmentId = viewModel?.getMassEmailandSMSData[indexPath.row].id
            // editVC.editMassEmailData = viewModel?.getMassEmailListData[indexPath.row]
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
}
