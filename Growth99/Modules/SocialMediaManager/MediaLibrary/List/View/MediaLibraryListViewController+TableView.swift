//
//  MediaLibraryListViewController+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 20/03/23.
//

import Foundation
import UIKit

extension MediaLibraryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getSocialMediaLibrariesData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "MediaLibraryListTableViewCell", for: indexPath) as? MediaLibraryListTableViewCell else { return UITableViewCell() }

        cell.delegate = self
        cell.configureCell(mediaLibraryListVM: viewModel, index: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailController = UIStoryboard(name: "CreateLabelViewController", bundle: nil).instantiateViewController(withIdentifier: "CreateLabelViewController") as! CreateLabelViewController
//        
//        detailController.screenName = "Edit Screen"
//
//        if self.isSearch {
//            detailController.labelId = viewModel?.labelFilterListDataAtIndex(index: indexPath.row)?.id ?? 0
//        }else{
//            detailController.labelId = viewModel?.labelListDataAtIndex(index: indexPath.row)?.id ?? 0
//        }
//        navigationController?.pushViewController(detailController, animated: true)
    }
}
