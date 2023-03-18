//
//  SocialProfilesListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 18/03/23.
//

import Foundation
import UIKit

extension SocialProfilesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return viewModel?.getSocialProfilesFilterData.count ?? 0
        } else {
            return viewModel?.getSocialProfilesData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SocialProfilesListTableViewCell", for: indexPath) as? SocialProfilesListTableViewCell else { return UITableViewCell() }

        cell.delegate = self
        if isSearch {
            cell.configureCell(socialProfileVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(socialProfileVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = UIStoryboard(name: "CreateSocialProfileViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateSocialProfileViewController") as! CreateSocialProfileViewController
        detailController.socialProfilesScreenName = "Edit Screen"

        if self.isSearch {
            detailController.socialProfileId = viewModel?.socialProfilesFilterListDataAtIndex(index: indexPath.row)?.id ?? 0
        }else{
            detailController.socialProfileId = viewModel?.socialProfilesListDataAtIndex(index: indexPath.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
}
