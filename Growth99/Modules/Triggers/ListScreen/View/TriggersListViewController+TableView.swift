//
//  TriggersListViewController+TableView.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import Foundation
import UIKit

extension TriggersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = self.triggerSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                if viewModel?.getTriggersFilterData.count ?? 0 == 0 {
                    self.triggersListTableView.setEmptyMessage()
                } else {
                    self.triggersListTableView.restore()
                }
                return viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.leads}).count ?? 0
            } else {
                if viewModel?.getTriggersData.count ?? 0 == 0 {
                    self.triggersListTableView.setEmptyMessage()
                } else {
                    self.triggersListTableView.restore()
                }
                return viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.leads}).count ?? 0
            }
        case 1:
            if isSearch {
                if viewModel?.getTriggersFilterData.count ?? 0 == 0 {
                    self.triggersListTableView.setEmptyMessage()
                } else {
                    self.triggersListTableView.restore()
                }
                return viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.appointmentTrigger}).count ?? 0
            } else {
                if viewModel?.getTriggersData.count ?? 0 == 0 {
                    self.triggersListTableView.setEmptyMessage()
                } else {
                    self.triggersListTableView.restore()
                }
                return viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.appointmentTrigger}).count ?? 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = LeadTriggersTableViewCell()
        cell = triggersListTableView.dequeueReusableCell(withIdentifier: "LeadTriggersTableViewCell") as! LeadTriggersTableViewCell
        cell.delegate = self
        let selectedIndex = self.triggerSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.leads})
                cell.configureCell(triggerFilterList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.leads})
                cell.configureCell(triggerList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            }
        case 1:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                cell.configureCell(triggerFilterList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                cell.configureCell(triggerList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
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
        let createTriggersVC = UIStoryboard(name: "TriggerEditDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "TriggerEditDetailViewController") as! TriggerEditDetailViewController
        let selectedIndex = self.triggerSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.leads})
                createTriggersVC.triggerId = filteredArray?[indexPath.row].id
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.leads})
                createTriggersVC.triggerId = filteredArray?[indexPath.row].id
            }
        case 1:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                createTriggersVC.triggerId = filteredArray?[indexPath.row].id
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                createTriggersVC.triggerId = filteredArray?[indexPath.row].id
            }
        default:
            break
        }
        self.navigationController?.pushViewController(createTriggersVC, animated: true)
    }
}


extension TriggersListViewController: TriggerSourceDelegate {
    
    func didTapSwitchButton(triggerId: String, triggerStatus: String) {
        self.view.ShowSpinner()
        viewModel?.getSwitchOnButton(triggerId: triggerId, triggerStatus: triggerStatus)
    }
    
    func editSelectedTrigger(cell: LeadTriggersTableViewCell, index: IndexPath) {
        let createTriggersVC = UIStoryboard(name: "TriggerEditDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "TriggerEditDetailViewController") as! TriggerEditDetailViewController
        let selectedIndex = self.triggerSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.leads})
                createTriggersVC.triggerId = filteredArray?[index.row].id
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.leads})
                createTriggersVC.triggerId = filteredArray?[index.row].id
            }
        case 1:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                createTriggersVC.triggerId = filteredArray?[index.row].id
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                createTriggersVC.triggerId = filteredArray?[index.row].id
            }
        default:
            break
        }
        self.navigationController?.pushViewController(createTriggersVC, animated: true)
    }
    
    func removeSelectedTrigger(cell: LeadTriggersTableViewCell, index: IndexPath) {
        var selectedTriggerId = Int()
        let selectedIndex = self.triggerSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.leads})
                selectedTriggerId = filteredArray?[index.row].id ?? 0
                let alert = UIAlertController(title: "Delete Trigger", message: "Are you sure you want to delete \(filteredArray?[index.row].name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
                let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                                handler: { [weak self] _ in
                    self?.view.ShowSpinner()
                    self?.viewModel?.removeSelectedTrigger(selectedId: selectedTriggerId)
                })
                cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
                alert.addAction(cancelAlert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.leads})
                selectedTriggerId = filteredArray?[index.row].id ?? 0
                let alert = UIAlertController(title: "Delete Trigger", message: "Are you sure you want to delete \(filteredArray?[index.row].name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
                let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                                handler: { [weak self] _ in
                    self?.view.ShowSpinner()
                    self?.viewModel?.removeSelectedTrigger(selectedId: selectedTriggerId)
                })
                cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
                alert.addAction(cancelAlert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case 1:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                selectedTriggerId = filteredArray?[index.row].id ?? 0
                let alert = UIAlertController(title: "Delete Trigger", message: "Are you sure you want to delete \( filteredArray?[index.row].name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
                let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                                handler: { [weak self] _ in
                    self?.view.ShowSpinner()
                    self?.viewModel?.removeSelectedTrigger(selectedId: selectedTriggerId)
                })
                cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
                alert.addAction(cancelAlert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                selectedTriggerId = filteredArray?[index.row].id ?? 0
                let alert = UIAlertController(title: "Delete Trigger", message: "Are you sure you want to delete \( filteredArray?[index.row].name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
                let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                                handler: { [weak self] _ in
                    self?.view.ShowSpinner()
                    self?.viewModel?.removeSelectedTrigger(selectedId: selectedTriggerId)
                })
                cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
                alert.addAction(cancelAlert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func triggerRemovedSuccefully(message: String) {
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        self.getTriggersList()
    }
}
