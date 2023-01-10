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
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.triggersList
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addButtonTapped), imageName: "add")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func triggerSegmentSelection(_ sender: Any) {
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
        self.triggersListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension TriggersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredTableData.count
        } else {
            let selectedIndex = self.triggerSegmentControl.selectedSegmentIndex
            switch selectedIndex {
            case 0:
                return viewModel?.triggersData.filter({$0.moduleName == Constant.Profile.leads}).count ?? 0
            case 1:
                return viewModel?.triggersData.filter({$0.moduleName == Constant.Profile.appointmentTrigger}).count ?? 0
            default:
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = LeadTriggersTableViewCell()
        cell = triggersListTableView.dequeueReusableCell(withIdentifier: "LeadTriggersTableViewCell") as! LeadTriggersTableViewCell
        cell.delegate = self
        if isSearch {
            cell.configureCell(triggerVM: viewModel?.triggersData[indexPath.row])
        } else {
            let selectedIndex = self.triggerSegmentControl.selectedSegmentIndex
            switch selectedIndex {
            case 0:
                let filteredArray = viewModel?.triggersData.filter({$0.moduleName == Constant.Profile.leads})
                cell.configureCell(triggerVM: filteredArray?[indexPath.row])
            case 1:
                let filteredArray = viewModel?.triggersData.filter({$0.moduleName == Constant.Profile.appointmentTrigger})
                cell.configureCell(triggerVM: filteredArray?[indexPath.row])
            default:
                return UITableViewCell()
            }
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
        filteredTableData = (viewModel?.triggersData.filter { $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() })!
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
