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
                self.servicesListTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.servicesListTableView.restore()
            }
            return viewModel?.getServiceFilterListData.count ?? 0
        } else {
            if viewModel?.getServiceListData.count ?? 0 == 0 {
                self.servicesListTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.servicesListTableView.restore()
            }
            return viewModel?.getServiceListData.sorted(by: { ($0.createdAt ?? String.blank) > ($1.createdAt ?? String.blank)}).count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ServicesListTableViewCell()
        cell = servicesListTableView.dequeueReusableCell(withIdentifier: "ServicesListTableViewCell") as! ServicesListTableViewCell
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
