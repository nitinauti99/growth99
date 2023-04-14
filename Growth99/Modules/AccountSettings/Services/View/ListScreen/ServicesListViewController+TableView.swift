//
//  ServicesListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 03/03/23.
//

import Foundation
import UIKit

extension ServicesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getServiceFilterListData.count ?? 0 == 0 {
                self.servicesListTableView.setEmptyMessage()
            } else {
                self.servicesListTableView.restore()
            }
            return viewModel?.getServiceFilterListData.count ?? 0
        } else {
            if viewModel?.getServiceListData.count ?? 0 == 0 {
                self.servicesListTableView.setEmptyMessage()
            } else {
                self.servicesListTableView.restore()
            }
            return viewModel?.getServiceListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ServicesListTableViewCell()
        cell = servicesListTableView.dequeueReusableCell(withIdentifier: "ServicesListTableViewCell") as! ServicesListTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCell(serviceFilterList: viewModel, index: indexPath, isSearch: isSearch)
        } else {
            cell.configureCell(serviceListData: viewModel, index: indexPath)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let createServiceVC = UIViewController.loadStoryboard("ServicesListDetailViewController", "ServicesListDetailViewController") as? ServicesListDetailViewController else {
            fatalError("Failed to load ServicesListDetailViewController from storyboard.")
        }
        createServiceVC.screenTitle = Constant.Profile.editService
        if isSearch {
            createServiceVC.serviceId = viewModel?.getServiceFilterListData[indexPath.row].id
        } else {
            createServiceVC.serviceId = viewModel?.getServiceListData[indexPath.row].id
        }
        self.navigationController?.pushViewController(createServiceVC, animated: true)
    }
}

extension ServicesListViewController: ServiceListCellDelegate {
    
    func editServices(cell: ServicesListTableViewCell, index: IndexPath) {
        guard let createServiceVC = UIViewController.loadStoryboard("ServicesListDetailViewController", "ServicesListDetailViewController") as? ServicesListDetailViewController else {
            fatalError("Failed to load ServicesListDetailViewController from storyboard.")
        }
        createServiceVC.screenTitle = Constant.Profile.editService
        if isSearch {
            createServiceVC.serviceId = viewModel?.getServiceFilterListData[index.row].id
        } else {
            createServiceVC.serviceId = viewModel?.getServiceListData[index.row].id
        }
        self.navigationController?.pushViewController(createServiceVC, animated: true)
    }
    
    func removeSelectedService(cell: ServicesListTableViewCell, index: IndexPath) {
        var selectedServiceId = Int()
        if isSearch {
            selectedServiceId = viewModel?.getServiceFilterListData[index.row].id ?? 0
            let alert = UIAlertController(title: "Delete Service", message: "Are you sure you want to delete \(viewModel?.getServiceFilterDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
            let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                self?.view.ShowSpinner()
                self?.viewModel?.removeSelectedCService(serviceId: selectedServiceId)
            })
            cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAlert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            selectedServiceId = viewModel?.getServiceListData[index.row].id ?? 0
            let alert = UIAlertController(title: "Delete Service", message: "Are you sure you want to delete \(viewModel?.getServiceDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
            let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { [weak self] _ in
                self?.view.ShowSpinner()
                self?.viewModel?.removeSelectedCService(serviceId: selectedServiceId)
            })
            cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAlert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func serviceRemovedSuccefully(message: String) {
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        self.getUserList()
    }
}
