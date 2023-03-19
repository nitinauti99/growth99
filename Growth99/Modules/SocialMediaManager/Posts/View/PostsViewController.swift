//
//  PostsViewController.swift
//  Growth99
//
//  Created by Apple on 16/03/23.
//

import Foundation
import UIKit

protocol PostsListViewContollerProtocol: AnyObject {
    func LeadDataRecived()
    func errorReceived(error: String)
    func pateintRemovedSuccefully(mrssage: String)
}

class PostsListViewContoller: UIViewController, PostsListViewContollerProtocol, PostsListTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!

    var viewModel: PostsListViewModelProtocol?
    var isSearch : Bool = false
    var pateintFilterData = [PostsListModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Profile.pateint
        self.viewModel = PostsListViewModel(delegate: self)
        self.setBarButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getPostsList()
        self.registerTableView()
    }
    
    func registerTableView() {
        self.pateintListTableView.delegate = self
        self.pateintListTableView.dataSource = self
        pateintListTableView.register(UINib(nibName: "PostsListTableViewCell", bundle: nil), forCellReuseIdentifier: "PostsListTableViewCell")
    }
    
    func setBarButton(){
        self.navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(creatUser), imageName: "add")
    }
    
    @objc func updateUI(){
        self.getPostsList()
        self.view.ShowSpinner()
    }
    
    func addSerchBar(){
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getPostsList()
    }

    @objc func creatUser() {
        let createUserVC = UIStoryboard(name: "CreatePostsViewContoller", bundle: nil).instantiateViewController(withIdentifier: "CreatePostsViewContoller") as! CreatePostsViewContoller
        self.navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    func removePatieint(cell: PostsListTableViewCell, index: IndexPath) {
        let alert = UIAlertController(title: "Delete Patient", message: "Are you sure you want to delete \n\(viewModel?.pateintDataAtIndex(index: index.row)?.name ?? String.blank)", preferredStyle: UIAlertController.Style.alert)
        let cancelAlert = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default,
                                      handler: { [weak self] _ in
            self?.view.ShowSpinner()
            let pateintId = self?.viewModel?.pateintDataAtIndex(index: index.row)?.id ?? 0
            self?.viewModel?.removePostss(pateintId: pateintId)
        })
        cancelAlert.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(cancelAlert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @objc func getPostsList() {
        self.view.ShowSpinner()
        viewModel?.getPostsList()
    }
    
    func pateintRemovedSuccefully(mrssage: String){
        viewModel?.getPostsList()
        self.view.showToast(message: mrssage, color: .black)
    }

    func editPatieint(cell: PostsListTableViewCell, index: IndexPath) {
        let editVC = UIStoryboard(name: "PostsEditViewController", bundle: nil).instantiateViewController(withIdentifier: "PostsEditViewController") as! PostsEditViewController
        editVC.pateintId = viewModel?.pateintDataAtIndex(index: index.row)?.id ?? 0
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func detailPatieint(cell: PostsListTableViewCell, index: IndexPath) {
        let PeteintDetail = PeteintDetailView.viewController()
        PeteintDetail.workflowTaskPatientId = viewModel?.pateintDataAtIndex(index: index.row)?.id ?? 0
        self.navigationController?.pushViewController(PeteintDetail, animated: true)
    }
    
    func LeadDataRecived() {
        self.view.HideSpinner()
        self.pateintListTableView.reloadData()
        if viewModel?.getPostsData.count == 0 {
            self.emptyMessage(parentView: self.view, message: "There is no data to show")
        }
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}
