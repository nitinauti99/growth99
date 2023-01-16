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
        self.servicesListTableView.reloadData()
    }
    
    func errorReceived(error: String) {
        self.view.HideSpinner()
        self.view.showToast(message: error)
    }
}

extension ServicesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredTableData.count
        } else {
            return viewModel?.serviceData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ServicesListTableViewCell()
        cell = servicesListTableView.dequeueReusableCell(withIdentifier: "ServicesListTableViewCell") as! ServicesListTableViewCell
        if isSearch {
            cell.configureCell(userVM: viewModel, index: indexPath)
        } else {
            cell.configureCell(userVM: viewModel, index: indexPath)
            
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
        self.navigationController?.pushViewController(createServiceVC, animated: true)
    }
}

extension ServicesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTableData = (viewModel?.serviceData.filter { $0.name?.lowercased().prefix(searchText.count) ?? "" == searchText.lowercased() })!
        isSearch = true
        servicesListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        servicesListTableView.reloadData()
    }
}

