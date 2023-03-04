//
//  TriggersListViewController.swift
//  Growth99
//
//  Created by admin on 07/01/23.
//

import UIKit

protocol TriggersListViewContollerProtocol: AnyObject {
    func TriggersDataRecived()
    func errorReceived(error: String)
}

class TriggersListViewController: UIViewController, TriggersListViewContollerProtocol {
    
    @IBOutlet private weak var triggersListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var triggerSegmentControl: UISegmentedControl!
    
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
        
    }
    
    @IBAction func triggerSegmentSelection(_ sender: Any) {
        self.triggersListTableView.setContentOffset(.zero, animated: true)
        self.triggersListTableView.reloadData()
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
    
    func TriggersDataRecived() {
        self.view.HideSpinner()
        self.triggersListTableView.setContentOffset(.zero, animated: true)
        self.triggersListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}

extension TriggersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let selectedIndex = self.triggerSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                if viewModel?.getTriggersFilterData.count ?? 0 == 0 {
                    self.triggersListTableView.setEmptyMessage()
                } else {
                    self.triggersListTableView.restore()
                }
                return viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.leads}).count ?? 0
            } else {
                if viewModel?.getTriggersData.count ?? 0 == 0 {
                    self.triggersListTableView.setEmptyMessage()
                } else {
                    self.triggersListTableView.restore()
                }
                return viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.leads}).count ?? 0
            }
        case 1:
            if isSearch {
                if viewModel?.getTriggersFilterData.count ?? 0 == 0 {
                    self.triggersListTableView.setEmptyMessage()
                } else {
                    self.triggersListTableView.restore()
                }
                return viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.appointmentTrigger}).count ?? 0
            } else {
                if viewModel?.getTriggersData.count ?? 0 == 0 {
                    self.triggersListTableView.setEmptyMessage()
                } else {
                    self.triggersListTableView.restore()
                }
                return viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.appointmentTrigger}).count ?? 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = LeadTriggersTableViewCell()
        cell = triggersListTableView.dequeueReusableCell(withIdentifier: "LeadTriggersTableViewCell") as! LeadTriggersTableViewCell
        cell.delegate = self
        let selectedIndex = self.triggerSegmentControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.leads})
                cell.configureCell(triggerFilterList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.leads})
                cell.configureCell(triggerList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            }
        case 1:
            if isSearch {
                let filteredArray = viewModel?.getTriggersFilterData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                cell.configureCell(triggerFilterList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            } else {
                let filteredArray = viewModel?.getTriggersData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                cell.configureCell(triggerList: filteredArray?[indexPath.row], index: indexPath, isSearch: isSearch)
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let createTriggersVC = UIStoryboard(name: "TriggersAddViewController", bundle: nil).instantiateViewController(withIdentifier: "TriggersAddViewController") as! TriggersAddViewController
        //        //        createTriggersVC.selectedCategoryID = viewModel?.userData[indexPath.row].id ?? 0
        //        //        createTriggersVC.screenTitle = Constant.Profile.editTriggers
        //        self.navigationController?.pushViewController(createTriggersVC, animated: true)
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
}

extension TriggersListViewController: TriggerSourceDelegate {
    
    func didTapSwitchButton(triggerId: String, triggerStatus: String) {
        self.view.ShowSpinner()
        viewModel?.getSwitchOnButton(triggerId: triggerId, triggerStatus: triggerStatus)
    }
}
