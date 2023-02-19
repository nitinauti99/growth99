//
//  ServicesListViewController.swift
//  Growth99
//
//  Created by admin on 06/01/23.
//

import UIKit

protocol ServicesListViewContollerProtocol: AnyObject {
    func serviceListDataRecived()
    func errorReceived(error: String)
}

class ServicesListViewController: UIViewController, ServicesListViewContollerProtocol {
    
    @IBOutlet private weak var servicesListTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: ServiceListViewModelProtocol?
    var isSearch : Bool = false
    var filteredTableData = [ServiceList]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addSerchBar()
        self.getUserList()
        self.registerTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ServiceListViewModel(delegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: Notification.Name("NotificationLeadList"), object: nil)
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        self.title = Constant.Profile.services
        navigationItem.rightBarButtonItem = UIButton.barButtonTarget(target: self, action: #selector(addButtonTapped), imageName: "add")
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        guard let createServiceVC = UIViewController.loadStoryboard("ServicesListDetailViewController", "ServicesListDetailViewController") as? ServicesListDetailViewController else {
            fatalError("Failed to load ServicesListDetailViewController from storyboard.")
        }
        createServiceVC.screenTitle = Constant.Profile.createService
        self.navigationController?.pushViewController(createServiceVC, animated: true)
    }
    
    func addEditServicesView() {
        
    }
    
    @objc func updateUI() {
        self.getUserList()
        self.view.ShowSpinner()
    }
    
    func addSerchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    @objc func LeadList() {
        self.view.ShowSpinner()
        self.getUserList()
    }
    
    func getListFromServer(_ pageNumber: Int){
        self.view.ShowSpinner()
        viewModel?.getServiceList()
    }
    
    func registerTableView() {
        self.servicesListTableView.delegate = self
        self.servicesListTableView.dataSource = self
        servicesListTableView.register(UINib(nibName: "ServicesListTableViewCell", bundle: nil), forCellReuseIdentifier: "ServicesListTableViewCell")
    }
    
    @objc func getUserList(){
        self.view.ShowSpinner()
        viewModel?.getServiceList()
    }
    
    func serviceListDataRecived() {
        self.view.HideSpinner()
        self.servicesListTableView.setContentOffset(.zero, animated: false)
        self.servicesListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error, color: .black)
    }
}

extension ServicesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            if viewModel?.getServiceFilterListData.count ?? 0 == 0 {
                self.servicesListTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.servicesListTableView.restore()
            }
            return viewModel?.getServiceFilterListData.count ?? 0
        } else {
            if viewModel?.getServiceListData.count ?? 0 == 0 {
                self.servicesListTableView.setEmptyMessage(Constant.Profile.tableViewEmptyText)
            } else {
                self.servicesListTableView.restore()
            }
            return viewModel?.getServiceListData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ServicesListTableViewCell()
        cell = servicesListTableView.dequeueReusableCell(withIdentifier: "ServicesListTableViewCell") as! ServicesListTableViewCell
        if isSearch {
            cell.configureCell(serviceFilterList: viewModel, index: indexPath, isSearch: isSearch)
        } else {
            cell.configureCell(serviceListData: viewModel, index: indexPath)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let createServiceVC = UIViewController.loadStoryboard("ServicesListDetailViewController", "ServicesListDetailViewController") as? ServicesListDetailViewController else {
            fatalError("Failed to load ServicesListDetailViewController from storyboard.")
        }
        createServiceVC.screenTitle = Constant.Profile.editService
        if isSearch {
            createServiceVC.serviceId = viewModel?.getServiceFilterListData[indexPath.row].id
        } else {
            createServiceVC.serviceId = viewModel?.getServiceListData[indexPath.row].id
        }
        self.navigationController?.pushViewController(createServiceVC, animated: true)
    }
}

extension ServicesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.getServiceFilterData(searchText: searchText)
        isSearch = true
        servicesListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        servicesListTableView.reloadData()
    }
}

