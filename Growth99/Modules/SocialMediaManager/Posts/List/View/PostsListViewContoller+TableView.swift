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
        if isSearch {
            return viewModel?.getPostsFilterListData.count ?? 0
        }else{
            return viewModel?.getPostsListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = PostsListTableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "PostsListTableViewCell") as! PostsListTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCellWithSearch(userVM: viewModel, index: indexPath)
        }else{
            cell.configureCell(userVM: viewModel, index: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createPostVC = UIStoryboard(name: "CreatePostViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        createPostVC.screenName = "Edit"
        if self.isSearch {
            createPostVC.postId = viewModel?.postsFilterListDataAtIndex(index: indexPath.row)?.id ?? 0
            self.navigationController?.pushViewController(createPostVC, animated: true)
        }else{
            createPostVC.postId = viewModel?.postsListDataAtIndex(index: indexPath.row)?.id ?? 0
            self.navigationController?.pushViewController(createPostVC, animated: true)
        }
    }
    
}
