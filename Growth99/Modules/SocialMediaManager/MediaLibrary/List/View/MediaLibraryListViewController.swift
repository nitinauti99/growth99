//
//  MediaLibraryViewController.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import UIKit

protocol MediaLibraryListViewControllerProtocol: AnyObject {
    func socialMediaLibrariesListRecived()
    func socialMediaLibrariesRemovedSuccefully(message: String)
    func errorReceived(error: String)
}

class MediaLibraryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: MediaLibraryListViewModelProtocol?
    let page: Int? = 0
    var size: Int? = 10
    var search: String? = ""
    var tags = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.postLibrary
        self.viewModel = MediaLibraryListViewModel(delegate: self)
        self.setBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getSocialMediaLibrariesList(page: page ?? 0, size: size ?? 10, search: search ?? "", tags: 0)
        self.registerTableView()
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MediaLibraryListTableViewCell", bundle: nil), forCellReuseIdentifier: "MediaLibraryListTableViewCell")
    }
    
    func setBarButton(){
        self.navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatPost), imageName: "add")
    }
    
    @objc func creatPost() {
        let mediaTagsListVC = UIStoryboard(name: "MediaTagsListViewController", bundle: nil).instantiateViewController(withIdentifier: "MediaTagsListViewController") as! MediaTagsListViewController
        self.navigationController?.pushViewController(mediaTagsListVC, animated: true)
    }
    
}

extension MediaLibraryListViewController: MediaLibraryListViewControllerProtocol {
    
    func socialMediaLibrariesListRecived() {
        self.view.HideSpinner()
        self.tableView.reloadData()
    }
    
    func socialMediaLibrariesRemovedSuccefully(message: String) {
        
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}


extension MediaLibraryListViewController: MediaLibraryListTableViewCellDelegate {
    
    func removeMediaLibrary(cell: MediaLibraryListTableViewCell, index: IndexPath){
         
    }
    
    func editMediaLibrary(cell: MediaLibraryListTableViewCell, index: IndexPath){
        
    }
    
}
