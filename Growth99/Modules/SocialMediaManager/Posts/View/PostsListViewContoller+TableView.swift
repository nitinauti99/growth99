//
//  PostsListViewContoller+TableView.swift
//  Growth99
//
//  Created by Nitin Auti on 18/03/23.
//

import Foundation
import UIKit

extension PostsListViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getPostsListData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PostsListTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "PostsListTableViewCell") as! PostsListTableViewCell
        cell.delegate = self
        cell.configureCell(userVM: viewModel, index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if isSearch {
//            let PeteintDetail = PeteintDetailView.viewController()
//            PeteintDetail.workflowTaskPatientId = viewModel?.pateintFilterDataAtIndex(index: indexPath.row)?.id ?? 0
//            self.navigationController?.pushViewController(PeteintDetail, animated: true)
//        }else{
//            let PeteintDetail = PeteintDetailView.viewController()
//            PeteintDetail.workflowTaskPatientId = viewModel?.pateintDataAtIndex(index: indexPath.row)?.id ?? 0
//            self.navigationController?.pushViewController(PeteintDetail, animated: true)
//        }
    }
    
}
