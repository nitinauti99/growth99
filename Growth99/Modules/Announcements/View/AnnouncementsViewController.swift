//
//  AnnouncementsViewController.swift
//  Growth99
//
//  Created by Sravan Goud on 05/03/23.
//

import UIKit

protocol AnnouncementsViewContollerProtocol: AnyObject {
    func announcementsDataRecived()
    func errorReceived(error: String)
}

class AnnouncementsViewController: UIViewController, AnnouncementsViewContollerProtocol {
    
    @IBOutlet weak var announcementsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: AnnouncementsViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [AnnouncementsModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getAnnouncements()
        self.registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = AnnouncementsViewModel(delegate: self)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.announcements
    }

    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = Constant.Profile.searchList
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    
    func registerTableView() {
        self.announcementsTableView.delegate = self
        self.announcementsTableView.dataSource = self
        announcementsTableView.register(UINib(nibName: "AnnouncementsTableViewCell", bundle: nil), forCellReuseIdentifier: "AnnouncementsTableViewCell")
    }
    
    @objc func getAnnouncements() {
        self.view.ShowSpinner()
        viewModel?.getAnnouncements()
    }
    
    func announcementsDataRecived() {
        self.view.HideSpinner()
        self.announcementsTableView.setContentOffset(.zero, animated: true)
        self.announcementsTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension AnnouncementsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getAnnouncementsFilterData(searchText: searchText)
        isSearch = true
        announcementsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        announcementsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
