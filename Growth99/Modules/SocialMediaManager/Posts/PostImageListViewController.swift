//
//  PostImageListViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 25/03/23.
//

import Foundation

protocol PostImageListViewControllerProtocol: AnyObject {
    func socialPostImageFromLbrariesListRecived()
    func errorReceived(error: String)
}

class PostImageListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    var viewModel: CreatePostViewModelProtocol?
    
    let page: Int? = 0
    var size: Int? = 10
    var search: String? = ""
    var tags = Int()
    
    func setuViewModel(viewModel: CreatePostViewModelProtocol?){
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getSocialPostImageList.count ?? 0)
        self.title = Constant.Profile.postLibrary
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getSocialPostImageFromLbrariesList(page: page ?? 0, size: size ?? 10, search: search ?? "", tags: 0)
        self.registerTableView()
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PostImageListTableViewCell", bundle: nil), forCellReuseIdentifier: "PostImageListTableViewCell")
    }
    
}

extension PostImageListViewController: PostImageListViewControllerProtocol {

    func socialPostImageFromLbrariesListRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
