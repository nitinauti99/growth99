//
//  HomeViewContoller+OpenDeopDown.swift
//  Growth99
//
//  Created by Nitin Auti on 17/07/23.
//

import Foundation

extension HomeViewContoller {
    
    @IBAction func openAdminMenuDropDwon(sender: UIButton) {
        self.rolesTextField.text = ""
        let rolesArray = ["Admin"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics
            self.rolesTextField.text  = allClinics
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            selectionMenu.dismissAutomatically = true
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
    @IBAction func textFieldOpenDropDownClinincs(sender: UIButton) {
        if selectedClincs.count == 0 {
            self.clincsTextField.text = ""
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allClinics, cellType: .subTitle) { (cell, allClinics, indexPath) in
            cell.textLabel?.text = allClinics.name
        }
        
        selectionMenu.setSelectedItems(items: selectedClincs) { [weak self] (selectedItem, index, selected, selectedList) in
            self?.clincsTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedClincIds = selectedId
            self?.selectedClincs  = selectedList
            self?.view.ShowSpinner()
            self?.viewModel?.getallServiceCategories(SelectedClinics: selectedId)
        }
        selectionMenu.reloadInputViews()
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allClinics.count * 44))), arrowDirection: .up), from: self)
    }
    
    
    @IBAction func textFieldOpenDropDownServiceCategories(sender: UIButton) {
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allServiceCategories, cellType: .subTitle) { (cell, serviceCategories, indexPath) in
            cell.textLabel?.text = serviceCategories.name
        }
        
        selectionMenu.setSelectedItems(items: selectedServiceCategories) { [weak self] (selectedItem, index, selected, selectedList) in
            
            self?.serviceCategoriesTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedServiceCategoriesIds = selectedId
            self?.selectedServiceCategories = selectedList
            
            self?.view.ShowSpinner()
            self?.viewModel?.getallService(SelectedCategories: selectedId)
        }
        
        selectionMenu.showEmptyDataLabel(text: "No Result Found")
        selectionMenu.cellSelectionStyle = .checkbox
        if self.allServiceCategories.count >= 6 {
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allServiceCategories.count) * 44)), arrowDirection: .down), from: self)
        } else {
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allServiceCategories.count) * 44)), arrowDirection: .up), from: self)
        }
    }
    
    @IBAction func textFieldOpenDropDownServices(sender: UIButton) {
        if allService.count == 0 {
            self.servicesTextField.text = ""
        }
        
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: allService, cellType: .subTitle) { (cell, allServices, indexPath) in
            cell.textLabel?.text = allServices.name
        }
        
        selectionMenu.setSelectedItems(items: selectedService) { [weak self] (text, index, selected, selectedList) in
            let selectedId = selectedList.map({$0.id ?? 0})
            self?.selectedServiceIds = selectedId
            self?.selectedService = selectedList
            self?.servicesTextField.text = selectedList.map({$0.name ?? String.blank}).joined(separator: ", ")
        }
        selectionMenu.showEmptyDataLabel(text: "No Services Found")
        selectionMenu.cellSelectionStyle = .checkbox
        
        if self.allService.count >= 2 {
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allService.count) * 44)), arrowDirection: .down), from: self)
        }else{
            selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: sender.frame.width, height: (Double(allService.count) * 44)), arrowDirection: .up), from: self)
        }
    }
    
}
