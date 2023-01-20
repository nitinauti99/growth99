//
//  PateintListViewContoller+TableView.swift
//  Growth99
//
//  Created by nitin auti on 19/01/23.
//

import Foundation
import UIKit

extension PateintListViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
           return filteredTableData.count
        }else{
            return viewModel?.UserData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PateintListTableViewCell()
        cell = pateintListTableView.dequeueReusableCell(withIdentifier: "PateintListTableViewCell") as! PateintListTableViewCell
        if isSearch {
            cell.configureCell(userVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(userVM: viewModel, index: indexPath)

        }
        cell.editButtonAction.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "PateintDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "PateintDetailViewController") as! PateintDetailViewController
        detailController.pateintId = viewModel?.userDataAtIndex(index: indexPath.row)?.id ?? 0
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let contextItem = UIContextualAction(style: .destructive, title: "") {  (action, view, boolValue) in
                //Code I want to do here
            }
        
        contextItem.image = UIImage(named: "Delete")
        contextItem.backgroundColor = UIColor.white

        
        let edit = UIContextualAction(style: .destructive, title: "") {  (action, view, boolValue) in
            //Code I want to do here
        }
        edit.image = UIImage(named: "Edit")
        edit.backgroundColor = UIColor.white

        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem, edit])

        return swipeActions
    }
}
