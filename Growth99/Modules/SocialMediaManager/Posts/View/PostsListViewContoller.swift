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
        self.title = Constant.Profile.pateint
        self.viewModel = PostsListViewModel(delegate: self)
        self.setBarButton()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getPostsList()
        self.registerTableView()
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
//        let createUserVC = UIStoryboard(name: "CreatePostsViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePostsViewContoller") as! CreatePostsViewContoller
//        self.navigationController?.pushViewController(createUserVC, animated: true)
    }

    func editPatieint(cell: PostsListTableViewCell, index: IndexPath) {
//        let editVC = UIStoryboard(name: "PostsEditViewController", bundle: nil).instantiateViewController(withIdentifier: "PostsEditViewController") as! PostsEditViewController
//        editVC.pateintId = viewModel?.pateintDataAtIndex(index: index.row)?.id ?? 0
//        self.navigationController?.pushViewController(editVC, animated: true)
    }
  
}

extension PostsListViewContoller: PostsListViewContollerProtocol {
   
    func postListDataRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
        if viewModel?.getPostsListData.count == 0 {
            self.emptyMessage(parentView: self.view, message: "There is no data to show")
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}


extension PostsListViewContoller: PostsListTableViewCellDelegate {
   
    func editPosts(cell: PostsListTableViewCell, index: IndexPath) {
        
    }
    
    func detailPosts(cell: PostsListTableViewCell, index: IndexPath) {
        
    }
    
    
}
