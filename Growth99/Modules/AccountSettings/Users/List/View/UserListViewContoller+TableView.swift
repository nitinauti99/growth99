//
//  UserListViewContoller+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 03/03/23.
//

import Foundation
import UIKit

extension UserListViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.UserFilterDataData.count ?? 0
        } else {
            return viewModel?.UserData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UserListTableViewCell()
        cell = userListTableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell") as! UserListTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCell(userVM: viewModel, index: indexPath, isSearch: isSearch)
        }else{
            cell.configureCell(userVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  UserRepository.shared.screenTitle == "Profile" {
            if isSearch {
                UserRepository.shared.userVariableId = viewModel?.userFilterDataDataAtIndex(index: indexPath.row)?.id ?? 0
                UserRepository.shared.firstName = viewModel?.userFilterDataDataAtIndex(index: indexPath.row)?.firstName ?? ""
                UserRepository.shared.lastName = viewModel?.userFilterDataDataAtIndex(index: indexPath.row)?.lastName ?? ""
            } else {
                UserRepository.shared.userVariableId = viewModel?.userDataAtIndex(index: indexPath.row)?.id ?? 0
                UserRepository.shared.firstName = viewModel?.userDataAtIndex(index: indexPath.row)?.firstName ?? ""
                UserRepository.shared.lastName = viewModel?.userDataAtIndex(index: indexPath.row)?.lastName ?? ""
            }
            self.navigationController?.popViewController(animated: true)
            
        } else {
            guard let homeVC = UIStoryboard(name: "BaseTabbar", bundle: nil).instantiateViewController(withIdentifier: "HomeViewContoller") as? HomeViewContoller else {
                return
            }
            if isSearch {
                UserRepository.shared.userVariableId = viewModel?.userFilterDataDataAtIndex(index: indexPath.row)?.id ?? 0
                UserRepository.shared.firstName = viewModel?.userFilterDataDataAtIndex(index: indexPath.row)?.firstName ?? ""
                UserRepository.shared.lastName = viewModel?.userFilterDataDataAtIndex(index: indexPath.row)?.lastName ?? ""
            } else {
                UserRepository.shared.userVariableId = viewModel?.userDataAtIndex(index: indexPath.row)?.id ?? 0
                UserRepository.shared.firstName = viewModel?.userDataAtIndex(index: indexPath.row)?.firstName ?? ""
                UserRepository.shared.lastName = viewModel?.userDataAtIndex(index: indexPath.row)?.lastName ?? ""
            }
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
}
