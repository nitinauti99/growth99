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
    var page: Int? = 0
    var size: Int? = 10
    var search: String? = ""
    var tags = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getSocialMediaLibrariesData.count ?? 0)
        self.title = Constant.Profile.MediaLibrary
        self.viewModel = MediaLibraryListViewModel(delegate: self)
        self.setBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.ShowSpinner()
        self.viewModel?.getSocialMediaLibrariesList(page: page ?? 0, size: size ?? 10, search: search ?? "", tags: 0)
        self.registerTableView()
    }
    
    @IBAction func serachleadList(sender: UIButton) {
        if searchBar.text == "" {
            return
        }
        self.view.ShowSpinner()
        self.viewModel?.getSocialMediaLibrariesList(page: page ?? 0, size: size ?? 10, search: searchBar.text  ?? "", tags: 0)
    }
    
    func registerTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MediaLibraryListTableViewCell", bundle: nil), forCellReuseIdentifier: "MediaLibraryListTableViewCell")
    }
    
    func setBarButton(){
        self.navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatPost), imageName: "add")
    }
    
    @objc func creatPost(sender: UIButton) {
        let rolesArray = ["Add Image", "Add Tags"]
       
        let selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: rolesArray, cellType: .subTitle) { (cell, taskUserList, indexPath) in
            cell.textLabel?.text = taskUserList
        }
        selectionMenu.setSelectedItems(items: []) { [weak self] (text, index, selected, selectedList) in
            print(text ?? "")
            if text == "Add Tags" {
                let mediaTagsListVC = UIStoryboard(name: "MediaTagsListViewController", bundle: nil).instantiateViewController(withIdentifier: "MediaTagsListViewController") as! MediaTagsListViewController
                self?.navigationController?.pushViewController(mediaTagsListVC, animated: true)
            }else{
                let mediaLibraryAddVC = UIStoryboard(name: "MediaLibraryAddViewController", bundle: nil).instantiateViewController(withIdentifier: "MediaLibraryAddViewController") as! MediaLibraryAddViewController
                self?.navigationController?.pushViewController(mediaLibraryAddVC, animated: true)
            }
        }
        selectionMenu.tableView?.selectionStyle = .single
        selectionMenu.show(style: .popover(sourceView: sender, size: CGSize(width: 150, height: (Double(rolesArray.count * 44))), arrowDirection: .up), from: self)
    }
    
}

extension MediaLibraryListViewController: MediaLibraryListViewControllerProtocol {
    
    func socialMediaLibrariesListRecived() {
        self.view.HideSpinner()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getSocialMediaLibrariesData.count ?? 0)
        self.tableView.reloadData()
    }
    
    func socialMediaLibrariesRemovedSuccefully(message: String) {
        self.view.HideSpinner()
        self.view.showToast(message: message, color: UIColor().successMessageColor())
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}


extension MediaLibraryListViewController: MediaLibraryListTableViewCellDelegate {
    
    func removeMediaLibrary(cell: MediaLibraryListTableViewCell, index: IndexPath){
        var mediaLibraryId = self.viewModel?.socialMediaLibrariesListDataAtIndex(index: index.row)?.id ?? 0
        var mediaLibraryName = self.viewModel?.socialMediaLibrariesListDataAtIndex(index: index.row)?.filename ?? String.blank

        let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete \n\(mediaLibraryName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                        handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeSocialMediaLibraries(socialMediaLibrariesId: mediaLibraryId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func editMediaLibrary(cell: MediaLibraryListTableViewCell, index: IndexPath) {
        let detailController = UIStoryboard(name: "MediaLibraryAddViewController", bundle: nil).instantiateViewController(withIdentifier: "MediaLibraryAddViewController") as! MediaLibraryAddViewController
        detailController.mediaTagScreenName = "Edit Screen"
        detailController.mediaTagId = viewModel?.socialMediaLibrariesListDataAtIndex(index: index.row)?.id ?? 0
        navigationController?.pushViewController(detailController, animated: true)
    }
    
}
