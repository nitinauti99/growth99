//
//  TriggersListViewController.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol TriggersListViewContollerProtocol: AnyObject {
    func triggersDataRecived()
    func triggersSwitchActiveDataRecived(responseMessage: String)
    func errorReceived(error: String)
    func triggerRemovedSuccefully(message: String)
}

class TriggersListViewController: UIViewController, TriggersListViewContollerProtocol {
    
    @IBOutlet weak var triggersListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var triggerSegmentControl: UISegmentedControl!
    
    var viewModel: TriggersListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [TriggersListModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getTriggersList()
        self.registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = TriggersListViewModel(delegate: self)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.triggersList
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addButtonTapped), imageName: "add")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let addEventVC = UIStoryboard(name: "TriggerDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "TriggerDetailViewController") as! TriggerDetailViewController
        self.navigationController?.pushViewController(addEventVC, animated: true)
    }
    
    @IBAction func triggerSegmentSelection(_ sender: Any) {
        self.triggersListTableView.setContentOffset(.zero, animated: true)
        clearSearchBar()
    }
    
    func clearSearchBar() {
        isSearch = false
        searchBar.text = ""
        triggersListTableView.reloadData()
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
        self.triggersListTableView.delegate = self
        self.triggersListTableView.dataSource = self
        triggersListTableView.register(UINib(nibName: "LeadTriggersTableViewCell", bundle: nil), forCellReuseIdentifier: "LeadTriggersTableViewCell")
    }
    
    @objc func getTriggersList() {
        self.view.ShowSpinner()
        viewModel?.getTriggersList()
    }
    
    func triggersDataRecived() {
        self.view.HideSpinner()
        clearSearchBar()
        self.triggersListTableView.setContentOffset(.zero, animated: true)
        self.triggersListTableView.reloadData()
    }
    
    func triggersSwitchActiveDataRecived(responseMessage: String) {
        self.view.HideSpinner()
        viewModel?.getTriggersList()
        self.view.showToast(message: responseMessage, color: UIColor().successMessageColor())
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .red)
    }
}

extension TriggersListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getTriggersFilterData(searchText: searchText)
        isSearch = true
        triggersListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        triggersListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
