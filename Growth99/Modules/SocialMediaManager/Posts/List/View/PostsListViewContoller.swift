//
//  PostsViewController.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation
import UIKit

protocol PostsListViewContollerProtocol: AnyObject {
    func postListDataRecived()
    func errorReceived(error: String)
}

class PostsListViewContoller: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var viewModel: PostsListViewModelProtocol?
    var isSearch : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.postLibrary
        self.viewModel = PostsListViewModel(delegate: self)
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getPostsListData.count ?? 0)
        self.setBarButton()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getPostsList()
        self.registerTableView()
    }
    
    func addSerchBar(){
        self.searchBar.searchBarStyle = UISearchBar.Style.default
        self.searchBar.placeholder = "Search..."
        self.searchBar.sizeToFit()
        self.searchBar.isTranslucent = false
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PostsListTableViewCell", bundle: nil), forCellReuseIdentifier: "PostsListTableViewCell")
    }
    
    func setBarButton(){
        self.navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatPost), imageName: "add")
    }

    
    @objc func creatPost() {
        let createPostVC = UIStoryboard(name: "CreatePostViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        self.navigationController?.pushViewController(createPostVC, animated: true)
    }
  
}

extension PostsListViewContoller: PostsListViewContollerProtocol {
   
    func postListDataRecived() {
        self.view.HideSpinner()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getPostsListData.count ?? 0)
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}


extension PostsListViewContoller: PostsListTableViewCellDelegate {
    
    func editPosts(cell: PostsListTableViewCell, index: IndexPath) {
        let createPostVC = UIStoryboard(name: "CreatePostViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        createPostVC.screenName = "Edit"
        if self.isSearch {
            createPostVC.postId = viewModel?.postsFilterListDataAtIndex(index: index.row)?.id ?? 0
            self.navigationController?.pushViewController(createPostVC, animated: true)
        }else{
            createPostVC.postId = viewModel?.postsListDataAtIndex(index: index.row)?.id ?? 0
            self.navigationController?.pushViewController(createPostVC, animated: true)
        }
    }
    
    func deletePosts(cell: PostsListTableViewCell, index: IndexPath) {
        
    }
    
    func approvePosts(cell: PostsListTableViewCell, index: IndexPath) {
        
    }
    
    func postedPosts(cell: PostsListTableViewCell, index: IndexPath) {
        let createPostVC = UIStoryboard(name: "CreatePostViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        createPostVC.isPosted = true
        
        if self.isSearch {
            createPostVC.postId = viewModel?.postsFilterListDataAtIndex(index: index.row)?.id ?? 0
            self.navigationController?.pushViewController(createPostVC, animated: true)
        }else{
            createPostVC.postId = viewModel?.postsListDataAtIndex(index: index.row)?.id ?? 0
            self.navigationController?.pushViewController(createPostVC, animated: true)
        }
    }
   
}
