//
//  MediaTagsListViewController.swift
//  Growth99
//
//  Created by Nitin Auti on 21/03/23.
//

import UIKit

protocol MediaTagsListViewControllerProtocol: AnyObject {
    func mediaTagListRecived()
    func errorReceived(error: String)
    func mediaTagRemovedSuccefully(message: String)
}

class MediaTagsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: MediaTagsListViewModelProtocol?
    var isSearch : Bool = false
    var pateintId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getMediaTagsData.count ?? 0)
        self.viewModel = MediaTagsListViewModel(delegate: self)
        self.setBarButton()
    }
        
    func registerTableView() {
        self.tableView.register(UINib(nibName: "MediaTagsListTableViewCell", bundle: nil), forCellReuseIdentifier: "MediaTagsListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addSerchBar()
        self.registerTableView()
        self.view.ShowSpinner()
        self.viewModel?.getMediaTagsList()
        self.title = "Media Tags"
    }
    
    func setBarButton(){
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
    }
    
    @objc func creatUser() {
        let mediaTagsAddVC = UIStoryboard(name: "MediaTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "MediaTagsAddViewController") as! MediaTagsAddViewController
        mediaTagsAddVC.mediaTagScreenName = "Create Screen"
        self.navigationController?.pushViewController(mediaTagsAddVC, animated: true)
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
   
}
extension MediaTagsListViewController: MediaTagsListViewControllerProtocol {
    
    func mediaTagListRecived() {
        self.view.HideSpinner()
        self.tableView.setEmptyMessage(arrayCount: viewModel?.getMediaTagsData.count ?? 0)
        self.tableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
    
    func mediaTagRemovedSuccefully(message: String){
        self.view.showToast(message: message, color: UIColor().successMessageColor())
        self.viewModel?.getMediaTagsList()
    }
}

extension MediaTagsListViewController: MediaTagsListTableViewCellDelegate{
   
    func removeMediaTag(cell: MediaTagsListTableViewCell, index: IndexPath) {
        var tagName : String = ""
        var tagId: Int = 0
       
        if self.isSearch {
            tagId = self.viewModel?.mediaTagsFilterListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.mediaTagsFilterListDataAtIndex(index: index.row)?.name ?? String.blank
        }else{
            tagId = self.viewModel?.mediaTagsListDataAtIndex(index: index.row)?.id ?? 0
            tagName = self.viewModel?.mediaTagsListDataAtIndex(index: index.row)?.name ?? String.blank
        }
        
        let alert = UIAlertController(title: "Delete Media Tag", message: "Are you sure you want to delete \n\(tagName)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            self?.viewModel?.removeMediaTag(mediaId: tagId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


    func editMediaTag(cell: MediaTagsListTableViewCell, index: IndexPath) {
        let detailController = UIStoryboard(name: "MediaTagsAddViewController", bundle: nil).instantiateViewController(withIdentifier: "MediaTagsAddViewController") as! MediaTagsAddViewController
        detailController.mediaTagScreenName = "Edit Screen"
        if self.isSearch {
            detailController.mediaTagId = viewModel?.mediaTagsFilterListDataAtIndex(index: index.row)?.id ?? 0
        }else{
            detailController.mediaTagId = viewModel?.mediaTagsListDataAtIndex(index: index.row)?.id ?? 0
        }
        navigationController?.pushViewController(detailController, animated: true)
    }
}
