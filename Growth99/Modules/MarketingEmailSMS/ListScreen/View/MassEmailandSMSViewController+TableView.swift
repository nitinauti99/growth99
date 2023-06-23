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
        let massSMSEditvc = UIStoryboard(name: "MassEmailandSMSEditDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "MassEmailandSMSEditDetailViewController") as! MassEmailandSMSEditDetailViewController
        let selectedIndex = self.massEmailSMSSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                let filteredArray = viewModel?.getMassEmailandSMSFilterData.filter({$0.emailFlag == true})
                massSMSEditvc.massSMStriggerId = filteredArray?[indexPath.row].id
                let triggerType = viewModel?.getMassEmailandSMSFilterData[indexPath.row].emailFlag ?? false
                if triggerType {
                    massSMSEditvc.triggerCommunicationType = "MASS_EMAIL"
                } else {
                    massSMSEditvc.triggerCommunicationType = "MASS_SMS"
                }
            } else {
                let filteredArray = viewModel?.getMassEmailandSMSData.filter({$0.emailFlag == true})
                massSMSEditvc.massSMStriggerId = filteredArray?[indexPath.row].id
                let triggerType = viewModel?.getMassEmailandSMSData[indexPath.row].emailFlag ?? false
                if triggerType {
                    massSMSEditvc.triggerCommunicationType = "MASS_EMAIL"
                } else {
                    massSMSEditvc.triggerCommunicationType = "MASS_SMS"
                }
            }
        case 1:
            if isSearch {
                let filteredArray = viewModel?.getMassEmailandSMSFilterData.filter({$0.smsFlag == true})
                massSMSEditvc.massSMStriggerId = filteredArray?[indexPath.row].id
                let triggerType = viewModel?.getMassEmailandSMSFilterData[indexPath.row].emailFlag ?? false
                if triggerType {
                    massSMSEditvc.triggerCommunicationType = "MASS_EMAIL"
                } else {
                    massSMSEditvc.triggerCommunicationType = "MASS_SMS"
                }
            } else {
                let filteredArray = viewModel?.getMassEmailandSMSData.filter({$0.smsFlag == true})
                massSMSEditvc.massSMStriggerId = filteredArray?[indexPath.row].id
                let triggerType = viewModel?.getMassEmailandSMSData[indexPath.row].emailFlag ?? false
                if triggerType {
                    massSMSEditvc.triggerCommunicationType = "MASS_EMAIL"
                } else {
                    massSMSEditvc.triggerCommunicationType = "MASS_SMS"
                }
            }
        default:
            break
        }
        self.navigationController?.pushViewController(massSMSEditvc, animated: true)
    }
}
